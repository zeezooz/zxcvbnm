import 'dart:math';

import '../feedback.dart';
import '../matchers/base_matcher.dart';
import '../options.dart';

/// Matches dates.
class DateMatcher extends BaseMatcher {
  /// Creates a matcher.
  DateMatcher(this.options);

  /// Options and translation.
  final Options options;

  /// Returns date matches for the [password].
  ///
  /// A "date" is recognized as:
  ///   - any 3-tuple that starts or ends with a 2- or 4-digit year,
  ///   - with 2 or 0 separator chars (1.1.91 or 1191),
  ///   - maybe zero-padded (01-01-91 vs 1-1-91),
  ///   - a month between 1 and 12,
  ///   - a day between 1 and 31.
  ///
  /// Note: this isn't true date parsing in that "feb 31st" is allowed,
  /// this doesn't check for leap years, etc.
  ///
  /// Recipe:
  /// Start with regex to find maybe-dates, then attempt to map the integers
  /// onto month-day-year to filter the maybe-dates into dates.
  /// Finally, remove matches that are substrings of other matches to reduce
  /// noise.
  ///
  /// Note: instead of using a lazy or greedy regex to find many dates over
  /// the full string, this uses a ^...$ regex against every substring of the
  /// password - less performant but leads to every possible date match.
  @override
  List<List<DateMatch>> match(String password) {
    final List<DateMatch> matches = <DateMatch>[
      ..._matchesWithSeparator(password),
      ..._matchesWithoutSeparator(password),
    ];
    return <List<DateMatch>>[_filterNoise(matches)];
  }

  List<DateMatch> _matchesWithSeparator(String password) {
    final List<DateMatch> matches = <DateMatch>[];
    final RegExp maybeDateWithSeparator =
        RegExp(r'^(\d{1,4})([\s/\\_.-])(\d{1,2})\2(\d{1,4})$');
    // Dates with separators are between length 6 '1/1/91' and 10 '11/11/1991'.
    for (int start = 0; start <= password.length - 6; start++) {
      for (int end = start + 6;
          end <= start + 10 && end <= password.length;
          end++) {
        final String token = password.substring(start, end);
        final RegExpMatch? match = maybeDateWithSeparator.firstMatch(token);
        if (match == null) continue;
        final _Date? date = _dayMonthYear(
          int.parse(match[1]!),
          int.parse(match[3]!),
          int.parse(match[4]!),
        );
        if (date == null) continue;
        matches.add(
          DateMatch(
            password: password,
            start: start,
            end: end,
            separator: match[2]!,
            year: date.year,
            month: date.month,
            day: date.day,
            options: options,
          ),
        );
      }
    }
    return matches;
  }

  int _metric(_Date date) => (date.year - options.currentYear).abs();

  List<DateMatch> _matchesWithoutSeparator(String password) {
    final List<DateMatch> matches = <DateMatch>[];
    final RegExp maybeDateWithoutSeparator = RegExp(r'^\d{4,8}$');
    // Dates without separators are between length 4 '1191' and 8 '11111991'.
    for (int start = 0; start <= password.length - 4; start++) {
      for (int end = start + 4;
          end <= start + 8 && end <= password.length;
          end++) {
        final String token = password.substring(start, end);
        if (maybeDateWithoutSeparator.hasMatch(token)) {
          final List<_Date> candidates = <_Date>[];
          final List<List<int>>? dateSplit = dateSplits[token.length];
          if (dateSplit == null) continue;
          for (final List<int> split in dateSplit) {
            final _Date? date = _dayMonthYear(
              int.parse(token.substring(0, split[0])),
              int.parse(token.substring(split[0], split[1])),
              int.parse(token.substring(split[1])),
            );
            if (date != null) candidates.add(date);
          }
          if (candidates.isEmpty) continue;
          // At this point: different possible date mappings for the same
          // start,end substring. Match the candidate date that likely takes
          // the fewest guesses: a year closest to currentYear.
          //
          // I.e., considering '111504', prefer 11-15-04 to 1-1-1504
          // (interpreting '04' as 2004).
          _Date bestCandidate = candidates[0];
          int minDistance = _metric(candidates[0]);
          for (final _Date candidate in candidates.skip(1)) {
            final int distance = _metric(candidate);
            if (distance < minDistance) {
              bestCandidate = candidate;
              minDistance = distance;
            }
          }
          matches.add(
            DateMatch(
              password: password,
              start: start,
              end: end,
              separator: '',
              year: bestCandidate.year,
              month: bestCandidate.month,
              day: bestCandidate.day,
              options: options,
            ),
          );
        }
      }
    }
    return matches;
  }

  /// Possible indexes of the date parts for a date without separators.
  Map<int, List<List<int>>> get dateSplits => const <int, List<List<int>>>{
        4: <List<int>>[
          // For length-4 strings, eg 1191 or 9111, two ways to split:
          <int>[1, 2], // 1 1 91 (2nd split starts at index 1, 3rd at index 2)
          <int>[2, 3], // 91 1 1
        ],
        5: <List<int>>[
          <int>[1, 3], // 1 11 91
          <int>[2, 3], // 11 1 91
          // <int>[2, 3], // 91 1 11    <- Duplicate previous one.
          <int>[2, 4], // 91 11 1    <- New and must be added as bug fix.
        ],
        6: <List<int>>[
          <int>[1, 2], // 1 1 1991
          <int>[2, 4], // 11 11 91
          <int>[4, 5], // 1991 1 1
        ],
        7: <List<int>>[
          <int>[1, 3], // 1 11 1991
          <int>[2, 3], // 11 1 1991
          <int>[4, 5], // 1991 1 11
          <int>[4, 6], // 1991 11 1
        ],
        8: <List<int>>[
          <int>[2, 4], // 11 11 1991
          <int>[4, 6], // 1991 11 11
        ],
      };

  /// Removes date matches that are strict substrings of others to reduce noise.
  ///
  /// Matches contain all valid date strings in a way that is tricky
  /// to capture with regexes only. While thorough, it will contain some
  /// unintuitive noise:
  /// '2015_06_04', in addition to matching 2015_06_04, will also contain
  /// 5(!) other date matches: 15_06_04, 5_06_04, ..., even 2015
  /// (matched as 5/1/2020).
  List<DateMatch> _filterNoise(List<DateMatch> matches) {
    return matches.where((DateMatch match) {
      for (final DateMatch otherMatch in matches) {
        if (match != otherMatch &&
            otherMatch.start <= match.start &&
            otherMatch.end >= match.end) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Tries to convert 3 integers to a date.
  ///
  /// Returns null if:
  ///   - middle int is over 31 (for all date formats, year is never allowed
  ///     in the middle),
  ///   - middle int is zero,
  ///   - any int is over the max allowable year,
  ///   - any int is over two digits but under the min allowable year,
  ///   - 2 integers are over 31, the max allowable day,
  ///   - 2 integers are zero,
  ///   - all integers are over 12, the max allowable month.
  _Date? _dayMonthYear(int integer1, int integer2, int integer3) {
    if (integer2 > 31 || integer2 <= 0) return null;
    int over12 = 0;
    int over31 = 0;
    int under1 = 0;
    for (final int integer in <int>[integer1, integer2, integer3]) {
      if ((integer > 99 && integer < minYear) || integer > maxYear) {
        return null;
      }
      if (integer > 31) over31++;
      if (integer > 12) over12++;
      if (integer <= 0) under1++;
    }
    if (over31 >= 2 || over12 == 3 || under1 >= 2) return null;
    // First look for a four digit year: yyyy + daymonth or daymonth + yyyy.
    final List<List<int>> yearSplits = <List<int>>[
      // Year last.
      <int>[integer3, integer2, integer1],
      // Year first.
      <int>[integer1, integer2, integer3],
    ];
    for (final List<int> yearSplit in yearSplits) {
      final int year = yearSplit[0];
      if (year >= minYear && year <= maxYear) {
        final _Date? dm = _dayMonth(yearSplit[1], yearSplit[2]);
        // For a candidate that includes a four-digit year, when the remaining
        // integers don't match to a day and month, it is not a date.
        if (dm == null) return null;
        return _Date(year: year, month: dm.month, day: dm.day);
      }
    }
    // Given no four-digit year, two digit years are the most flexible int
    // to match.
    for (final List<int> yearSplit in yearSplits) {
      final int year = yearSplit[0];
      final _Date? dm = _dayMonth(yearSplit[1], yearSplit[2]);
      if (dm != null) {
        return _Date(year: _fourDigitYear(year), month: dm.month, day: dm.day);
      }
    }
    return null;
  }

  /// The minimum year to match.
  int get minYear => 1000;

  /// The maximum year to match.
  int get maxYear => 2050;

  /// Tries to convert 2 integers to a date without a year.
  _Date? _dayMonth(int integer1, int integer2) {
    final List<List<int>> variants = <List<int>>[
      <int>[integer1, integer2],
      <int>[integer2, integer1],
    ];
    for (final List<int> integers in variants) {
      final int day = integers[0];
      final int month = integers[1];
      if (day >= 1 && day <= 31 && month >= 1 && month <= 12) {
        return _Date(year: 0, month: month, day: day);
      }
    }
    return null;
  }

  /// Expands the [year] to 4 digits.
  int _fourDigitYear(int year) {
    if (year > 99) return year;
    // 87 -> 1987
    if (year > 50) return year + 1900;
    // 15 -> 2015
    return year + 2000;
  }
}

class _Date {
  const _Date({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;
}

/// A match for a date.
class DateMatch extends BaseMatch {
  /// Creates a match.
  DateMatch({
    required String password,
    required int start,
    required int end,
    required this.separator,
    required this.year,
    required this.month,
    required this.day,
    required this.options,
  }) : super(password: password, start: start, end: end);

  /// The separator of the date parts.
  final String separator;

  /// The year of the date.
  final int year;

  /// The month of the date.
  final int month;

  /// The day of the date.
  final int day;

  /// Options and translation.
  final Options options;

  @override
  double get estimatedGuesses {
    // Base guesses: (year distance from currentYear) * num_days.
    final int yearSpace =
        max((year - options.currentYear).abs(), options.minYearSpace);
    double guesses = yearSpace * 365;
    // Add factor of 4 for separator selection (one of ~4 choices).
    if (separator.isNotEmpty) guesses *= 4;
    return guesses;
  }

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return Feedback(
      warning: options.translation.warnings.dates,
      suggestions: <String>[options.translation.suggestions.dates],
    );
  }

  @override
  String toString() => '${super.toString()}, separator: "$separator", '
      'date: $year-$month-$day';
}
