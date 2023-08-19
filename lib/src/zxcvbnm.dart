import 'dart:async';
import 'dart:math';

import 'feedback.dart';
import 'helper.dart';
import 'matching.dart';
import 'options.dart';
import 'scoring/index.dart';
import 'time_estimates.dart';
import 'types.dart';

class Zxcvbnm {
  Zxcvbnm([Options? options]) : options = options ?? Options();

  final Options options;

  Result call(String password, [List<Object>? userInputs]) {
    // ignore: discarded_futures
    final FutureOr<Result> result = async(password, userInputs);
    if (result is Future) {
      throw UnsupportedError('Use async method with asynchronous matchers.');
    }
    return result;
  }

  FutureOr<Result> async(String password, [List<Object>? userInputs]) {
    final int startTime = _time();
    final String usedPassword =
        password.substring(0, min(options.maxLength, password.length));
    final Options runOptions = options.copyWith(userInputs: userInputs);
    final OmniMatch omniMatch = OmniMatch(runOptions);
    final List<FutureOr<List<Match>>> result = omniMatch.match(usedPassword);
    final List<Match> matches = synchronousMatches(result);
    final List<Future<List<Match>>> futures = asynchronousMatches(result);
    if (futures.isEmpty) {
      return _returnValue(runOptions, matches, usedPassword, startTime);
    }
    return Future.wait(futures).then((List<List<Match>> results) {
      for (final List<Match> result in results) {
        matches.addAll(result);
      }
      return _returnValue(runOptions, matches, usedPassword, startTime);
    });
  }

  int _time() => DateTime.now().millisecondsSinceEpoch;

  Result _returnValue(
    Options options,
    List<Match> matches,
    String password,
    int startTime,
  ) {
    final MatchSequence matchSequence = mostGuessableMatchSequence(
      password,
      matches,
      options,
    );
    final TimeEstimates timeEstimates = TimeEstimates(options);
    final AttackTimes attackTimes =
        timeEstimates.estimateAttackTimes(matchSequence.guesses);
    final Feedback feedback = Feedback.fromMatches(
      attackTimes.score,
      matchSequence.sequence,
      options,
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
