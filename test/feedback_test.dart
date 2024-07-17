// ignore_for_file: lines_longer_than_80_chars

import 'package:test/test.dart';
import 'package:zxcvbnm/languages/common/adjacency_graph.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/matchers/base_matcher.dart';
import 'package:zxcvbnm/src/matchers/brute_force_matcher.dart';
import 'package:zxcvbnm/src/matchers/utils/clean_password.dart';
import 'package:zxcvbnm/src/options.dart';

import 'matchers/date_matcher_test.dart';
import 'matchers/dictionary_matcher_test.dart';
import 'matchers/l33t_matcher_test.dart';
import 'matchers/reg_ex_matcher_test.dart';
import 'matchers/repeat_matcher_test.dart';
import 'matchers/reverse_matcher_test.dart';
import 'matchers/sequence_matcher_test.dart';
import 'matchers/spatial_matcher_test.dart';

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
        );
        expect(
          feedback,
          const FeedbackTest(),
        );
      },
    );

    test(
      'Should return default feedback for empty sequence.',
      () {
        final Feedback feedback = Feedback.fromMatches(
          3,
          <BaseMatch>[],
        );
        expect(
          feedback,
          const FeedbackTest(
            suggestions: <String>[
              'Use multiple words, but avoid common phrases.',
              'You can create strong passwords without using symbols, numbers, or uppercase letters.',
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
        );
        expect(
          feedback,
          const FeedbackTest(
            suggestions: <String>['Add more words that are less common.'],
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'This is a heavily used password.',
            suggestions: <String>['Add more words that are less common.'],
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'This is a frequently used password.',
            suggestions: <String>['Add more words that are less common.'],
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'This is a commonly used password.',
            suggestions: <String>['Add more words that are less common.'],
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
              extraVariations: 0,
              changes: <PasswordChange>[],
              changesDisplay: '',
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'This is similar to a commonly used password.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Avoid predictable letter substitutions like "@" for "a".',
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'This is similar to a commonly used password.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Avoid reversed spellings of common words.',
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            suggestions: <String>[
              'Add more words that are less common.',
              'Capitalize more than the first letter.',
              'Avoid reversed spellings of common words.',
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            suggestions: <String>[
              'Add more words that are less common.',
              'Capitalize some, but not all letters.',
              'Avoid reversed spellings of common words.',
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Single words are easy to guess.',
            suggestions: <String>['Add more words that are less common.'],
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
              extraVariations: 0,
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            suggestions: <String>['Add more words that are less common.'],
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            suggestions: <String>['Add more words that are less common.'],
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
              dictionary: Dictionary.names,
              guesses: 10000,
              uppercaseVariations: 0,
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Single names or surnames are easy to guess.',
            suggestions: <String>['Add more words that are less common.'],
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
              dictionary: Dictionary.names,
              guesses: 10000,
              uppercaseVariations: 0,
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Single names or surnames are easy to guess.',
            suggestions: <String>['Add more words that are less common.'],
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
              dictionary: Dictionary.names,
              guesses: 10000,
              uppercaseVariations: 0,
              extraVariations: 0,
            ),
            DictionaryMatchTest(
              password: 'tests',
              start: 0,
              end: 5,
              matchedWord: 'tests',
              rank: 10,
              dictionary: Dictionary.names,
              guesses: 10000,
              uppercaseVariations: 0,
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Common names and surnames are easy to guess.',
            suggestions: <String>['Add more words that are less common.'],
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
              extraVariations: 0,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'There should not be any personal or page related data.',
            suggestions: <String>['Add more words that are less common.'],
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
              graph: adjacencyGraph['qwerty']!,
              graphName: 'qwerty',
              turns: 1,
              shiftedCount: 0,
              guesses: 1,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning:
                'Straight rows of keys on your keyboard are easy to guess.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Use longer keyboard patterns and change typing direction multiple times.',
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
              graph: adjacencyGraph['qwerty']!,
              graphName: 'qwerty',
              turns: 2,
              shiftedCount: 0,
              guesses: 1,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Short keyboard patterns are easy to guess.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Use longer keyboard patterns and change typing direction multiple times.',
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
              guesses: 1,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Repeated characters like "aaa" are easy to guess.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Avoid repeated words and characters.',
            ],
          ),
        );

        feedback = Feedback.fromMatches(
          2,
          <BaseMatch>[
            RepeatMatchTest(
              password: 'tests',
              start: 0,
              end: 4,
              baseToken: 'aa',
              baseGuesses: 1,
              guesses: 1,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning:
                'Repeated character patterns like "abcabcabc" are easy to guess.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Avoid repeated words and characters.',
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
              name: '',
              space: 0,
              ascending: false,
              guesses: 1,
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Common character sequences like "abc" are easy to guess.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Avoid common character sequences.',
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
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Recent years are easy to guess.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Avoid recent years.',
              'Avoid years that are associated with you.',
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
            ),
          ],
        );
        expect(
          feedback,
          const FeedbackTest(
            warning: 'Dates are easy to guess.',
            suggestions: <String>[
              'Add more words that are less common.',
              'Avoid dates and years that are associated with you.',
            ],
          ),
        );
      },
    );
  });
}
