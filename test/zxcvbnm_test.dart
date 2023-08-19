import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

import 'helper/password_tests.dart';

class ResultTest extends Result {
  ResultTest({
    required Feedback feedback,
    required CrackTimesSeconds crackTimesSeconds,
    required CrackTimesDisplay crackTimesDisplay,
    required int score,
    required String password,
    required double guesses,
    required double guessesLog10,
    required List<MatchEstimated> sequence,
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

class DictionaryMatchEstimatedTest extends DictionaryMatchEstimated {
  DictionaryMatchEstimatedTest({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required double guesses,
    required double guessesLog10,
    required int baseGuesses,
    required double uppercaseVariations,
    required double l33tVariations,
  }) : super(
          i: i,
          j: j,
          token: token,
          matchedWord: matchedWord,
          rank: rank,
          dictionary: dictionary,
          levenshteinDistance: levenshteinDistance,
          levenshteinDistanceEntry: levenshteinDistanceEntry,
          guesses: guesses,
          guessesLog10: guessesLog10,
          baseGuesses: baseGuesses,
          uppercaseVariations: uppercaseVariations,
          l33tVariations: l33tVariations,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is DictionaryMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10 &&
      baseGuesses == other.baseGuesses &&
      uppercaseVariations == other.uppercaseVariations &&
      l33tVariations == other.l33tVariations;
}

void main() {
  group('Main.', () {
    test(
      'Should check without userInputs.',
      () {
        final Options options = Options(
          translation: translation,
          dictionaries: dictionaries,
          graph: adjacencyGraph,
        );
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('test'),
          ResultTest(
            feedback: Feedback(
              warning: 'This is a commonly used password.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: CrackTimesSeconds(
              onlineThrottling100PerHour: 4176,
              onlineNoThrottling10PerSecond: 11.6,
              offlineSlowHashing1e4PerSecond: 0.0116,
              offlineFastHashing1e10PerSecond: 1.16e-8,
            ),
            crackTimesDisplay: CrackTimesDisplay(
              onlineThrottling100PerHour: '1 hour',
              onlineNoThrottling10PerSecond: '12 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 116,
            guessesLog10: 2.064457989226918,
            sequence: <DictionaryMatchEstimatedTest>[
              DictionaryMatchEstimatedTest(
                i: 0,
                j: 3,
                token: 'test',
                matchedWord: 'test',
                rank: 115,
                dictionary: Dictionary.passwords,
                guesses: 115,
                guessesLog10: 2.0606978403536114,
                baseGuesses: 115,
                uppercaseVariations: 1,
                l33tVariations: 1,
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
          translation: translation,
          dictionaries: <Dictionary, List<Object>>{
            ...dictionaries,
            Dictionary.userInputs: <Object>['Test', 12, true, <Object>[]],
          },
          graph: adjacencyGraph,
        );
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('test'),
          ResultTest(
            feedback: Feedback(
              warning: 'There should not be any personal or page related data.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: CrackTimesSeconds(
              onlineThrottling100PerHour: 72,
              onlineNoThrottling10PerSecond: 0.2,
              offlineSlowHashing1e4PerSecond: 0.0002,
              offlineFastHashing1e10PerSecond: 2e-10,
            ),
            crackTimesDisplay: CrackTimesDisplay(
              onlineThrottling100PerHour: '1 minute',
              onlineNoThrottling10PerSecond: 'less than a second',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 2,
            guessesLog10: 0.30102999566398114,
            sequence: <DictionaryMatchEstimatedTest>[
              DictionaryMatchEstimatedTest(
                i: 0,
                j: 3,
                token: 'test',
                matchedWord: 'test',
                rank: 1,
                dictionary: Dictionary.userInputs,
                guesses: 1,
                guessesLog10: 0,
                baseGuesses: 1,
                uppercaseVariations: 1,
                l33tVariations: 1,
              ),
            ],
          ),
        );
      },
    );

    test(
      'Should check with userInputs on the fly.',
      () {
        final Options options = Options(
          translation: translation,
          dictionaries: dictionaries,
          graph: adjacencyGraph,
        );
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('onTheFly', <String>['onTheFly']),
          ResultTest(
            feedback: Feedback(
              warning: 'There should not be any personal or page related data.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: CrackTimesSeconds(
              onlineThrottling100PerHour: 1332,
              onlineNoThrottling10PerSecond: 3.7,
              offlineSlowHashing1e4PerSecond: 0.0037,
              offlineFastHashing1e10PerSecond: 3.7e-9,
            ),
            crackTimesDisplay: CrackTimesDisplay(
              onlineThrottling100PerHour: '22 minutes',
              onlineNoThrottling10PerSecond: '4 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'onTheFly',
            guesses: 37,
            guessesLog10: 1.5682017240669948,
            sequence: <DictionaryMatchEstimatedTest>[
              DictionaryMatchEstimatedTest(
                i: 0,
                j: 7,
                token: 'onTheFly',
                matchedWord: 'onthefly',
                rank: 1,
                dictionary: Dictionary.userInputs,
                guesses: 36,
                guessesLog10: 1.556302500767287,
                baseGuesses: 1,
                uppercaseVariations: 36,
                l33tVariations: 1,
              ),
            ],
          ),
        );
      },
    );

    test(
      'Should check with userInputs on the fly without changing options.',
      () {
        final Options options = Options(
          translation: translation,
          dictionaries: dictionaries,
          graph: adjacencyGraph,
        );
        final Zxcvbnm zxcvbnm = Zxcvbnm(options);
        expect(
          zxcvbnm('test', <String>['test']),
          ResultTest(
            feedback: Feedback(
              warning: 'There should not be any personal or page related data.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: CrackTimesSeconds(
              onlineThrottling100PerHour: 72,
              onlineNoThrottling10PerSecond: 0.2,
              offlineSlowHashing1e4PerSecond: 0.0002,
              offlineFastHashing1e10PerSecond: 2e-10,
            ),
            crackTimesDisplay: CrackTimesDisplay(
              onlineThrottling100PerHour: '1 minute',
              onlineNoThrottling10PerSecond: 'less than a second',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 2,
            guessesLog10: 0.30102999566398114,
            sequence: <DictionaryMatchEstimatedTest>[
              DictionaryMatchEstimatedTest(
                i: 0,
                j: 3,
                token: 'test',
                matchedWord: 'test',
                rank: 1,
                dictionary: Dictionary.userInputs,
                guesses: 1,
                guessesLog10: 0,
                baseGuesses: 1,
                uppercaseVariations: 1,
                l33tVariations: 1,
              ),
            ],
          ),
        );
        expect(
          zxcvbnm('test'),
          ResultTest(
            feedback: Feedback(
              warning: 'This is a commonly used password.',
              suggestions: <String>['Add more words that are less common.'],
            ),
            crackTimesSeconds: CrackTimesSeconds(
              onlineThrottling100PerHour: 4176,
              onlineNoThrottling10PerSecond: 11.6,
              offlineSlowHashing1e4PerSecond: 0.0116,
              offlineFastHashing1e10PerSecond: 1.16e-8,
            ),
            crackTimesDisplay: CrackTimesDisplay(
              onlineThrottling100PerHour: '1 hour',
              onlineNoThrottling10PerSecond: '12 seconds',
              offlineSlowHashing1e4PerSecond: 'less than a second',
              offlineFastHashing1e10PerSecond: 'less than a second',
            ),
            score: 0,
            password: 'test',
            guesses: 116,
            guessesLog10: 2.064457989226918,
            sequence: <DictionaryMatchEstimatedTest>[
              DictionaryMatchEstimatedTest(
                i: 0,
                j: 3,
                token: 'test',
                matchedWord: 'test',
                rank: 115,
                dictionary: Dictionary.passwords,
                guesses: 115,
                guessesLog10: 2.0606978403536114,
                baseGuesses: 115,
                uppercaseVariations: 1,
                l33tVariations: 1,
              ),
            ],
          ),
        );
      },
    );
  });

  group('Attack vectors.', () {
    final Options options = Options(
      translation: translation,
      dictionaries: dictionaries,
      graph: adjacencyGraph,
    );
    final Zxcvbnm zxcvbnm = Zxcvbnm(options);

    test(
      'Should not die while processing and have a appropriate calcTime for l33t attack.',
      () {
        return expect(
          zxcvbnm(r'4@8({[</369&#!1/|0$5+7%2/4@8({[</369&#!1/|0$5+7%2/"')
              .calcTime,
          lessThan(1000),
        );
      },
    );

    test(
      'Should not die while processing and have a appropriate calcTime for regex attacks.',
      () {
        return expect(
          zxcvbnm('\x00\x00${'\x00' * 100}\n').calcTime,
          lessThan(1000),
        );
      },
    );
  });

  group('Password tests.', () {
    final Options options = Options(
      translation: translation,
      dictionaries: dictionaries,
      graph: adjacencyGraph,
    );
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
