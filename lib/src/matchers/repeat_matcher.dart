import 'dart:async';

import '../feedback.dart';
import '../helper.dart';
import '../matching.dart';
import '../scoring.dart';
import '../translation.dart';
import 'base_matcher.dart';

/// Matches repeats (aaa, abcabcabc).
class RepeatMatcher extends BaseMatcher {
  /// Creates a matcher.
  RepeatMatcher(this.omniMatcher);

  /// All matchers combined.
  final OmniMatcher omniMatcher;

  @override
  List<FutureOr<List<RepeatMatch>>> match(String password) {
    final List<RepeatMatch> matches = <RepeatMatch>[];
    final List<Future<RepeatMatch>> futures = <Future<RepeatMatch>>[];
    int lastIndex = 0;
    while (lastIndex < password.length) {
      final RegExpMatch? greedyMatch =
          _greedyRegExp.firstMatch(password.substring(lastIndex));
      final RegExpMatch? lazyMatch =
          _lazyRegExp.firstMatch(password.substring(lastIndex));
      if (greedyMatch == null || lazyMatch == null) break;
      RegExpMatch match;
      String baseToken = '';
      if (greedyMatch[0]!.length > lazyMatch[0]!.length) {
        // Greedy beats lazy for 'aabaab':
        // greedy: [aabaab, aab]
        // lazy: [aa, a].
        match = greedyMatch;
        // Greedy repeated string might itself be repeated, eg.
        // aabaab in aabaabaabaab.
        // Run an anchored lazy match on greedy repeated string
        // to find the shortest repeated string.
        final RegExpMatch? temp = _lazyAnchoredRegExp.firstMatch(match[0]!);
        if (temp != null) {
          baseToken = temp[1]!;
        }
      } else {
        // Lazy beats greedy for 'aaaaa':
        // greedy: [aaaa, aa]
        // lazy: [aaaaa, a].
        match = lazyMatch;
        baseToken = match[1]!;
      }
      final int start = lastIndex + match.start;
      final int end = lastIndex + match.end;
      final FutureOr<RepeatMatch> repeatMatch =
          // ignore: discarded_futures
          _repeatMatch(password, start, end, baseToken);
      if (repeatMatch is RepeatMatch) {
        matches.add(repeatMatch);
      } else {
        futures.add(repeatMatch);
      }
      lastIndex = end;
    }
    return <FutureOr<List<RepeatMatch>>>[
      matches,
      // ignore: discarded_futures
      if (futures.isNotEmpty) Future.wait(futures),
    ];
  }

  final RegExp _greedyRegExp = RegExp(r'(.+)\1+');

  final RegExp _lazyRegExp = RegExp(r'(.+?)\1+');

  final RegExp _lazyAnchoredRegExp = RegExp(r'^(.+?)\1+$');

  FutureOr<RepeatMatch> _repeatMatch(
    String password,
    int start,
    int end,
    String baseToken,
  ) {
    final List<FutureOr<List<BaseMatch>>> result = omniMatcher.match(baseToken);
    final List<BaseMatch> matches = synchronousMatches(result);
    final List<Future<List<BaseMatch>>> futures = asynchronousMatches(result);
    if (futures.isEmpty) {
      return _repeatMatchWithGuesses(
        matches,
        password,
        start,
        end,
        baseToken,
      );
    }
    return Future.wait(futures).then((List<List<BaseMatch>> results) {
      for (final List<BaseMatch> result in results) {
        matches.addAll(result);
      }
      return _repeatMatchWithGuesses(
        matches,
        password,
        start,
        end,
        baseToken,
      );
    });
  }

  RepeatMatch _repeatMatchWithGuesses(
    List<BaseMatch> matches,
    String password,
    int start,
    int end,
    String baseToken,
  ) {
    final double baseGuesses = mostGuessableMatchSequence(
      baseToken,
      matches,
    ).guesses;
    return RepeatMatch(
      password: password,
      start: start,
      end: end,
      baseToken: baseToken,
      baseGuesses: baseGuesses,
    );
  }
}

/// A match for a repeating string.
class RepeatMatch extends BaseMatch {
  /// Creates a match.
  RepeatMatch({
    required String password,
    required int start,
    required int end,
    required this.baseToken,
    required this.baseGuesses,
  }) : super(password: password, start: start, end: end);

  /// The repeating string.
  final String baseToken;

  /// The number of guesses for the [baseToken].
  final double baseGuesses;

  /// The number of repetitions of the [baseToken].
  int get repeatCount => length ~/ baseToken.length;

  @override
  double get estimatedGuesses => baseGuesses * repeatCount;

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return Feedback(
      warning: baseToken.length == 1
          ? Translation.warnings.simpleRepeat
          : Translation.warnings.extendedRepeat,
      suggestions: <String>[Translation.suggestions.repeated],
    );
  }

  @override
  String toString() => '${super.toString()}, baseToken: "$baseToken", '
      'baseGuesses: $baseGuesses, repeatCount: $repeatCount';
}
