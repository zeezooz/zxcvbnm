import 'dart:math';

import '../../data/const.dart';
import '../../types.dart';

double regexScoring(RegexMatch match) {
  const Map<String, int> charClassBases = <String, int>{
    'alphaLower': 26,
    'alphaUpper': 26,
    'alpha': 52,
    'alphanumeric': 62,
    'digits': 10,
    'symbols': 33,
  };
  if (charClassBases.containsKey(match.regexName)) {
    return pow(charClassBases[match.regexName]!.toDouble(), match.length)
        .toDouble();
  }
  // TODO: Add more regex types for example special dates like 09.11
  switch (match.regexName) {
    case 'recentYear':
      // Conservative estimate of year space: num years from referenceYear.
      // If year is close to referenceYear, estimate a year space of
      // minYearSpace.
      return max((int.parse(match.token) - referenceYear).abs(), minYearSpace)
          .toDouble();
  }
  return 0;
}
