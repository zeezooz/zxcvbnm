import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/matchers/base_matcher.dart';
import 'package:zxcvbnm/src/matchers/brute_force_matcher.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/types.dart';

import 'matcher/dictionary/matching_test.dart';
import 'matcher/dictionary/variants/matching/l33t_test.dart';
import 'matcher/dictionary/variants/matching/reverse_test.dart';
import 'matcher/repeat/matching_test.dart';
import 'matcher/sequence/matching_test.dart';
import 'matcher/spatial/matching_test.dart';
import 'matchers/date_matcher_test.dart';
import 'matchers/reg_ex_matcher_test.dart';

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
          <BaseMatch>[
            BruteForceMatch(
              password: '',
              start: 0,
              end: 0,
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
          <BaseMatch>[],
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
          <BaseMatch>[
            BruteForceMatch(
              password: '',
              start: 0,
              end: 0,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 100,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 1000,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            L33tMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              changes: <PasswordChange>[],
              changesDisplay: '',
              options: options,
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
          <BaseMatch>[
            ReverseMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            ReverseMatchTest(
              password: 'Tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 100000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            ReverseMatchTest(
              password: 'TESTS',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.passwords,
              guesses: 100000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.wikipedia,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.wikipedia,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
            ),
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.wikipedia,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.commonWords,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.lastNames,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.firstNames,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.firstNames,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
            ),
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.firstNames,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.userInputs,
              guesses: 10000,
              uppercaseVariations: 0,
              l33tVariations: 0,
              options: options,
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
          <BaseMatch>[
            SpatialMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              graph: 'qwerty',
              turns: 1,
              shiftedCount: 0,
              guesses: 1,
              options: options,
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
          <BaseMatch>[
            SpatialMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              graph: 'qwerty',
              turns: 2,
              shiftedCount: 0,
              guesses: 1,
              options: options,
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
          <BaseMatch>[
            RepeatMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              baseToken: 'a',
              baseGuesses: 1,
              repeatCount: 5,
              guesses: 1,
              options: options,
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
          <BaseMatch>[
            RepeatMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              baseToken: 'aa',
              baseGuesses: 1,
              repeatCount: 2,
              guesses: 1,
              options: options,
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
          <BaseMatch>[
            SequenceMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              sequenceName: '',
              sequenceSpace: 0,
              ascending: false,
              guesses: 1,
              options: options,
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
          <BaseMatch>[
            RegexMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              regExName: 'recentYear',
              guesses: 1,
              options: options,
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
          <BaseMatch>[
            DateMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              separator: '',
              year: 2000,
              month: 1,
              day: 1,
              guesses: 1,
              options: options,
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
