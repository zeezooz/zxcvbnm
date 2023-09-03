import 'dart:math';

import '../feedback.dart';
import '../options.dart';
import 'base_matcher.dart';

/// Regular expression matcher.
class RegExMatcher extends BaseMatcher {
  /// Creates a matcher.
  RegExMatcher(this.options);

  /// Options and translation.
  final Options options;

  @override
  List<List<RegExMatch>> match(String password) {
    final List<RegExMatch> matches = <RegExMatch>[];
    regExes.forEach((String name, RegExp regEx) {
      for (final RegExpMatch match in regEx.allMatches(password)) {
        matches.add(
          RegExMatch(
            password: password,
            start: match.start,
            end: match.end,
            regExName: name,
            options: options,
          ),
        );
      }
    });
    return <List<RegExMatch>>[matches];
  }

  /// Regular expressions to match.
  Map<String, RegExp> get regExes => <String, RegExp>{
        'recentYear': RegExp(r'19\d\d|200\d|201\d|202\d'),
      };
}

/// A match for a regular expression.
class RegExMatch extends BaseMatch {
  /// Creates a match.
  RegExMatch({
    required String password,
    required int start,
    required int end,
    required this.regExName,
    required this.options,
  }) : super(password: password, start: start, end: end);

  /// The name of matched regular expression.
  final String regExName;

  /// Options and translation.
  final Options options;

  @override
  double get estimatedGuesses {
    const Map<String, double> charClassBases = <String, double>{
      'alphaLower': 26,
      'alphaUpper': 26,
      'alpha': 52,
      'alphanumeric': 62,
      'digits': 10,
      'symbols': 33,
    };
    if (charClassBases.containsKey(regExName)) {
      return pow(charClassBases[regExName]!, length).toDouble();
    }
    // TODO: Add more regex types for example special dates like 09.11
    switch (regExName) {
      case 'recentYear':
        // Conservative estimate of year space: num years from currentYear.
        // If year is close to currentYear, estimate a year space of
        // minYearSpace.
        return max(
          (int.parse(token) - options.currentYear).abs(),
          options.minYearSpace,
        ).toDouble();
    }
    return 0;
  }

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    switch (regExName) {
      case 'recentYear':
        return Feedback(
          warning: options.translation.warnings.recentYears,
          suggestions: <String>[
            options.translation.suggestions.recentYears,
            options.translation.suggestions.associatedYears,
          ],
        );
    }
    return null;
  }

  @override
  String toString() => '${super.toString()}, regExName: $regExName';
}
