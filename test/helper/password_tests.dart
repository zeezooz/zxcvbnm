import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/matchers/base_matcher.dart';
import 'package:zxcvbnm/src/matchers/brute_force_matcher.dart';
import 'package:zxcvbnm/src/types.dart';

import '../matcher/dictionary/matching_test.dart';
import '../matcher/dictionary/variants/matching/l33t_test.dart';
import '../matcher/sequence/matching_test.dart';
import '../matcher/spatial/matching_test.dart';
import '../matchers/reg_ex_matcher_test.dart';
import '../matchers/repeat_matcher_test.dart';
import '../zxcvbnm_test.dart';

final List<ResultTest> passwordTests = <ResultTest>[
  ResultTest(
    feedback: Feedback(
      warning: 'This is a commonly used password.',
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 13104,
      onlineNoThrottling10PerSecond: 36.4,
      offlineSlowHashing1e4PerSecond: 0.0364,
      offlineFastHashing1e10PerSecond: 3.64e-8,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '4 hours',
      onlineNoThrottling10PerSecond: '36 seconds',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: '1q2w3e4r5t',
    guesses: 364,
    guessesLog10: 2.5611013836490555,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: '1q2w3e4r5t',
        start: 0,
        end: 10,
        matchedWord: '1q2w3e4r5t',
        rank: 363,
        dictionary: Dictionary.passwords,
        guesses: 363,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is a commonly used password.',
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 26172,
      onlineNoThrottling10PerSecond: 72.7,
      offlineSlowHashing1e4PerSecond: 0.0727,
      offlineFastHashing1e10PerSecond: 7.27e-8,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '7 hours',
      onlineNoThrottling10PerSecond: '1 minute',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: '1Q2w3e4r5t',
    guesses: 727,
    guessesLog10: 2.8615344108590377,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: '1Q2w3e4r5t',
        start: 0,
        end: 10,
        matchedWord: '1q2w3e4r5t',
        rank: 363,
        dictionary: Dictionary.passwords,
        guesses: 726,
        uppercaseVariations: 2,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is a commonly used password.',
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 26172,
      onlineNoThrottling10PerSecond: 72.7,
      offlineSlowHashing1e4PerSecond: 0.0727,
      offlineFastHashing1e10PerSecond: 7.27e-8,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '7 hours',
      onlineNoThrottling10PerSecond: '1 minute',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: '1q2w3e4r5T',
    guesses: 727,
    guessesLog10: 2.8615344108590377,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: '1q2w3e4r5T',
        start: 0,
        end: 10,
        matchedWord: '1q2w3e4r5t',
        rank: 363,
        dictionary: Dictionary.passwords,
        guesses: 726,
        uppercaseVariations: 2,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'Common character sequences like "abc" are easy to guess.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Avoid common character sequences.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 540000,
      onlineNoThrottling10PerSecond: 1500,
      offlineSlowHashing1e4PerSecond: 1.5,
      offlineFastHashing1e10PerSecond: 0.0000015,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '6 days',
      onlineNoThrottling10PerSecond: '25 minutes',
      offlineSlowHashing1e4PerSecond: '2 seconds',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 1,
    password: 'abcdefg123',
    guesses: 15000,
    guessesLog10: 4.176091259055681,
    sequence: <BaseMatch>[
      SequenceMatchTest(
        password: 'abcdefg123',
        start: 0,
        end: 7,
        sequenceName: 'lower',
        sequenceSpace: 26,
        ascending: true,
        guesses: 50,
      ),
      SequenceMatchTest(
        password: 'abcdefg123',
        start: 7,
        end: 10,
        sequenceName: 'digits',
        sequenceSpace: 10,
        ascending: true,
        guesses: 50,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is similar to a commonly used password.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Capitalize some, but not all letters.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 89496000,
      onlineNoThrottling10PerSecond: 248600,
      offlineSlowHashing1e4PerSecond: 248.6,
      offlineFastHashing1e10PerSecond: 0.0002486,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '3 years',
      onlineNoThrottling10PerSecond: '3 days',
      offlineSlowHashing1e4PerSecond: '4 minutes',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 2,
    password: 'TESTERINO',
    guesses: 2486000,
    guessesLog10: 6.395501124305626,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: 'TESTERINO',
        start: 0,
        end: 6,
        matchedWord: 'tester',
        rank: 619,
        dictionary: Dictionary.passwords,
        guesses: 1238,
        uppercaseVariations: 2,
        l33tVariations: 1,
      ),
      BruteForceMatchTest(
        password: 'TESTERINO',
        start: 6,
        end: 9,
        guesses: 1000,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'Repeated characters like "aaa" are easy to guess.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Avoid repeated words and characters.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 3060,
      onlineNoThrottling10PerSecond: 8.5,
      offlineSlowHashing1e4PerSecond: 0.0085,
      offlineFastHashing1e10PerSecond: 8.5e-9,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '51 minutes',
      onlineNoThrottling10PerSecond: '9 seconds',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: 'aaaaaaa',
    guesses: 85,
    guessesLog10: 1.9294189257142926,
    sequence: <BaseMatch>[
      RepeatMatchTest(
        password: 'aaaaaaa',
        start: 0,
        end: 7,
        baseToken: 'a',
        baseGuesses: 12,
        repeatCount: 7,
        guesses: 84,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is a frequently used password.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Capitalize more than the first letter.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 3924,
      onlineNoThrottling10PerSecond: 10.9,
      offlineSlowHashing1e4PerSecond: 0.0109,
      offlineFastHashing1e10PerSecond: 1.09e-8,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '1 hour',
      onlineNoThrottling10PerSecond: '11 seconds',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: 'Daniel',
    guesses: 109,
    guessesLog10: 2.0374264979406234,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: 'Daniel',
        start: 0,
        end: 6,
        matchedWord: 'daniel',
        rank: 54,
        dictionary: Dictionary.passwords,
        guesses: 108,
        uppercaseVariations: 2,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is a commonly used password.',
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 3780,
      onlineNoThrottling10PerSecond: 10.5,
      offlineSlowHashing1e4PerSecond: 0.0105,
      offlineFastHashing1e10PerSecond: 1.05e-8,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '1 hour',
      onlineNoThrottling10PerSecond: '11 seconds',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: '1234qwer',
    guesses: 105,
    guessesLog10: 2.021189299069938,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: '1234qwer',
        start: 0,
        end: 8,
        matchedWord: '1234qwer',
        rank: 104,
        dictionary: Dictionary.passwords,
        guesses: 104,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is a commonly used password.',
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 107208,
      onlineNoThrottling10PerSecond: 297.8,
      offlineSlowHashing1e4PerSecond: 0.2978,
      offlineFastHashing1e10PerSecond: 2.978e-7,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '1 day',
      onlineNoThrottling10PerSecond: '5 minutes',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 1,
    password: '1234qwe',
    guesses: 2978,
    guessesLog10: 3.473924693416157,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: '1234qwe',
        start: 0,
        end: 7,
        matchedWord: '1234qwe',
        rank: 2977,
        dictionary: Dictionary.passwords,
        guesses: 2977,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is similar to a commonly used password.',
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 442368,
      onlineNoThrottling10PerSecond: 1228.8,
      offlineSlowHashing1e4PerSecond: 1.2288,
      offlineFastHashing1e10PerSecond: 0.0000012288,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '5 days',
      onlineNoThrottling10PerSecond: '20 minutes',
      offlineSlowHashing1e4PerSecond: '1 second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 1,
    password: '1234qwert',
    guesses: 12288,
    guessesLog10: 4.089481202687437,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: '1234qwert',
        start: 0,
        end: 8,
        matchedWord: '1234qwer',
        rank: 104,
        dictionary: Dictionary.passwords,
        guesses: 104,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      BruteForceMatchTest(
        password: '1234qwert',
        start: 8,
        end: 9,
        guesses: 11,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is a heavily used password.',
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 108,
      onlineNoThrottling10PerSecond: 0.3,
      offlineSlowHashing1e4PerSecond: 0.0003,
      offlineFastHashing1e10PerSecond: 3e-10,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '2 minutes',
      onlineNoThrottling10PerSecond: 'less than a second',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: 'password',
    guesses: 3,
    guessesLog10: 0.47712125471966244,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: 'password',
        start: 0,
        end: 8,
        matchedWord: 'password',
        rank: 2,
        dictionary: Dictionary.passwords,
        guesses: 2,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'Recent years are easy to guess.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Avoid recent years.',
        'Avoid years that are associated with you.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 540000,
      onlineNoThrottling10PerSecond: 1500,
      offlineSlowHashing1e4PerSecond: 1.5,
      offlineFastHashing1e10PerSecond: 0.0000015,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '6 days',
      onlineNoThrottling10PerSecond: '25 minutes',
      offlineSlowHashing1e4PerSecond: '2 seconds',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 1,
    password: '2010abc',
    guesses: 15000,
    guessesLog10: 4.176091259055681,
    sequence: <BaseMatch>[
      RegexMatchTest(
        password: '2010abc',
        start: 0,
        end: 4,
        regExName: 'recentYear',
        guesses: 50,
      ),
      SequenceMatchTest(
        password: '2010abc',
        start: 4,
        end: 7,
        sequenceName: 'lower',
        sequenceSpace: 26,
        ascending: true,
        guesses: 50,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning:
          'Repeated character patterns like "abcabcabc" are easy to guess.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Avoid repeated words and characters.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 1908,
      onlineNoThrottling10PerSecond: 5.3,
      offlineSlowHashing1e4PerSecond: 0.0053,
      offlineFastHashing1e10PerSecond: 5.3e-9,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '32 minutes',
      onlineNoThrottling10PerSecond: '5 seconds',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: 'abcabcabcabc',
    guesses: 53,
    guessesLog10: 1.724275869600789,
    sequence: <BaseMatch>[
      RepeatMatchTest(
        password: 'abcabcabcabc',
        start: 0,
        end: 12,
        baseToken: 'abc',
        baseGuesses: 13,
        repeatCount: 4,
        guesses: 52,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'Straight rows of keys on your keyboard are easy to guess.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Use longer keyboard patterns and change typing direction multiple times.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 46692,
      onlineNoThrottling10PerSecond: 129.7,
      offlineSlowHashing1e4PerSecond: 0.1297,
      offlineFastHashing1e10PerSecond: 1.297e-7,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '13 hours',
      onlineNoThrottling10PerSecond: '2 minutes',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 1,
    password: 'qwer',
    guesses: 1297,
    guessesLog10: 3.1129399760840797,
    sequence: <BaseMatch>[
      SpatialMatchTest(
        password: 'qwer',
        start: 0,
        end: 4,
        graph: 'qwerty',
        turns: 1,
        shiftedCount: 0,
        guesses: 1296,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'This is similar to a commonly used password.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Capitalize more than the first letter.',
        "Avoid predictable letter substitutions like '@' for 'a'.",
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 1188,
      onlineNoThrottling10PerSecond: 3.3,
      offlineSlowHashing1e4PerSecond: 0.0033,
      offlineFastHashing1e10PerSecond: 3.3e-9,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '20 minutes',
      onlineNoThrottling10PerSecond: '3 seconds',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: r'P4$$w0rd',
    guesses: 33,
    guessesLog10: 1.5185139398778873,
    sequence: <BaseMatch>[
      L33tMatchTest(
        password: r'P4$$w0rd',
        start: 0,
        end: 8,
        matchedWord: 'password',
        rank: 2,
        dictionary: Dictionary.passwords,
        changes: <PasswordChange>[
          PasswordChange(l33t: '4', clean: 'a'),
          PasswordChange(l33t: r'$', clean: 's'),
          PasswordChange(l33t: '0', clean: 'o'),
        ],
        changesDisplay: r'4 -> a, $ -> s, 0 -> o',
        guesses: 32,
        uppercaseVariations: 2,
        l33tVariations: 8,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      suggestions: <String>['Add more words that are less common.'],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 360036,
      onlineNoThrottling10PerSecond: 1000.1,
      offlineSlowHashing1e4PerSecond: 1.0001,
      offlineFastHashing1e10PerSecond: 0.0000010001,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '4 days',
      onlineNoThrottling10PerSecond: '17 minutes',
      offlineSlowHashing1e4PerSecond: '1 second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 1,
    password: 'aA!1',
    guesses: 10001,
    guessesLog10: 4.000043427276863,
    sequence: <BaseMatch>[
      BruteForceMatchTest(
        password: 'aA!1',
        start: 0,
        end: 4,
        guesses: 10000,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 8.424e34,
      onlineNoThrottling10PerSecond: 2.34e32,
      offlineSlowHashing1e4PerSecond: 2.34e29,
      offlineFastHashing1e10PerSecond: 2.34e23,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: 'centuries',
      onlineNoThrottling10PerSecond: 'centuries',
      offlineSlowHashing1e4PerSecond: 'centuries',
      offlineFastHashing1e10PerSecond: 'centuries',
    ),
    score: 4,
    password: 'dgo9dsghasdoghi8/!&IT%§(ihsdhf8o7o',
    guesses: 2.34e33,
    guessesLog10: 33.36921585741014,
    sequence: <BaseMatch>[
      BruteForceMatchTest(
        password: 'dgo9dsghasdoghi8/!&IT%§(ihsdhf8o7o',
        start: 0,
        end: 7,
        guesses: 10000000,
      ),
      DictionaryMatchTest(
        password: 'dgo9dsghasdoghi8/!&IT%§(ihsdhf8o7o',
        start: 7,
        end: 10,
        matchedWord: 'has',
        rank: 24,
        dictionary: Dictionary.wikipedia,
        guesses: 50,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      DictionaryMatchTest(
        password: 'dgo9dsghasdoghi8/!&IT%§(ihsdhf8o7o',
        start: 10,
        end: 12,
        matchedWord: 'do',
        rank: 22,
        dictionary: Dictionary.commonWords,
        guesses: 50,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      SequenceMatchTest(
        password: 'dgo9dsghasdoghi8/!&IT%§(ihsdhf8o7o',
        start: 12,
        end: 15,
        sequenceName: 'lower',
        sequenceSpace: 26,
        ascending: true,
        guesses: 78,
      ),
      BruteForceMatchTest(
        password: 'dgo9dsghasdoghi8/!&IT%§(ihsdhf8o7o',
        start: 15,
        end: 34,
        guesses: 10000000000000000000,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'Straight rows of keys on your keyboard are easy to guess.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Use longer keyboard patterns and change typing direction multiple times.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 19368000,
      onlineNoThrottling10PerSecond: 53800,
      offlineSlowHashing1e4PerSecond: 53.8,
      offlineFastHashing1e10PerSecond: 0.0000538,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '7 months',
      onlineNoThrottling10PerSecond: '15 hours',
      offlineSlowHashing1e4PerSecond: '54 seconds',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 1,
    password: 'AZERYT',
    guesses: 538000,
    guessesLog10: 5.730782275666389,
    sequence: <BaseMatch>[
      SpatialMatchTest(
        password: 'AZERYT',
        start: 0,
        end: 4,
        graph: 'azerty',
        turns: 1,
        shiftedCount: 4,
        guesses: 2640,
      ),
      BruteForceMatchTest(
        password: 'AZERYT',
        start: 4,
        end: 6,
        guesses: 100,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      warning: 'Short keyboard patterns are easy to guess.',
      suggestions: <String>[
        'Add more words that are less common.',
        'Use longer keyboard patterns and change typing direction multiple times.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 460442304,
      onlineNoThrottling10PerSecond: 1279006.4,
      offlineSlowHashing1e4PerSecond: 1279.0064,
      offlineFastHashing1e10PerSecond: 0.0012790064,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '14 years',
      onlineNoThrottling10PerSecond: '15 days',
      offlineSlowHashing1e4PerSecond: '21 minutes',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 2,
    password: 'zxcftzuio',
    guesses: 12790064,
    guessesLog10: 7.106872717643415,
    sequence: <BaseMatch>[
      BruteForceMatchTest(
        password: 'zxcftzuio',
        start: 0,
        end: 1,
        guesses: 11,
      ),
      SpatialMatchTest(
        password: 'zxcftzuio',
        start: 1,
        end: 9,
        graph: 'qwertz',
        turns: 3,
        shiftedCount: 0,
        guesses: 580912,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 46843200000,
      onlineNoThrottling10PerSecond: 130120000,
      offlineSlowHashing1e4PerSecond: 130120,
      offlineFastHashing1e10PerSecond: 0.13012,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: 'centuries',
      onlineNoThrottling10PerSecond: '4 years',
      offlineSlowHashing1e4PerSecond: '2 days',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 3,
    password: 'buy by beer',
    guesses: 1301200000,
    guessesLog10: 9.114344054609814,
    sequence: <BaseMatch>[
      BruteForceMatchTest(
        password: 'buy by beer',
        start: 0,
        end: 2,
        guesses: 100,
      ),
      RepeatMatchTest(
        password: 'buy by beer',
        start: 2,
        end: 8,
        baseToken: 'y b',
        baseGuesses: 1001,
        repeatCount: 2,
        guesses: 2002,
      ),
      BruteForceMatchTest(
        password: 'buy by beer',
        start: 8,
        end: 11,
        guesses: 1000,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 40608478800000000,
      onlineNoThrottling10PerSecond: 112801330000000,
      offlineSlowHashing1e4PerSecond: 112801330000,
      offlineFastHashing1e10PerSecond: 112801.33,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: 'centuries',
      onlineNoThrottling10PerSecond: 'centuries',
      offlineSlowHashing1e4PerSecond: 'centuries',
      offlineFastHashing1e10PerSecond: '1 day',
    ),
    score: 4,
    password: 'horse stable battery',
    guesses: 1128013300000000,
    guessesLog10: 15.052314220287887,
    sequence: <BaseMatch>[
      DictionaryMatchTest(
        password: 'horse stable battery',
        start: 0,
        end: 5,
        matchedWord: 'horse',
        rank: 862,
        dictionary: Dictionary.commonWords,
        guesses: 862,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      BruteForceMatchTest(
        password: 'horse stable battery',
        start: 5,
        end: 13,
        guesses: 100000000,
      ),
      DictionaryMatchTest(
        password: 'horse stable battery',
        start: 13,
        end: 20,
        matchedWord: 'battery',
        rank: 2181,
        dictionary: Dictionary.wikipedia,
        guesses: 2181,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 3.6000000000000004e+37,
      onlineNoThrottling10PerSecond: 1e35,
      offlineSlowHashing1e4PerSecond: 1e32,
      offlineFastHashing1e10PerSecond: 1e26,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: 'centuries',
      onlineNoThrottling10PerSecond: 'centuries',
      offlineSlowHashing1e4PerSecond: 'centuries',
      offlineFastHashing1e10PerSecond: 'centuries',
    ),
    score: 4,
    password: 'a65a54cf-eadb-4f7c-893c-9d4a6f81f8c2',
    guesses: 1e36,
    guessesLog10: 35.99999999999999,
    sequence: <BaseMatch>[
      BruteForceMatchTest(
        password: 'a65a54cf-eadb-4f7c-893c-9d4a6f81f8c2',
        start: 0,
        end: 36,
        guesses: 1e36,
      ),
    ],
  ),
  ResultTest(
    feedback: Feedback(
      suggestions: <String>[
        'Use multiple words, but avoid common phrases.',
        'You can create strong passwords without using symbols, numbers, or uppercase letters.',
      ],
    ),
    crackTimesSeconds: CrackTimesSeconds(
      onlineThrottling100PerHour: 36,
      onlineNoThrottling10PerSecond: 0.1,
      offlineSlowHashing1e4PerSecond: 0.0001,
      offlineFastHashing1e10PerSecond: 1e-10,
    ),
    crackTimesDisplay: CrackTimesDisplay(
      onlineThrottling100PerHour: '36 seconds',
      onlineNoThrottling10PerSecond: 'less than a second',
      offlineSlowHashing1e4PerSecond: 'less than a second',
      offlineFastHashing1e10PerSecond: 'less than a second',
    ),
    score: 0,
    password: '',
    guesses: 1,
    guessesLog10: 0,
    sequence: <BaseMatch>[],
  ),
];

class BruteForceMatchTest extends BruteForceMatch {
  BruteForceMatchTest({
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
      other is BruteForceMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      (guessesTest == null || guessesTest == other.guesses);
}
