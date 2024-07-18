import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/matchers/base_matcher.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

import 'helpers/password_tests.dart';
import 'matchers/dictionary_matcher_test.dart';

class ResultTest extends Result {
  ResultTest({
    required Feedback feedback,
    required CrackTimesSeconds crackTimesSeconds,
    required CrackTimesDisplay crackTimesDisplay,
    required int score,
    required String password,
    required double guesses,
    required double guessesLog10,
    required List<BaseMatch> sequence,
  }) : super(
          feedback: feedback,
          crackTimesSeconds: crackTimesSeconds,
          crackTimesDisplay: crackTimesDisplay,
          score: score,
          password: password,
          guesses: guesses,
          guessesLog10: guessesLog10,
          sequence: sequence,
          calcTime: 0,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is Result &&
      feedback.warning == other.feedback.warning &&
      feedback.suggestions.join(',') == other.feedback.suggestions.join(',') &&
      crackTimesSeconds.onlineThrottling100PerHour ==
          other.crackTimesSeconds.onlineThrottling100PerHour &&
      crackTimesSeconds.onlineNoThrottling10PerSecond ==
          other.crackTimesSeconds.onlineNoThrottling10PerSecond &&
      crackTimesSeconds.offlineSlowHashing1e4PerSecond ==
          other.crackTimesSeconds.offlineSlowHashing1e4PerSecond &&
      crackTimesSeconds.offlineFastHashing1e10PerSecond ==
          other.crackTimesSeconds.offlineFastHashing1e10PerSecond &&
      crackTimesDisplay.onlineThrottling100PerHour ==
          other.crackTimesDisplay.onlineThrottling100PerHour &&
      crackTimesDisplay.onlineNoThrottling10PerSecond ==
          other.crackTimesDisplay.onlineNoThrottling10PerSecond &&
      crackTimesDisplay.offlineSlowHashing1e4PerSecond ==
          other.crackTimesDisplay.offlineSlowHashing1e4PerSecond &&
      crackTimesDisplay.offlineFastHashing1e10PerSecond ==
          other.crackTimesDisplay.offlineFastHashing1e10PerSecond &&
      score == other.score &&
      password == other.password &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10 &&
      equals(sequence).matches(other.sequence, <dynamic, dynamic>{});
}

void main() {
  group('Main.', () {
    test(
      'Should check without userInputs.',
      () {
        final Options options = Options(dictionaries: dictionaries);
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('test'),
          ResultTest(
            feedback: const Feedback(
              warning: 'This is a commonly used password.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: const CrackTimesSeconds(
              onlineThrottling100PerHour: 4176,
              onlineNoThrottling10PerSecond: 11.6,
              offlineSlowHashing1e4PerSecond: 0.0116,
              offlineFastHashing1e10PerSecond: 1.16e-8,
            ),
            crackTimesDisplay: const CrackTimesDisplay(
              onlineThrottling100PerHour: '1 hour',
              onlineNoThrottling10PerSecond: '12 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 116,
            guessesLog10: 2.064457989226918,
            sequence: <DictionaryMatchTest>[
              DictionaryMatchTest(
                password: 'test',
                start: 0,
                end: 4,
                matchedWord: 'test',
                rank: 115,
                dictionary: Dictionary.passwords,
                guesses: 115,
                uppercaseVariations: 1,
                extraVariations: 1,
              ),
            ],
          ),
        );
      },
    );

    test(
      'Should check with userInputs.',
      () {
        final Options options = Options(
          dictionaries: <Dictionaries>{
            ...dictionaries,
            <Dictionary, List<String>>{
              Dictionary.userInputs: <String>['Test', '12', 'true'],
            },
          },
        );
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('test'),
          ResultTest(
            feedback: const Feedback(
              warning: 'There should not be any personal or page related data.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: const CrackTimesSeconds(
              onlineThrottling100PerHour: 72,
              onlineNoThrottling10PerSecond: 0.2,
              offlineSlowHashing1e4PerSecond: 0.0002,
              offlineFastHashing1e10PerSecond: 2e-10,
            ),
            crackTimesDisplay: const CrackTimesDisplay(
              onlineThrottling100PerHour: '1 minute',
              onlineNoThrottling10PerSecond: 'less than a second',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 2,
            guessesLog10: 0.30102999566398114,
            sequence: <DictionaryMatchTest>[
              DictionaryMatchTest(
                password: 'test',
                start: 0,
                end: 4,
                matchedWord: 'test',
                rank: 1,
                dictionary: Dictionary.userInputs,
                guesses: 1,
                uppercaseVariations: 1,
                extraVariations: 1,
              ),
            ],
          ),
        );
      },
    );

    test(
      'Should check with userInputs on the fly.',
      () {
        final Options options = Options(dictionaries: dictionaries);
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('onTheFly', <String>['onTheFly']),
          ResultTest(
            feedback: const Feedback(
              warning: 'There should not be any personal or page related data.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: const CrackTimesSeconds(
              onlineThrottling100PerHour: 1332,
              onlineNoThrottling10PerSecond: 3.7,
              offlineSlowHashing1e4PerSecond: 0.0037,
              offlineFastHashing1e10PerSecond: 3.7e-9,
            ),
            crackTimesDisplay: const CrackTimesDisplay(
              onlineThrottling100PerHour: '22 minutes',
              onlineNoThrottling10PerSecond: '4 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'onTheFly',
            guesses: 37,
            guessesLog10: 1.5682017240669948,
            sequence: <DictionaryMatchTest>[
              DictionaryMatchTest(
                password: 'onTheFly',
                start: 0,
                end: 8,
                matchedWord: 'onthefly',
                rank: 1,
                dictionary: Dictionary.userInputs,
                guesses: 36,
                uppercaseVariations: 36,
                extraVariations: 1,
              ),
            ],
          ),
        );
      },
    );

    test(
      'Should check with userInputs on the fly without changing options.',
      () {
        final Options options = Options(dictionaries: dictionaries);
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('test', <String>['test']),
          ResultTest(
            feedback: const Feedback(
              warning: 'There should not be any personal or page related data.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: const CrackTimesSeconds(
              onlineThrottling100PerHour: 72,
              onlineNoThrottling10PerSecond: 0.2,
              offlineSlowHashing1e4PerSecond: 0.0002,
              offlineFastHashing1e10PerSecond: 2e-10,
            ),
            crackTimesDisplay: const CrackTimesDisplay(
              onlineThrottling100PerHour: '1 minute',
              onlineNoThrottling10PerSecond: 'less than a second',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 2,
            guessesLog10: 0.30102999566398114,
            sequence: <DictionaryMatchTest>[
              DictionaryMatchTest(
                password: 'test',
                start: 0,
                end: 4,
                matchedWord: 'test',
                rank: 1,
                dictionary: Dictionary.userInputs,
                guesses: 1,
                uppercaseVariations: 1,
                extraVariations: 1,
              ),
            ],
          ),
        );
        expect(
          zxcvbnm('test'),
          ResultTest(
            feedback: const Feedback(
              warning: 'This is a commonly used password.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: const CrackTimesSeconds(
              onlineThrottling100PerHour: 4176,
              onlineNoThrottling10PerSecond: 11.6,
              offlineSlowHashing1e4PerSecond: 0.0116,
              offlineFastHashing1e10PerSecond: 1.16e-8,
            ),
            crackTimesDisplay: const CrackTimesDisplay(
              onlineThrottling100PerHour: '1 hour',
              onlineNoThrottling10PerSecond: '12 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 116,
            guessesLog10: 2.064457989226918,
            sequence: <DictionaryMatchTest>[
              DictionaryMatchTest(
                password: 'test',
                start: 0,
                end: 4,
                matchedWord: 'test',
                rank: 115,
                dictionary: Dictionary.passwords,
                guesses: 115,
                uppercaseVariations: 1,
                extraVariations: 1,
              ),
            ],
          ),
        );
      },
    );
  });

  group('Attack vectors.', () {
    final Options options = Options(dictionaries: dictionaries);
    final Zxcvbnm zxcvbnm = Zxcvbnm(options);

    test(
      'Should not die while processing and have a appropriate calcTime for '
      'l33t attack.',
      () {
        return expect(
          zxcvbnm(r'4@8({[</369&#!1/|0$5+7%2/4@8({[</369&#!1/|0$5+7%2/"')
              .calcTime,
          lessThan(1000),
        );
      },
    );

    test(
      'Should not die while processing and have a appropriate calcTime for '
      'regex attacks.',
      () {
        return expect(
          zxcvbnm('\x00\x00${'\x00' * 100}\n').calcTime,
          lessThan(1000),
        );
      },
    );
  });

  group('Password tests.', () {
    final Options options = Options(dictionaries: dictionaries);
    final Zxcvbnm zxcvbnm = Zxcvbnm(options);
    for (final ResultTest resultTest in passwordTests) {
      test(
        'should resolve ${resultTest.password}',
        () => expect(
          zxcvbnm(resultTest.password),
          resultTest,
        ),
      );
    }
  });
}
