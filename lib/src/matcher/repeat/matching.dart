import 'dart:async';

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
  FutureOr<List<RepeatMatch>> match(String password) async {
    final List<FutureOr<RepeatMatch>> matches = <FutureOr<RepeatMatch>>[];
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
      matches.add(_repeatMatch(i, j, match[0]!, baseToken));
      lastIndex = j + 1;
    }
    return <RepeatMatch>[
      for (final FutureOr<RepeatMatch> match in matches)
        if (match is Future) await match else match
    ];
  }

  FutureOr<RepeatMatch> _repeatMatch(
    int i,
    int j,
    String token,
    String baseToken,
  ) async {
    final FutureOr<double> baseGuesses = _baseGuesses(baseToken);
    return RepeatMatch(
      i: i,
      j: j,
      token: token,
      baseToken: baseToken,
      baseGuesses: baseGuesses is Future ? await baseGuesses : baseGuesses,
      repeatCount: token.length ~/ baseToken.length,
    );
  }

  FutureOr<double> _baseGuesses(String baseToken) async {
    final FutureOr<List<Match>> matches = omniMatch.match(baseToken);
    final MatchSequence matchSequence = mostGuessableMatchSequence(
      baseToken,
      matches is Future ? await matches : matches,
    );
    return matchSequence.guesses;
  }
}
