import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

class FeedbackTest extends Feedback {
  const FeedbackTest({
    String? warning,
    List<String>? suggestions,
  }) : super(warning: warning, suggestions: suggestions);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is Feedback &&
      warning == other.warning &&
      suggestions.join(',') == other.suggestions.join(',');
}

void main() {
  group('Feedback.', () {
    final Options options = Options(translation: translation);

    test(
      'Should return no feedback for a good password.',
      () {
        final Feedback feedback = Feedback.fromMatches(
          3,
          <MatchEstimated>[
            BruteForceMatchEstimated(
              i: 0,
              j: 0,
              token: '',
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(),
        );
      },
    );

    test(
      'Should return default feedback for empty sequence.',
      () {
        final Feedback feedback = Feedback.fromMatches(
          3,
          <MatchEstimated>[],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            suggestions: <String>[
              options.translation.suggestions.useWords,
              options.translation.suggestions.noNeed,
            ],
          ),
        );
      },
    );

    test(
      'Should return some basic feedback if no feedback could be generated.',
      () {
        final Feedback feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            BruteForceMatchEstimated(
              i: 0,
              j: 0,
              token: '',
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );
      },
    );

    test(
      'Should return feedback for dictionary.',
      () {
        Feedback feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.topTen,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 100,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 100,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.topHundred,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 1000,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 1000,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.common,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            L33tMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
              changes: <PasswordChange>[],
              changesDisplay: '',
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.similarToCommon,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.l33t,
            ],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            ReverseMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.similarToCommon,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.reverseWords,
            ],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            ReverseMatchEstimated(
              i: 0,
              j: 4,
              token: 'Tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 100000,
              guessesLog10: 5,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.capitalization,
              options.translation.suggestions.reverseWords,
            ],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            ReverseMatchEstimated(
              i: 0,
              j: 4,
              token: 'TESTS',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 100000,
              guessesLog10: 5,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.allUppercase,
              options.translation.suggestions.reverseWords,
            ],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.wikipedia,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.wordByItself,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.wikipedia,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.wikipedia,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.commonWords,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.lastNames,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.namesByThemselves,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.firstNames,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.namesByThemselves,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.firstNames,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.firstNames,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.commonNames,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );

        feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DictionaryMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.userInputs,
              guesses: 10000,
              guessesLog10: 4,
              baseGuesses: 10,
              uppercaseVariations: 0,
              l33tVariations: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.userInputs,
            suggestions: <String>[options.translation.suggestions.anotherWord],
          ),
        );
      },
    );

    test(
      'Should return feedback for spatial.',
      () {
        Feedback feedback = Feedback.fromMatches(
          2,
          <MatchEstimated>[
            SpatialMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              graph: 'qwerty',
              turns: 1,
              shiftedCount: 0,
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.straightRow,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.longerKeyboardPattern,
            ],
          ),
        );

        feedback = Feedback.fromMatches(
          2,
          <MatchEstimated>[
            SpatialMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              graph: 'qwerty',
              turns: 2,
              shiftedCount: 0,
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.keyPattern,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.longerKeyboardPattern,
            ],
          ),
        );
      },
    );

    test(
      'Should return feedback for repeat.',
      () {
        Feedback feedback = Feedback.fromMatches(
          2,
          <MatchEstimated>[
            RepeatMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              baseToken: 'a',
              baseGuesses: 1,
              repeatCount: 5,
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.simpleRepeat,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.repeated,
            ],
          ),
        );

        feedback = Feedback.fromMatches(
          2,
          <MatchEstimated>[
            RepeatMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              baseToken: 'aa',
              baseGuesses: 1,
              repeatCount: 2,
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.extendedRepeat,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.repeated,
            ],
          ),
        );
      },
    );

    test(
      'Should return feedback for sequence.',
      () {
        final Feedback feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            SequenceMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              sequenceName: '',
              sequenceSpace: 0,
              ascending: false,
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.sequences,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.sequences,
            ],
          ),
        );
      },
    );

    test(
      'Should return feedback for regex.',
      () {
        final Feedback feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            RegexMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              regexName: 'recentYear',
              regexMatch: RegExp('.*').firstMatch('tests')!,
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.recentYears,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.recentYears,
              options.translation.suggestions.associatedYears,
            ],
          ),
        );
      },
    );

    test(
      'Should return feedback for date.',
      () {
        final Feedback feedback = Feedback.fromMatches(
          1,
          <MatchEstimated>[
            DateMatchEstimated(
              i: 0,
              j: 4,
              token: 'tests',
              separator: '',
              year: 2000,
              month: 1,
              day: 1,
              guesses: 1,
              guessesLog10: 0,
            ),
          ],
          options,
        );
        expect(
          feedback,
          FeedbackTest(
            warning: options.translation.warnings.dates,
            suggestions: <String>[
              options.translation.suggestions.anotherWord,
              options.translation.suggestions.dates,
            ],
          ),
        );
      },
    );
  });
}
