import 'dart:async';
import 'dart:math';

import '../feedback.dart';

/// The base class for a matcher.
abstract class BaseMatcher {
  /// Should return the matches for the [password].
  ///
  /// A synchronous matcher should return a list (usually of length 1) of
  /// lists of matches.
  /// An asynchronous matcher can return a list of futures that completes with
  /// a list of matches.
  List<FutureOr<List<BaseMatch>>> match(String password);
}

/// The base class for a match.
abstract class BaseMatch {
  /// Creates a match.
  BaseMatch({
    required this.password,
    required this.start,
    required this.end,
  });

  /// Should return the estimated number of guesses for the [token].
  double get estimatedGuesses;

  /// Should return the warning and suggestions regarding this match.
  Feedback? feedback({required bool isSoleMatch});

  /// The password that is being matched.
  final String password;

  /// The index in the [password] where the [token] starts.
  final int start;

  /// The index in the [password] after the last character of the [token].
  final int end;

  /// The matched part of the [password].
  String get token => password.substring(start, end);

  /// The length of the [token].
  int get length => end - start;

  /// The number of guesses for the [token].
  double get guesses => _guesses ??= max(estimatedGuesses, minGuesses);

  double? _guesses;

  /// The minimum number of guesses for the [token].
  double get minGuesses {
    double minGuesses = 1;
    if (length < password.length) {
      if (length == 1) {
        minGuesses = minGuessesForSingleChar;
      } else {
        minGuesses = minGuessesForMultiChar;
      }
    }
    return minGuesses;
  }

  /// The minimum number of guesses for a match of length 1.
  double get minGuessesForSingleChar => 10;

  /// The minimum number of guesses for a match longer than 1.
  double get minGuessesForMultiChar => 50;

  @override
  String toString() => '$runtimeType "$password"[$start:$end]="$token", '
      'guesses: $guesses';
}
