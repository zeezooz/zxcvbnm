import 'dart:math';

import '../matchers/base_matcher.dart';
import '../matchers/brute_force_matcher.dart';
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
///   g = sequenceLength! * Product(m.guesses for m in sequence) +
///       D^(sequenceLength - 1)
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
  List<BaseMatch> matches, {
  bool excludeAdditive = false,
}) {
  final ScoringHelper helper =
      ScoringHelper(password, excludeAdditive: excludeAdditive);
  final int passwordLength = password.length;
  // Partition matches into sublists according to ending index j.
  final List<List<BaseMatch>> matchesByJ = List<List<BaseMatch>>.generate(
    passwordLength + 1,
    (int index) => <BaseMatch>[],
  );
  for (final BaseMatch match in matches) {
    matchesByJ[match.end].add(match);
  }
  // Small detail: for deterministic output, sort each sublist by i.
  for (final List<BaseMatch> matches in matchesByJ) {
    matches.sort((BaseMatch m1, BaseMatch m2) => m1.start - m2.start);
  }
  for (int j = 1; j <= passwordLength; j++) {
    for (final BaseMatch match in matchesByJ[j]) {
      if (match.start > 0) {
        for (final int sequenceLength
            in helper.optimal[match.start]?.keys ?? <int>[]) {
          helper.update(match, sequenceLength + 1);
        }
      } else {
        helper.update(match, 1);
      }
    }
    helper.bruteforceUpdate(j);
  }
  final List<BaseMatch> optimalMatchSequence = helper.unwind(passwordLength);
  final int optimalSequenceLength = optimalMatchSequence.length;
  double guesses;
  if (password.isEmpty) {
    guesses = 1;
  } else {
    guesses = helper.optimal[passwordLength]![optimalSequenceLength]!.g;
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
    this.password, {
    this.excludeAdditive = false,
  });

  final String password;
  final bool excludeAdditive;
  final Map<int, Map<int, Optimal>> optimal = <int, Map<int, Optimal>>{};

  // Helper: considers whether a length-sequenceLength
  // sequence ending at match is better (fewer guesses)
  // than previously encountered sequences, updating state if so.
  void update(BaseMatch match, int sequenceLength) {
    final int j = match.end;
    // We're considering a length-sequenceLength sequence ending with match:
    // obtain the product term in the minimization function by multiplying
    // match's guesses by the product of the length-(sequenceLength-1)
    // sequence ending just before match, at match.i - 1.
    final double pi =
        match.guesses * (optimal[match.start]?[sequenceLength - 1]?.pi ?? 1);
    // Calculate the minimization function.
    double g = factorial(sequenceLength) * pi;
    if (!excludeAdditive) {
      g += pow(minGuessesBeforeGrowingSequence, sequenceLength - 1);
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
          Optimal(m: match, pi: pi, g: g);
    }
  }

  double get minGuessesBeforeGrowingSequence => 10000;

  // Helper: evaluate bruteforce matches ending at passwordCharIndex.
  void bruteforceUpdate(int passwordCharIndex) {
    // See if a single bruteforce match spanning the passwordCharIndex-prefix
    // is optimal.
    BruteForceMatch match = bruteforceMatch(0, passwordCharIndex);
    update(match, 1);

    for (int j = 1; j < passwordCharIndex; j++) {
      optimal[j]?.forEach((int sequenceLength, Optimal lastOptimal) {
        // Corner: an optimal sequence will never have two adjacent bruteforce
        // matches. It is strictly better to have a single bruteforce match
        // spanning the same region:
        // same contribution to the guess product with a lower length.
        // --> safe to skip those cases.
        if (lastOptimal.m is! BruteForceMatch) {
          // Generate passwordCharIndex bruteforce matches, spanning from
          // (i=1, j=passwordCharIndex) up to
          // (i=passwordCharIndex, j=passwordCharIndex).
          // See if adding these new matches to any of the sequences in
          // optimal[j] leads to new bests.
          match = bruteforceMatch(j, passwordCharIndex);
          // Try adding m to this length-sequenceLength sequence.
          update(match, sequenceLength + 1);
        }
      });
    }
  }

  // Helper: make bruteforce match objects spanning i to j, inclusive.
  BruteForceMatch bruteforceMatch(int i, int j) => BruteForceMatch(
        password: password,
        start: i,
        end: j,
      );

  // Helper: step backwards through optimal.m starting at the end,
  // constructing the final optimal match sequence.
  List<BaseMatch> unwind(int passwordLength) {
    final List<BaseMatch> optimalMatchSequence = <BaseMatch>[];
    int j = passwordLength;
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
    while (j > 0) {
      final BaseMatch match = optimal[j]![sequenceLength]!.m;
      optimalMatchSequence.add(match);
      j = match.start;
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
  final List<BaseMatch> sequence;
}
