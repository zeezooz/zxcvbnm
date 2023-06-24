import 'dart:math';

import '../data/const.dart';
import '../options.dart';
import '../types.dart';
import 'utils.dart';

/// Search - most guessable match sequence.
///
/// Takes a sequence of overlapping matches, returns the non-overlapping
/// sequence with minimum guesses. the following is a O(l_max * (n + m))
/// dynamic programming algorithm for a length-n password with m candidate
/// matches. l_max is the maximum optimal sequence length spanning each prefix
/// of the password. In practice it rarely exceeds 5 and the search terminates
/// rapidly.
///
/// The optimal "minimum guesses" sequence is here defined to be the sequence
/// that minimizes the following function:
///   g = sequenceLength! * Product(m.guesses for m in sequence) + D^(sequenceLength - 1)
///
/// where sequenceLength is the length of the sequence.
/// The factorial term is the number of ways to order sequenceLength patterns.
/// The D^(sequenceLength-1) term is another length penalty, roughly capturing
/// the idea that an attacker will try lower-length sequences first before
/// trying length-sequenceLength sequences.
///
/// For example, consider a sequence that is date-repeat-dictionary.
/// - An attacker would need to try other date-repeat-dictionary combinations,
///   hence the product term.
/// - An attacker would need to try repeat-date-dictionary,
///   dictionary-repeat-date, ..., hence the factorial term.
/// - An attacker would also likely try length-1 (dictionary) and
///   length-2 (dictionary-date) sequences before length-3. assuming at
///   minimum D guesses per pattern type, D^(sequenceLength-1) approximates
///   Sum(D^i for i in [1..sequenceLength-1].
MatchSequence mostGuessableMatchSequence(
  String password,
  List<Match> matches,
  Options options, {
  bool excludeAdditive = false,
}) {
  final ScoringHelper helper =
      ScoringHelper(password, options, excludeAdditive: excludeAdditive);
  final int passwordLength = password.length;
  // Partition matches into sublists according to ending index j.
  final List<List<Match>> matchesByJ =
      List<List<Match>>.generate(passwordLength, (int index) => <Match>[]);
  for (final Match match in matches) {
    matchesByJ[match.j].add(match);
  }
  // Small detail: for deterministic output, sort each sublist by i.
  for (final List<Match> matches in matchesByJ) {
    matches.sort((Match m1, Match m2) => m1.i - m2.i);
  }
  for (int j = 0; j < passwordLength; j++) {
    for (final Match match in matchesByJ[j]) {
      if (match.i > 0) {
        for (final int sequenceLength
            in helper.optimal[match.i - 1]?.keys ?? <int>[]) {
          helper.update(match, sequenceLength + 1);
        }
      } else {
        helper.update(match, 1);
      }
    }
    helper.bruteforceUpdate(j);
  }
  final List<MatchEstimated> optimalMatchSequence =
      helper.unwind(passwordLength);
  final int optimalSequenceLength = optimalMatchSequence.length;
  double guesses;
  if (password.isEmpty) {
    guesses = 1;
  } else {
    guesses = helper.optimal[passwordLength - 1]![optimalSequenceLength]!.g;
  }
  return MatchSequence(
    password: password,
    guesses: guesses,
    guessesLog10: log10(guesses),
    sequence: optimalMatchSequence,
  );
}

class ScoringHelper {
  ScoringHelper(
    this.password,
    this.options, {
    this.excludeAdditive = false,
  });

  final String password;
  final Options options;
  final bool excludeAdditive;
  final Map<int, Map<int, Optimal>> optimal = <int, Map<int, Optimal>>{};

  // Helper: considers whether a length-sequenceLength
  // sequence ending at match is better (fewer guesses)
  // than previously encountered sequences, updating state if so.
  void update(Match match, int sequenceLength) {
    final int j = match.j;
    final MatchEstimated matchEstimated = match.estimate(password, options);
    // We're considering a length-sequenceLength sequence ending with match:
    // obtain the product term in the minimization function by multiplying
    // match's guesses by the product of the length-(sequenceLength-1)
    // sequence ending just before match, at match.i - 1.
    final double pi = matchEstimated.guesses *
        (optimal[matchEstimated.i - 1]?[sequenceLength - 1]?.pi ?? 1);
    // Calculate the minimization function.
    double g = factorial(sequenceLength) * pi;
    if (!excludeAdditive) {
      g += pow(minGuessesBeforeGrowingSequence.toDouble(), sequenceLength - 1);
    }
    // Update state if new best.
    // First see if any competing sequences covering this prefix,
    // with sequenceLength or fewer matches,
    // fare better than this sequence. If so, skip it and return.
    bool shouldSkip = false;
    optimal[j]?.forEach((int competingPatternLength, Optimal competingOptimal) {
      if (competingPatternLength <= sequenceLength && competingOptimal.g <= g) {
        shouldSkip = true;
      }
    });
    if (!shouldSkip) {
      // This sequence might be part of the final optimal sequence.
      optimal.putIfAbsent(j, () => <int, Optimal>{})[sequenceLength] =
          Optimal(m: matchEstimated, pi: pi, g: g);
    }
  }

  // Helper: evaluate bruteforce matches ending at passwordCharIndex.
  void bruteforceUpdate(int passwordCharIndex) {
    // See if a single bruteforce match spanning the passwordCharIndex-prefix
    // is optimal.
    BruteForceMatch match = bruteforceMatch(0, passwordCharIndex);
    update(match, 1);

    for (int j = 1; j <= passwordCharIndex; j++) {
      optimal[j - 1]?.forEach((int sequenceLength, Optimal lastOptimal) {
        // Corner: an optimal sequence will never have two adjacent bruteforce
        // matches. It is strictly better to have a single bruteforce match
        // spanning the same region:
        // same contribution to the guess product with a lower length.
        // --> safe to skip those cases.
        if (lastOptimal.m is! BruteForceMatchEstimated) {
          // Generate passwordCharIndex bruteforce matches, spanning from
          // (i=1, j=passwordCharIndex) up to
          // (i=passwordCharIndex, j=passwordCharIndex).
          // See if adding these new matches to any of the sequences in
          // optimal[j-1] leads to new bests.
          match = bruteforceMatch(j, passwordCharIndex);
          // Try adding m to this length-sequenceLength sequence.
          update(match, sequenceLength + 1);
        }
      });
    }
  }

  // Helper: make bruteforce match objects spanning i to j, inclusive.
  BruteForceMatch bruteforceMatch(int i, int j) =>
      BruteForceMatch(i: i, j: j, token: password.substring(i, j + 1));

  // Helper: step backwards through optimal.m starting at the end,
  // constructing the final optimal match sequence.
  List<MatchEstimated> unwind(int passwordLength) {
    final List<MatchEstimated> optimalMatchSequence = <MatchEstimated>[];
    int j = passwordLength - 1;
    // Find the final best sequence length and score.
    int sequenceLength = 0;
    double g = double.infinity;
    optimal[j]
        ?.forEach((int candidateSequenceLength, Optimal candidateOptimal) {
      if (candidateOptimal.g < g) {
        sequenceLength = candidateSequenceLength;
        g = candidateOptimal.g;
      }
    });
    while (j >= 0) {
      final MatchEstimated match = optimal[j]![sequenceLength]!.m;
      optimalMatchSequence.add(match);
      j = match.i - 1;
      sequenceLength--;
    }
    return optimalMatchSequence.reversed.toList();
  }
}

class MatchSequence {
  MatchSequence({
    required this.password,
    required this.guesses,
    required this.guessesLog10,
    required this.sequence,
  });

  final String password;
  final double guesses;
  final double guessesLog10;
  final List<MatchEstimated> sequence;
}
