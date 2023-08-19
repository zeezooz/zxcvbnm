import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

import 'zxcvbnm_test.dart';

void main() {
  group('Levenshtein.', () {
    final Options options = Options(
      translation: translation,
      dictionaries: dictionaries,
      graph: adjacencyGraph,
      useLevenshteinDistance: true,
    );
    final Zxcvbnm zxcvbnm = Zxcvbnm(options);

    test(
      'Should find levenstein distance.',
      () => expect(
        zxcvbnm('ishduehlduod83h4mfs8', <String>['ishduehgldueod83h4mfis8']),
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
          password: 'ishduehlduod83h4mfs8',
          guesses: 2,
          guessesLog10: 0.30102999566398114,
          sequence: <DictionaryMatchEstimatedTest>[
            DictionaryMatchEstimatedTest(
              i: 0,
              j: 19,
              token: 'ishduehlduod83h4mfs8',
              matchedWord: 'ishduehlduod83h4mfs8',
              rank: 1,
              dictionary: Dictionary.userInputs,
              levenshteinDistance: 3,
              levenshteinDistanceEntry: 'ishduehgldueod83h4mfis8',
              guesses: 1,
              guessesLog10: 0,
              baseGuesses: 1,
              uppercaseVariations: 1,
              l33tVariations: 1,
            ),
          ],
        ),
      ),
    );

    test(
      'Should recognize a mistyped common English word.',
      () => expect(
        zxcvbnm('alaphant'),
        ResultTest(
          feedback: Feedback(
            warning: 'This is a commonly used password.',
            suggestions: <String>['Add more words that are less common.'],
          ),
          crackTimesSeconds: CrackTimesSeconds(
            onlineThrottling100PerHour: 12420,
            onlineNoThrottling10PerSecond: 34.5,
            offlineSlowHashing1e4PerSecond: 0.0345,
            offlineFastHashing1e10PerSecond: 3.45e-8,
          ),
          crackTimesDisplay: CrackTimesDisplay(
            onlineThrottling100PerHour: '3 hours',
            onlineNoThrottling10PerSecond: '35 seconds',
            offlineSlowHashing1e4PerSecond: 'less than a second',
            offlineFastHashing1e10PerSecond: 'less than a second',
          ),
          score: 0,
          password: 'alaphant',
          guesses: 345,
          guessesLog10: 2.537819095073274,
          sequence: <DictionaryMatchEstimatedTest>[
            DictionaryMatchEstimatedTest(
              i: 0,
              j: 7,
              token: 'alaphant',
              matchedWord: 'alaphant',
              rank: 344,
              dictionary: Dictionary.passwords,
              levenshteinDistance: 2,
              levenshteinDistanceEntry: 'elephant',
              guesses: 344,
              guessesLog10: 2.53655844257153,
              baseGuesses: 344,
              uppercaseVariations: 1,
              l33tVariations: 1,
            ),
          ],
        ),
      ),
    );

    test(
      'Should respect threshold which is lower than the default 2.',
      () => expect(
        Zxcvbnm(options.copyWith(levenshteinThreshold: 1))('eeleephaant')
            .sequence,
        everyElement(
          predicate(
            (MatchEstimated match) =>
                match is! DictionaryMatchEstimated ||
                match.levenshteinDistance == null,
            'levenshteinDistance is null',
          ),
        ),
      ),
    );

    test(
      'Should respect threshold which is higher than the default 2.',
      () => expect(
        Zxcvbnm(options.copyWith(levenshteinThreshold: 3))('eeleephaant')
            .sequence,
        containsOnce(
          predicate(
            (MatchEstimated match) =>
                match is DictionaryMatchEstimated &&
                match.levenshteinDistance != null,
            'levenshteinDistance is not null',
          ),
        ),
      ),
    );
  });
}
