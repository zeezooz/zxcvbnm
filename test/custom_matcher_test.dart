import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/matchers/base_matcher.dart';
import 'package:zxcvbnm/src/options.dart';
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
          matchers: <BaseMatcher>[MatchMinLength()],
          dictionaries: dictionaries,
          graph: adjacencyGraph,
        );
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('ep8fkw8ds'),
          ResultTest(
            feedback: const Feedback(
              warning: 'Your password is not long enough.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: const CrackTimesSeconds(
              onlineThrottling100PerHour: 3276,
              onlineNoThrottling10PerSecond: 9.1,
              offlineSlowHashing1e4PerSecond: 0.0091,
              offlineFastHashing1e10PerSecond: 9.1e-9,
            ),
            crackTimesDisplay: const CrackTimesDisplay(
              onlineThrottling100PerHour: '55 minutes',
              onlineNoThrottling10PerSecond: '9 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'ep8fkw8ds',
            guesses: 91,
            guessesLog10: 1.9590413923210932,
            sequence: <MinLengthMatchTest>[
              MinLengthMatchTest(
                password: 'ep8fkw8ds',
                start: 0,
                end: 9,
                guesses: 90,
              ),
            ],
          ),
        );
      },
    );
  });
}

class MatchMinLength extends BaseMatcher {
  final int minLength = 10;

  @override
  List<List<BaseMatch>> match(String password) {
    final List<MinLengthMatch> matches = <MinLengthMatch>[];
    if (password.length <= minLength) {
      matches.add(
        MinLengthMatch(
          password: password,
          start: 0,
          end: password.length,
        ),
      );
    }
    return <List<MinLengthMatch>>[matches];
  }
}

class MinLengthMatch extends BaseMatch {
  MinLengthMatch({
    required String password,
    required int start,
    required int end,
  }) : super(password: password, start: start, end: end);

  @override
  double get estimatedGuesses => length * 10;

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return const Feedback(warning: 'Your password is not long enough.');
  }
}

class MinLengthMatchTest extends MinLengthMatch {
  MinLengthMatchTest({
    required String password,
    required int start,
    required int end,
    double? guesses,
  })  : guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
        );

  final double? guessesTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is MinLengthMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      (guessesTest == null || guessesTest == other.guesses);
}
