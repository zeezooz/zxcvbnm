import 'dart:math';

import 'matchers/base_matcher.dart';
import 'matchers/brute_force_matcher.dart';
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
  final _ScoringHelper helper =
      _ScoringHelper(password, excludeAdditive: excludeAdditive);
  final int passwordLength = password.length;
  // Partition matches into sublists according to ending index.
  final List<List<BaseMatch>> matchesByEnd = List<List<BaseMatch>>.generate(
    passwordLength + 1,
    (int index) => <BaseMatch>[],
  );
  for (final BaseMatch match in matches) {
    matchesByEnd[match.end].add(match);
  }
  // Small detail: for deterministic output, sort each sublist by start.
  for (final List<BaseMatch> matches in matchesByEnd) {
    matches.sort((BaseMatch m1, BaseMatch m2) => m1.start - m2.start);
  }
  for (int end = 1; end <= passwordLength; end++) {
    for (final BaseMatch match in matchesByEnd[end]) {
      if (match.start > 0) {
        for (final int sequenceLength
            in helper.optimal[match.start]?.keys ?? <int>[]) {
          helper.update(match, sequenceLength + 1);
        }
      } else {
        helper.update(match, 1);
      }
    }
    helper.bruteforceUpdate(end);
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

class _ScoringHelper {
  _ScoringHelper(
    this.password, {
    this.excludeAdditive = false,
  });

  final String password;
  final bool excludeAdditive;
  final Map<int, Map<int, _Optimal>> optimal = <int, Map<int, _Optimal>>{};

  // Helper: considers whether a length-sequenceLength
  // sequence ending at match is better (fewer guesses)
  // than previously encountered sequences, updating state if so.
  void update(BaseMatch match, int sequenceLength) {
    final int end = match.end;
    // We're considering a length-sequenceLength sequence ending with match:
    // obtain the product term in the minimization function by multiplying
    // match's guesses by the product of the length-(sequenceLength-1)
    // sequence ending just before match, at match.start - 1.
    final double p =
        match.guesses * (optimal[match.start]?[sequenceLength - 1]?.p ?? 1);
    // Calculate the minimization function.
    double g = factorial(sequenceLength) * p;
    if (!excludeAdditive) {
      g += pow(minGuessesBeforeGrowingSequence, sequenceLength - 1);
    }
    // Update state if new best.
    // First see if any competing sequences covering this prefix,
    // with sequenceLength or fewer matches,
    // fare better than this sequence. If so, skip it and return.
    bool shouldSkip = false;
    optimal[end]
        ?.forEach((int competingPatternLength, _Optimal competingOptimal) {
      if (competingPatternLength <= sequenceLength && competingOptimal.g <= g) {
        shouldSkip = true;
      }
    });
    if (!shouldSkip) {
      // This sequence might be part of the final optimal sequence.
      optimal.putIfAbsent(end, () => <int, _Optimal>{})[sequenceLength] =
          _Optimal(m: match, p: p, g: g);
    }
  }

  double get minGuessesBeforeGrowingSequence => 10000;

  // Helper: evaluate bruteforce matches ending at passwordCharIndex.
  void bruteforceUpdate(int passwordCharIndex) {
    // See if a single bruteforce match spanning the passwordCharIndex-prefix
    // is optimal.
    BruteForceMatch match = bruteforceMatch(0, passwordCharIndex);
    update(match, 1);

    for (int start = 1; start < passwordCharIndex; start++) {
      optimal[start]?.forEach((int sequenceLength, _Optimal lastOptimal) {
        // Corner: an optimal sequence will never have two adjacent bruteforce
        // matches. It is strictly better to have a single bruteforce match
        // spanning the same region:
        // same contribution to the guess product with a lower length.
        // --> safe to skip those cases.
        if (lastOptimal.m is! BruteForceMatch) {
          // Generate passwordCharIndex bruteforce matches, spanning from
          // (start=1, end=passwordCharIndex) up to
          // (start=passwordCharIndex, end=passwordCharIndex).
          // See if adding these new matches to any of the sequences in
          // optimal[end] leads to new bests.
          match = bruteforceMatch(start, passwordCharIndex);
          // Try adding m to this length-sequenceLength sequence.
          update(match, sequenceLength + 1);
        }
      });
    }
  }

  // Helper: make bruteforce match objects spanning start to end.
  BruteForceMatch bruteforceMatch(int start, int end) {
    return BruteForceMatch(
      password: password,
      start: start,
      end: end,
    );
  }

  // Helper: step backwards through optimal.m starting at the end,
  // constructing the final optimal match sequence.
  List<BaseMatch> unwind(int passwordLength) {
    final List<BaseMatch> optimalMatchSequence = <BaseMatch>[];
    int end = passwordLength;
    // Find the final best sequence length and score.
    int sequenceLength = 0;
    double g = double.infinity;
    optimal[end]
        ?.forEach((int candidateSequenceLength, _Optimal candidateOptimal) {
      if (candidateOptimal.g < g) {
        sequenceLength = candidateSequenceLength;
        g = candidateOptimal.g;
      }
    });
    while (end > 0) {
      final BaseMatch match = optimal[end]![sequenceLength]!.m;
      optimalMatchSequence.add(match);
      end = match.start;
      sequenceLength--;
    }
    return optimalMatchSequence.reversed.toList();
  }
}

class _Optimal {
  const _Optimal({
    required this.m,
    required this.p,
    required this.g,
  });

  // Match.
  final BaseMatch m;

  // Product term Prod(m.guesses for m in sequence).
  // Allows for fast (non-looping) updates to the minimization function.
  final double p;

  // Overall metric.
  final double g;
}

/// Represents the sequence of matches.
class MatchSequence {
  /// Creates a sequence.
  MatchSequence({
    required this.password,
    required this.guesses,
    required this.guessesLog10,
    required this.sequence,
  });

  /// The password that was evaluated.
  final String password;

  /// The estimated number of guesses for the [password].
  final double guesses;

  /// The logarithm with base 10 of [guesses]
  final double guessesLog10;

  /// The sequence of matches.
  final List<BaseMatch> sequence;
}
