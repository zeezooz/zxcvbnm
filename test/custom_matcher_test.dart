import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';
import 'package:zxcvbnm/src/types.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

import 'zxcvbnm_test.dart';

void main() {
  group('Custom matcher.', () {
    test(
      'Should use custom matcher.',
      () {
        final Options options = Options(
          translation: translation,
          matchers: <MatchingType>[MatchMinLength()],
          dictionaries: dictionaries,
          graph: adjacencyGraph,
        );
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('ep8fkw8ds'),
          ResultTest(
            feedback: Feedback(
              warning: 'You password is not long enough.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: CrackTimesSeconds(
              onlineThrottling100PerHour: 3276,
              onlineNoThrottling10PerSecond: 9.1,
              offlineSlowHashing1e4PerSecond: 0.0091,
              offlineFastHashing1e10PerSecond: 9.1e-9,
            ),
            crackTimesDisplay: CrackTimesDisplay(
              onlineThrottling100PerHour: '55 minutes',
              onlineNoThrottling10PerSecond: '9 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'ep8fkw8ds',
            guesses: 91,
            guessesLog10: 1.9590413923210932,
            sequence: <MinLengthMatchEstimatedTest>[
              MinLengthMatchEstimatedTest(
                i: 0,
                j: 8,
                token: 'ep8fkw8ds',
                guesses: 90,
                guessesLog10: 1.9542425094393248,
              ),
            ],
          ),
        );
      },
    );
  });
}

class MatchMinLength extends MatchingType {
  final int minLength = 10;

  @override
  List<List<Match>> match(String password) {
    final List<MinLengthMatch> matches = <MinLengthMatch>[];
    if (password.length <= minLength) {
      matches.add(
        MinLengthMatch(
          i: 0,
          j: password.length - 1,
          token: password,
        ),
      );
    }
    return <List<MinLengthMatch>>[matches];
  }
}

class MinLengthMatch extends Match {
  const MinLengthMatch({
    required int i,
    required int j,
    required String token,
  }) : super(i: i, j: j, token: token);

  @override
  MinLengthMatchEstimated estimate(String password, Options options) {
    if (this is MinLengthMatchEstimated) return this as MinLengthMatchEstimated;
    final double guesses = max(token.length * 10, getMinGuesses(password));
    return MinLengthMatchEstimated(
      i: i,
      j: j,
      token: token,
      guesses: guesses,
      guessesLog10: log10(guesses),
    );
  }
}

class MinLengthMatchEstimated extends MatchEstimated implements MinLengthMatch {
  const MinLengthMatchEstimated({
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
  MinLengthMatchEstimated estimate(String password, Options options) => this;

  @override
  Feedback? feedback(Options options, {bool? isSoleMatch}) {
    return Feedback(warning: 'You password is not long enough.');
  }
}

class MinLengthMatchEstimatedTest extends MinLengthMatchEstimated {
  MinLengthMatchEstimatedTest({
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
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is MinLengthMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10;
}
