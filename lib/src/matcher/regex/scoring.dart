import 'dart:math';

import '../../options.dart';
import '../../types.dart';

double regexScoring(RegexMatch match, Options options) {
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
      // Conservative estimate of year space: num years from currentYear.
      // If year is close to currentYear, estimate a year space of
      // minYearSpace.
      return max(
        (int.parse(match.token) - options.currentYear).abs(),
        options.minYearSpace,
      ).toDouble();
  }
  return 0;
}
