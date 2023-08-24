import '../../data/const.dart';
import '../../data/date_splits.dart';
import '../../matchers/base_matcher.dart';
import '../../options.dart';
import '../../types.dart';

/// Date matching.
class MatchDate extends BaseMatcher {
  MatchDate(this.options);

  final Options options;

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
  /// password -- less performant but leads to every possible date match.
  @override
  List<List<DateMatch>> match(String password) {
    final List<DateMatch> matches = <DateMatch>[
      ..._matchesWithoutSeparator(password),
      ..._matchesWithSeparator(password),
    ];
    return <List<DateMatch>>[_filterNoise(matches)];
  }

  List<DateMatch> _matchesWithSeparator(String password) {
    final List<DateMatch> matches = <DateMatch>[];
    final RegExp maybeDateWithSeparator =
        RegExp(r'^(\d{1,4})([\s/\\_.-])(\d{1,2})\2(\d{1,4})$');
    // Dates with separators are between length 6 '1/1/91' and 10 '11/11/1991'.
    for (int i = 0; i <= password.length - 6; i++) {
      for (int j = i + 6; j <= i + 10 && j <= password.length; j++) {
        final String token = password.substring(i, j);
        final RegExpMatch? match = maybeDateWithSeparator.firstMatch(token);
        if (match == null) continue;
        final DayMonthYear? dmy = _dayMonthYear(<int>[
          int.parse(match[1]!),
          int.parse(match[3]!),
          int.parse(match[4]!),
        ]);
        if (dmy == null) continue;
        matches.add(
          DateMatch(
            password: password,
            start: i,
            end: j,
            separator: match[2]!,
            year: dmy.year,
            month: dmy.month,
            day: dmy.day,
            options: options,
          ),
        );
      }
    }
    return matches;
  }

  int _metric(DayMonthYear candidate) => (candidate.year - referenceYear).abs();

  List<DateMatch> _matchesWithoutSeparator(String password) {
    final List<DateMatch> matches = <DateMatch>[];
    final RegExp maybeDateWithoutSeparator = RegExp(r'^\d{4,8}$');
    // Dates without separators are between length 4 '1191' and 8 '11111991'.
    for (int i = 0; i <= password.length - 4; i++) {
      for (int j = i + 4; j <= i + 8 && j <= password.length; j++) {
        final String token = password.substring(i, j);
        if (maybeDateWithoutSeparator.hasMatch(token)) {
          final List<DayMonthYear> candidates = <DayMonthYear>[];
          final List<List<int>>? dateSplit = dateSplits[token.length];
          if (dateSplit == null) continue;
          for (final List<int> kl in dateSplit) {
            final int k = kl[0];
            final int l = kl[1];
            final DayMonthYear? dmy = _dayMonthYear(<int>[
              int.parse(token.substring(0, k)),
              int.parse(token.substring(k, l)),
              int.parse(token.substring(l)),
            ]);
            if (dmy != null) candidates.add(dmy);
          }
          if (candidates.isEmpty) continue;
          // At this point: different possible dmy mappings for the same i,j
          // substring. Match the candidate date that likely takes the fewest
          // guesses: a year closest to referenceYear.
          //
          // I.e., considering '111504', prefer 11-15-04 to 1-1-1504
          // (interpreting '04' as 2004).
          DayMonthYear bestCandidate = candidates[0];
          int minDistance = _metric(candidates[0]);
          for (final DayMonthYear candidate in candidates.skip(1)) {
            final int distance = _metric(candidate);
            if (distance < minDistance) {
              bestCandidate = candidate;
              minDistance = distance;
            }
          }
          matches.add(
            DateMatch(
              password: password,
              start: i,
              end: j,
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

  /// Matches now contains all valid date strings in a way that is tricky
  /// to capture with regexes only. While thorough, it will contain some
  /// unintuitive noise:
  /// '2015_06_04', in addition to matching 2015_06_04, will also contain
  /// 5(!) other date matches: 15_06_04, 5_06_04, ..., even 2015
  /// (matched as 5/1/2020).
  ///
  /// To reduce noise, remove date matches that are strict substrings of others.
  List<DateMatch> _filterNoise(List<DateMatch> matches) {
    return matches.where((DateMatch match) {
      for (int i = 0; i < matches.length; i++) {
        final DateMatch otherMatch = matches[i];
        if (match != otherMatch &&
            otherMatch.start <= match.start &&
            otherMatch.end >= match.end) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Given a 3-tuple, discard if:
  ///   - middle int is over 31 (for all dmy formats, years are never allowed
  ///     in the middle),
  ///   - middle int is zero,
  ///   - any int is over the max allowable year,
  ///   - any int is over two digits but under the min allowable year,
  ///   - 2 integers are over 31, the max allowable day,
  ///   - 2 integers are zero,
  ///   - all integers are over 12, the max allowable month.
  DayMonthYear? _dayMonthYear(List<int> integers) {
    if (integers[1] > 31 || integers[1] <= 0) return null;
    int over12 = 0;
    int over31 = 0;
    int under1 = 0;
    for (int i = 0; i < integers.length; i++) {
      final int integer = integers[i];
      if ((integer > 99 && integer < dateMinYear) || integer > dateMaxYear) {
        return null;
      }
      if (integer > 31) over31++;
      if (integer > 12) over12++;
      if (integer <= 0) under1++;
    }
    if (over31 >= 2 || over12 == 3 || under1 >= 2) return null;
    // First look for a four digit year: yyyy + daymonth or daymonth + yyyy.
    final List<List<List<int>>> yearSplits = <List<List<int>>>[
      // Year last.
      <List<int>>[
        <int>[integers[2]],
        integers.sublist(0, 2),
      ],
      // Year first.
      <List<int>>[
        <int>[integers[0]],
        integers.sublist(1, 3),
      ],
    ];
    for (int i = 0; i < yearSplits.length; i++) {
      final int year = yearSplits[i][0][0];
      final List<int> rest = yearSplits[i][1];
      if (year >= dateMinYear && year <= dateMaxYear) {
        final DayMonthYear? dm = _dayMonth(rest);
        // For a candidate that includes a four-digit year, when the remaining
        // integers don't match to a day and month, it is not a date.
        if (dm == null) return null;
        return DayMonthYear(year: year, month: dm.month, day: dm.day);
      }
    }
    // Given no four-digit year, two digit years are the most flexible int
    // to match, so try to parse a day-month out of integers[0..1] or
    // integers[1..0].
    for (int i = 0; i < yearSplits.length; i++) {
      final int year = yearSplits[i][0][0];
      final List<int> rest = yearSplits[i][1];
      final DayMonthYear? dm = _dayMonth(rest);
      if (dm != null) {
        return DayMonthYear(
          year: _fourDigitYear(year),
          month: dm.month,
          day: dm.day,
        );
      }
    }
    return null;
  }

  DayMonthYear? _dayMonth(List<int> integers) {
    final List<List<int>> temp = <List<int>>[
      integers,
      integers.reversed.toList(),
    ];
    for (int i = 0; i < temp.length; i++) {
      final List<int> data = temp[i];
      final int day = data[0];
      final int month = data[1];
      if (day >= 1 && day <= 31 && month >= 1 && month <= 12) {
        return DayMonthYear(year: 0, month: month, day: day);
      }
    }
    return null;
  }

  int _fourDigitYear(int year) {
    if (year > 99) return year;
    // 87 -> 1987
    if (year > 50) return year + 1900;
    // 15 -> 2015
    return year + 2000;
  }
}

class DayMonthYear {
  const DayMonthYear({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;
}
