import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/types.dart';

import '../zxcvbnm_test.dart';

class SequenceMatchEstimatedTest extends SequenceMatchEstimated {
  SequenceMatchEstimatedTest({
    required int i,
    required int j,
    required String token,
    required String sequenceName,
    required int sequenceSpace,
    required bool ascending,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          sequenceName: sequenceName,
          sequenceSpace: sequenceSpace,
          ascending: ascending,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is SequenceMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      sequenceName == other.sequenceName &&
      sequenceSpace == other.sequenceSpace &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10;
}

class BruteForceMatchEstimatedTest extends BruteForceMatchEstimated {
  BruteForceMatchEstimatedTest({
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
      other is BruteForceMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10;
}

class RepeatMatchEstimatedTest extends RepeatMatchEstimated {
  RepeatMatchEstimatedTest({
    required int i,
    required int j,
    required String token,
    required String baseToken,
    required double baseGuesses,
    required int repeatCount,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          baseToken: baseToken,
          baseGuesses: baseGuesses,
          repeatCount: repeatCount,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is RepeatMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      baseToken == other.baseToken &&
      baseGuesses == other.baseGuesses &&
      repeatCount == other.repeatCount &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10;
}

class RegexMatchEstimatedTest extends RegexMatchEstimated {
  RegexMatchEstimatedTest({
    required int i,
    required int j,
    required String token,
    required String regexName,
    required RegExpMatch regexMatch,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          regexName: regexName,
          regexMatch: regexMatch,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is RegexMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      regexName == other.regexName &&
      regexMatch.start == other.regexMatch.start &&
      regexMatch.end == other.regexMatch.end &&
      regexMatch[0] == other.regexMatch[0] &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10;
}

class SpatialMatchEstimatedTest extends SpatialMatchEstimated {
  SpatialMatchEstimatedTest({
    required int i,
    required int j,
    required String token,
    required String graph,
    required int turns,
    required int shiftedCount,
    required double guesses,
    required double guessesLog10,
  }) : super(
          i: i,
          j: j,
          token: token,
          graph: graph,
          turns: turns,
          shiftedCount: shiftedCount,
          guesses: guesses,
          guessesLog10: guessesLog10,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is SpatialMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      graph == other.graph &&
      turns == other.turns &&
      shiftedCount == other.shiftedCount &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10;
}

class L33tMatchEstimatedTest extends L33tMatchEstimated {
  L33tMatchEstimatedTest({
    required int i,
    required int j,
    required String token,
    required String matchedWord,
    required int rank,
    required Dictionary dictionary,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
    required List<PasswordChange> changes,
    required String changesDisplay,
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
          changes: changes,
          changesDisplay: changesDisplay,
          guesses: guesses,
          guessesLog10: guessesLog10,
          baseGuesses: baseGuesses,
          uppercaseVariations: uppercaseVariations,
          l33tVariations: l33tVariations,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is L33tMatchEstimated &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      matchedWord == other.matchedWord &&
      rank == other.rank &&
      dictionary == other.dictionary &&
      levenshteinDistance == other.levenshteinDistance &&
      levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
      changes.join(',') == other.changes.join(',') &&
      changesDisplay == other.changesDisplay &&
      guesses == other.guesses &&
      guessesLog10 == other.guessesLog10 &&
      baseGuesses == other.baseGuesses &&
      uppercaseVariations == other.uppercaseVariations &&
      l33tVariations == other.l33tVariations;
}

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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 9,
        token: '1q2w3e4r5t',
        matchedWord: '1q2w3e4r5t',
        rank: 363,
        dictionary: Dictionary.passwords,
        guesses: 363,
        guessesLog10: 2.559906625036112,
        baseGuesses: 363,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 9,
        token: '1Q2w3e4r5t',
        matchedWord: '1q2w3e4r5t',
        rank: 363,
        dictionary: Dictionary.passwords,
        guesses: 726,
        guessesLog10: 2.8609366207000932,
        baseGuesses: 363,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 9,
        token: '1q2w3e4r5T',
        matchedWord: '1q2w3e4r5t',
        rank: 363,
        dictionary: Dictionary.passwords,
        guesses: 726,
        guessesLog10: 2.8609366207000932,
        baseGuesses: 363,
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
    sequence: <MatchEstimated>[
      SequenceMatchEstimatedTest(
        i: 0,
        j: 6,
        token: 'abcdefg',
        sequenceName: 'lower',
        sequenceSpace: 26,
        ascending: true,
        guesses: 50,
        guessesLog10: 1.6989700043360185,
      ),
      SequenceMatchEstimatedTest(
        i: 7,
        j: 9,
        token: '123',
        sequenceName: 'digits',
        sequenceSpace: 10,
        ascending: true,
        guesses: 50,
        guessesLog10: 1.6989700043360185,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 5,
        token: 'TESTER',
        matchedWord: 'tester',
        rank: 619,
        dictionary: Dictionary.passwords,
        guesses: 1238,
        guessesLog10: 3.092720644684099,
        baseGuesses: 619,
        uppercaseVariations: 2,
        l33tVariations: 1,
      ),
      BruteForceMatchEstimatedTest(
        i: 6,
        j: 8,
        token: 'INO',
        guesses: 1000,
        guessesLog10: 2.9999999999999996,
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
    sequence: <MatchEstimated>[
      RepeatMatchEstimatedTest(
        i: 0,
        j: 6,
        token: 'aaaaaaa',
        baseToken: 'a',
        baseGuesses: 12,
        repeatCount: 7,
        guesses: 84,
        guessesLog10: 1.9242792860618814,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 5,
        token: 'Daniel',
        matchedWord: 'daniel',
        rank: 54,
        dictionary: Dictionary.passwords,
        guesses: 108,
        guessesLog10: 2.0334237554869494,
        baseGuesses: 54,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 7,
        token: '1234qwer',
        matchedWord: '1234qwer',
        rank: 104,
        dictionary: Dictionary.passwords,
        guesses: 104,
        guessesLog10: 2.0170333392987803,
        baseGuesses: 104,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 6,
        token: '1234qwe',
        matchedWord: '1234qwe',
        rank: 2977,
        dictionary: Dictionary.passwords,
        guesses: 2977,
        guessesLog10: 3.4737788346467244,
        baseGuesses: 2977,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 7,
        token: '1234qwer',
        matchedWord: '1234qwer',
        rank: 104,
        dictionary: Dictionary.passwords,
        guesses: 104,
        guessesLog10: 2.0170333392987803,
        baseGuesses: 104,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      BruteForceMatchEstimatedTest(
        i: 8,
        j: 8,
        token: 't',
        guesses: 11,
        guessesLog10: 1.041392685158225,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 7,
        token: 'password',
        matchedWord: 'password',
        rank: 2,
        dictionary: Dictionary.passwords,
        guesses: 2,
        guessesLog10: 0.30102999566398114,
        baseGuesses: 2,
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
    sequence: <MatchEstimated>[
      RegexMatchEstimatedTest(
        i: 0,
        j: 3,
        token: '2010',
        regexName: 'recentYear',
        regexMatch: RegExp('.*').firstMatch('2010')!,
        guesses: 50,
        guessesLog10: 1.6989700043360185,
      ),
      SequenceMatchEstimatedTest(
        i: 4,
        j: 6,
        token: 'abc',
        sequenceName: 'lower',
        sequenceSpace: 26,
        ascending: true,
        guesses: 50,
        guessesLog10: 1.6989700043360185,
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
    sequence: <MatchEstimated>[
      RepeatMatchEstimatedTest(
        i: 0,
        j: 11,
        token: 'abcabcabcabc',
        baseToken: 'abc',
        baseGuesses: 13,
        repeatCount: 4,
        guesses: 52,
        guessesLog10: 1.716003343634799,
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
    sequence: <MatchEstimated>[
      SpatialMatchEstimatedTest(
        i: 0,
        j: 3,
        token: 'qwer',
        graph: 'qwerty',
        turns: 1,
        shiftedCount: 0,
        guesses: 1296,
        guessesLog10: 3.112605001534574,
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
    sequence: <MatchEstimated>[
      L33tMatchEstimatedTest(
        i: 0,
        j: 7,
        token: r'P4$$w0rd',
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
        guessesLog10: 1.5051499783199058,
        baseGuesses: 2,
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
    sequence: <MatchEstimated>[
      BruteForceMatchEstimatedTest(
        i: 0,
        j: 3,
        token: 'aA!1',
        guesses: 10000,
        guessesLog10: 4,
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
    sequence: <MatchEstimated>[
      BruteForceMatchEstimatedTest(
        i: 0,
        j: 6,
        token: 'dgo9dsg',
        guesses: 10000000,
        guessesLog10: 7,
      ),
      DictionaryMatchEstimatedTest(
        i: 7,
        j: 9,
        token: 'has',
        matchedWord: 'has',
        rank: 24,
        dictionary: Dictionary.wikipedia,
        guesses: 50,
        guessesLog10: 1.6989700043360185,
        baseGuesses: 24,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      DictionaryMatchEstimatedTest(
        i: 10,
        j: 11,
        token: 'do',
        matchedWord: 'do',
        rank: 22,
        dictionary: Dictionary.commonWords,
        guesses: 50,
        guessesLog10: 1.6989700043360185,
        baseGuesses: 22,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      SequenceMatchEstimatedTest(
        i: 12,
        j: 14,
        token: 'ghi',
        sequenceName: 'lower',
        sequenceSpace: 26,
        ascending: true,
        guesses: 78,
        guessesLog10: 1.8920946026904801,
      ),
      BruteForceMatchEstimatedTest(
        i: 15,
        j: 33,
        token: '8/!&IT%§(ihsdhf8o7o',
        guesses: 10000000000000000000,
        guessesLog10: 19,
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
    sequence: <MatchEstimated>[
      SpatialMatchEstimatedTest(
        i: 0,
        j: 3,
        token: 'AZER',
        graph: 'azerty',
        turns: 1,
        shiftedCount: 4,
        guesses: 2640,
        guessesLog10: 3.421603926869831,
      ),
      BruteForceMatchEstimatedTest(
        i: 4,
        j: 5,
        token: 'YT',
        guesses: 100,
        guessesLog10: 2,
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
    sequence: <MatchEstimated>[
      BruteForceMatchEstimatedTest(
        i: 0,
        j: 0,
        token: 'z',
        guesses: 11,
        guessesLog10: 1.041392685158225,
      ),
      SpatialMatchEstimatedTest(
        i: 1,
        j: 8,
        token: 'xcftzuio',
        graph: 'qwertz',
        turns: 3,
        shiftedCount: 0,
        guesses: 580912,
        guessesLog10: 5.7641103478653735,
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
    sequence: <MatchEstimated>[
      BruteForceMatchEstimatedTest(
        i: 0,
        j: 1,
        token: 'bu',
        guesses: 100,
        guessesLog10: 2,
      ),
      RepeatMatchEstimatedTest(
        i: 2,
        j: 7,
        token: 'y by b',
        baseToken: 'y b',
        baseGuesses: 1001,
        repeatCount: 2,
        guesses: 2002,
        guessesLog10: 3.3014640731432996,
      ),
      BruteForceMatchEstimatedTest(
        i: 8,
        j: 10,
        token: 'eer',
        guesses: 1000,
        guessesLog10: 2.9999999999999996,
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
    sequence: <MatchEstimated>[
      DictionaryMatchEstimatedTest(
        i: 0,
        j: 4,
        token: 'horse',
        matchedWord: 'horse',
        rank: 862,
        dictionary: Dictionary.commonWords,
        guesses: 862,
        guessesLog10: 2.9355072658247123,
        baseGuesses: 862,
        uppercaseVariations: 1,
        l33tVariations: 1,
      ),
      BruteForceMatchEstimatedTest(
        i: 5,
        j: 12,
        token: ' stable ',
        guesses: 100000000,
        guessesLog10: 8,
      ),
      DictionaryMatchEstimatedTest(
        i: 13,
        j: 19,
        token: 'battery',
        matchedWord: 'battery',
        rank: 2181,
        dictionary: Dictionary.wikipedia,
        guesses: 2181,
        guessesLog10: 3.3386556655787,
        baseGuesses: 2181,
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
    sequence: <MatchEstimated>[
      BruteForceMatchEstimatedTest(
        i: 0,
        j: 35,
        token: 'a65a54cf-eadb-4f7c-893c-9d4a6f81f8c2',
        guesses: 1e36,
        guessesLog10: 35.99999999999999,
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
    sequence: <MatchEstimated>[],
  ),
];
