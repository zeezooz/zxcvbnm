import 'dart:math';

import '../../../../data/const.dart';
import '../../../../scoring/utils.dart';
import '../../../../types.dart';

double uppercaseScoring(Match match) {
  // Clean words of non alpha characters to remove the reward effect to
  // capitalize the first letter https://github.com/dropbox/zxcvbn/issues/232
  final String cleanedWord = match.token.replaceAll(alphaInverted, '');
  if (allLowerInverted.hasMatch(cleanedWord) ||
      cleanedWord.toLowerCase() == cleanedWord) {
    return 1;
  }
  // A capitalized word is the most common capitalization scheme,
  // so it only doubles the search space (uncapitalized + capitalized).
  // All caps and end-capitalized are common enough too, underestimate as 2x
  // factor to be safe.
  final List<RegExp> commonCases = <RegExp>[
    startUpper,
    endUpper,
    allUpperInverted,
  ];
  for (int i = 0; i < commonCases.length; i++) {
    final RegExp regExp = commonCases[i];
    if (regExp.hasMatch(cleanedWord)) return 2;
  }
  // Otherwise calculate the number of ways to capitalize uppercase+lowercase
  // letters with upperCaseCount uppercase letters or less. or, if there's more
  // uppercase than lower (for eg. PASSwORD), the number of ways to lowercase
  // uppercase+lowercase letters with lowerCaseCount lowercase letters or less.
  final int upperCaseCount = oneUpper.allMatches(cleanedWord).length;
  final int lowerCaseCount = oneLower.allMatches(cleanedWord).length;
  double variations = 0;
  for (int i = 1; i <= min(upperCaseCount, lowerCaseCount); i++) {
    variations += nCk(upperCaseCount + lowerCaseCount, i);
  }
  return variations;
}
