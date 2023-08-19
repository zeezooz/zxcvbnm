import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';
import 'package:zxcvbnm/src/types.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

void main() {
  group('Async matcher.', () {
    final Options options = Options(
      translation: translation,
      matchers: <MatchingType>[MatchAsync()],
      dictionaries: dictionaries,
      graph: adjacencyGraph,
    );
    final Zxcvbnm zxcvbnm = Zxcvbnm(options);

    test(
      'Should use async matcher as a future.',
      () async => expect(
        zxcvbnm.async('ep8fkw8ds'),
        completes,
      ),
    );

    test(
      'Should throw an error for wrong function usage.',
      () => expect(
        () => zxcvbnm('ep8fkw8ds'),
        throwsUnsupportedError,
      ),
    );
  });
}

class MatchAsync extends MatchingType {
  @override
  List<Future<List<Match>>> match(String password) {
    return <Future<List<Match>>>[
      Future<List<Match>>.delayed(
        Duration(seconds: 2),
        () => <Match>[
          AsyncMatch(
            i: 0,
            j: password.length - 1,
            token: password,
          ),
        ],
      ),
    ];
  }
}

class AsyncMatch extends Match {
  const AsyncMatch({
    required int i,
    required int j,
    required String token,
  }) : super(i: i, j: j, token: token);

  @override
  AsyncMatchEstimated estimate(String password, Options options) {
    if (this is AsyncMatchEstimated) return this as AsyncMatchEstimated;
    final double guesses = max(token.length * 10, getMinGuesses(password));
    return AsyncMatchEstimated(
      i: i,
      j: j,
      token: token,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

class AsyncMatchEstimated extends MatchEstimated implements AsyncMatch {
  const AsyncMatchEstimated({
    required int i,
    required int j,
    required String token,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  AsyncMatchEstimated estimate(String password, Options options) => this;

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return Feedback(warning: 'So async.');
  }
}
