import 'dart:async';

import '../../helper.dart';
import '../../matching.dart';
import '../../scoring/index.dart';
import '../../types.dart';

/// Repeat matching (aaa, abcabcabc).
class MatchRepeat extends MatchingType {
  MatchRepeat(this.omniMatch);

  final OmniMatch omniMatch;

  final RegExp greedyRegExp = RegExp(r'(.+)\1+');
  final RegExp lazyRegExp = RegExp(r'(.+?)\1+');
  final RegExp lazyAnchoredRegExp = RegExp(r'^(.+?)\1+$');

  @override
  List<FutureOr<List<RepeatMatch>>> match(String password) {
    final List<RepeatMatch> matches = <RepeatMatch>[];
    final List<Future<RepeatMatch>> futures = <Future<RepeatMatch>>[];
    int lastIndex = 0;
    while (lastIndex < password.length) {
      final RegExpMatch? greedyMatch =
          greedyRegExp.firstMatch(password.substring(lastIndex));
      final RegExpMatch? lazyMatch =
          lazyRegExp.firstMatch(password.substring(lastIndex));
      if (greedyMatch == null || lazyMatch == null) break;
      RegExpMatch? match;
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
        final RegExpMatch? temp = lazyAnchoredRegExp.firstMatch(match[0]!);
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
      final int i = lastIndex + match.start;
      final int j = lastIndex + match.end - 1;
      final FutureOr<RepeatMatch> repeatMatch =
          // ignore: discarded_futures
          _repeatMatch(i, j, match[0]!, baseToken);
      if (repeatMatch is RepeatMatch) {
        matches.add(repeatMatch);
      } else {
        futures.add(repeatMatch);
      }
      lastIndex = j + 1;
    }
    return <FutureOr<List<RepeatMatch>>>[
      matches,
      // ignore: discarded_futures
      if (futures.isNotEmpty) Future.wait(futures),
    ];
  }

  FutureOr<RepeatMatch> _repeatMatch(
    int i,
    int j,
    String token,
    String baseToken,
  ) {
    final List<FutureOr<List<Match>>> result = omniMatch.match(baseToken);
    final List<Match> matches = synchronousMatches(result);
    final List<Future<List<Match>>> futures = asynchronousMatches(result);
    if (futures.isEmpty) {
      return _repeatMatchWithGuesses(matches, baseToken, token, i, j);
    }
    return Future.wait(futures).then((List<List<Match>> results) {
      for (final List<Match> result in results) {
        matches.addAll(result);
      }
      return _repeatMatchWithGuesses(matches, baseToken, token, i, j);
    });
  }

  RepeatMatch _repeatMatchWithGuesses(
    List<Match> matches,
    String baseToken,
    String token,
    int i,
    int j,
  ) {
    final double baseGuesses = mostGuessableMatchSequence(
      baseToken,
      matches,
      omniMatch.options,
    ).guesses;
    final int repeatCount = token.length ~/ baseToken.length;
    return RepeatMatch(
      i: i,
      j: j,
      token: token,
      baseToken: baseToken,
      baseGuesses: baseGuesses,
      repeatCount: repeatCount,
    );
  }
}
