import 'dart:async';
import 'dart:math';

import 'feedback.dart';
import 'helper.dart';
import 'matchers/base_matcher.dart';
import 'matching.dart';
import 'options.dart';
import 'scoring.dart';
import 'time_estimates.dart';

/// A password estimator.
class Zxcvbnm {
  /// Creates an estimator.
  ///
  /// If you only need to provide dictionaries, you can set them here.
  /// If you need other options too, set dictionaries only in options.
  Zxcvbnm({Set<Dictionaries>? dictionaries, Options? options})
      : assert(
          dictionaries == null || options == null,
          'Cannot set both dictionaries and options\n'
          'To set both, use "options: Options(dictionaries: dictionaries)".',
        ),
        options =
            options ?? Options(dictionaries: dictionaries ?? <Dictionaries>{});

  /// Options.
  final Options options;

  /// Estimates the [password] using only synchronous matchers.
  ///
  /// [userInputs] sets a user dictionary for this run only.
  Result call(String password, [List<String>? userInputs]) {
    // ignore: discarded_futures
    final FutureOr<Result> result = async(password, userInputs);
    if (result is Future) {
      throw UnsupportedError('Use async method with asynchronous matchers.');
    }
    return result;
  }

  /// Estimates the [password]. Works with asynchronous matchers too.
  ///
  /// [userInputs] sets a user dictionary for this run only.
  FutureOr<Result> async(String password, [List<String>? userInputs]) {
    final int startTime = _time();
    final String usedPassword =
        password.substring(0, min(options.maxLength, password.length));
    final Options runOptions = options.copyWith(userInputs: userInputs);
    final OmniMatcher omniMatcher = OmniMatcher(runOptions);
    final List<FutureOr<List<BaseMatch>>> result =
        omniMatcher.match(usedPassword);
    final List<BaseMatch> matches = synchronousMatches(result);
    final List<Future<List<BaseMatch>>> futures = asynchronousMatches(result);
    if (futures.isEmpty) {
      return _returnValue(matches, usedPassword, startTime);
    }
    return Future.wait(futures).then((List<List<BaseMatch>> results) {
      for (final List<BaseMatch> result in results) {
        matches.addAll(result);
      }
      return _returnValue(matches, usedPassword, startTime);
    });
  }

  int _time() => DateTime.now().millisecondsSinceEpoch;

  Result _returnValue(
    List<BaseMatch> matches,
    String password,
    int startTime,
  ) {
    final MatchSequence matchSequence = mostGuessableMatchSequence(
      password,
      matches,
    );
    final AttackTimes attackTimes = estimateAttackTimes(matchSequence.guesses);
    final Feedback feedback = Feedback.fromMatches(
      attackTimes.score,
      matchSequence.sequence,
    );
    final int calcTime = _time() - startTime;
    return Result(
      feedback: feedback,
      crackTimesSeconds: attackTimes.crackTimesSeconds,
      crackTimesDisplay: attackTimes.crackTimesDisplay,
      score: attackTimes.score,
      password: password,
      guesses: matchSequence.guesses,
      guessesLog10: matchSequence.guessesLog10,
      sequence: matchSequence.sequence,
      calcTime: calcTime,
    );
  }
}

/// Estimation result.
class Result {
  /// Creates a new instance.
  const Result({
    required this.feedback,
    required this.crackTimesSeconds,
    required this.crackTimesDisplay,
    required this.score,
    required this.password,
    required this.guesses,
    required this.guessesLog10,
    required this.sequence,
    required this.calcTime,
  });

  /// The feedback for the [password].
  final Feedback feedback;

  /// Estimated times in seconds.
  final CrackTimesSeconds crackTimesSeconds;

  /// Estimated times in human readable format.
  final CrackTimesDisplay crackTimesDisplay;

  /// The [password] strength from 0 (the weakest) to 4 (the strongest).
  final int score;

  /// The password that was evaluated.
  final String password;

  /// The estimated number of guesses for the [password].
  final double guesses;

  /// The logarithm with base 10 of [guesses]
  final double guessesLog10;

  /// The sequence of matches.
  final List<BaseMatch> sequence;

  /// Calculation time.
  final int calcTime;

  @override
  String toString() => '$feedback, $crackTimesSeconds, $crackTimesDisplay, '
      '$score, $password, $guesses, $guessesLog10, $sequence, $calcTime';
}
