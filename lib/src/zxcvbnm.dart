import 'dart:async';
import 'dart:math';

import 'feedback.dart';
import 'helper.dart';
import 'matchers/base_matcher.dart';
import 'matching.dart';
import 'options.dart';
import 'scoring.dart';
import 'time_estimates.dart';

class Zxcvbnm {
  Zxcvbnm([Options? options]) : options = options ?? Options();

  final Options options;

  Result call(String password, [List<String>? userInputs]) {
    // ignore: discarded_futures
    final FutureOr<Result> result = async(password, userInputs);
    if (result is Future) {
      throw UnsupportedError('Use async method with asynchronous matchers.');
    }
    return result;
  }

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

class Result {
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

  final Feedback feedback;
  final CrackTimesSeconds crackTimesSeconds;
  final CrackTimesDisplay crackTimesDisplay;
  final int score;
  final String password;
  final double guesses;
  final double guessesLog10;
  final List<BaseMatch> sequence;
  final int calcTime;

  @override
  String toString() => '$feedback, $crackTimesSeconds, $crackTimesDisplay, '
      '$score, $password, $guesses, $guessesLog10, $sequence, $calcTime';
}
