import 'dart:math';

import '../../../../scoring/utils.dart';
import '../../../../types.dart';

int l33tScoring(Match match) {
  if (match is! L33tMatch) return 1;
  int variations = 1;
  // Lower-case match.token before calculating: capitalization shouldn't affect
  // l33t calc.
  final String tokenLower = match.token.toLowerCase();
  for (final PasswordChange change in match.changes) {
    // Num of l33t entries.
    final int l33tCount = _countSubstring(tokenLower, change.l33t);
    // Num of clean entries.
    final int cleanCount = _countSubstring(tokenLower, change.clean);
    if (l33tCount == 0 || cleanCount == 0) {
      // For this change, password is either fully l33t (444) or fully
      // clean (aaa) treat that as doubling the space (attacker needs to try
      // fully l33t chars in addition to clean).
      variations *= 2;
    } else {
      // This case is similar to capitalization:
      // with aa44a, clean = 3, l33t = 2, attacker needs to try
      // clean + one l33t + two l33ts
      int possibilities = 0;
      for (int i = 1; i <= min(cleanCount, l33tCount); i += 1) {
        possibilities += nCk(cleanCount + l33tCount, i);
      }
      variations *= possibilities;
    }
  }
  return variations;
}

int _countSubstring(String string, String substring) {
  int count = 0;
  int pos = string.indexOf(substring);
  while (pos >= 0) {
    count++;
    pos = string.indexOf(substring, pos + substring.length);
  }
  return count;
}
