import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/date/matching.dart';
import 'package:zxcvbnm/src/types.dart';

import '../../helper/check_matches.dart';
import '../../helper/genpws.dart';

void main() {
  group('Date matching.', () {
    final MatchDate matchDate = MatchDate();
    String password;
    List<Match> matches;
    String msg;
    List<String> data = <String>['', ' ', '-', '/', r'\', '_', '.'];
    for (final String sep in data) {
      password = '13${sep}2${sep}1921';
      matches = matchDate.match(password: password);
      msg = "Matches dates that use '$sep' as a separator";
      checkMatches(msg, matches, Pattern.date, <String>[
        password,
      ], <List<int>>[
        <int>[0, password.length - 1],
      ], <String, List<Object>>{
        'separator': <String>[sep],
        'year': <int>[1921],
        'month': <int>[2],
        'day': <int>[13],
      });
    }

    data = <String>['mdy', 'dmy', 'ymd', 'ydm'];
    for (final String order in data) {
      const int d = 8;
      const int m = 8;
      const int y = 88;
      password = order
          .replaceFirst('y', y.toString())
          .replaceFirst('m', m.toString())
          .replaceFirst('d', d.toString());
      matches = matchDate.match(password: password);
      msg = "Matches dates with '$order' format";
      checkMatches(msg, matches, Pattern.date, <String>[
        password,
      ], <List<int>>[
        <int>[0, password.length - 1],
      ], <String, List<Object>>{
        'separator': <String>[''],
        'year': <int>[1988],
        'month': <int>[8],
        'day': <int>[8],
      });
    }

    password = '111504';
    matches = matchDate.match(password: password);
    msg = 'Matches the date with year closest to referenceYear when ambiguous';
    checkMatches(msg, matches, Pattern.date, <String>[
      password,
    ], <List<int>>[
      <int>[0, password.length - 1],
    ], <String, List<Object>>{
      'separator': <String>[''],
      'year': <int>[2004],
      'month': <int>[11],
      'day': <int>[15],
    });

    const List<List<int>> numberData = <List<int>>[
      <int>[1, 1, 1999],
      <int>[11, 8, 2000],
      <int>[9, 12, 2005],
      <int>[22, 11, 1551],
    ];
    for (final List<int> dmy in numberData) {
      final int day = dmy[0];
      final int month = dmy[1];
      final int year = dmy[2];
      password = '$year$month$day';
      matches = matchDate.match(password: password);
      msg = 'Matches $password';
      checkMatches(msg, matches, Pattern.date, <String>[
        password,
      ], <List<int>>[
        <int>[0, password.length - 1],
      ], <String, List<Object>>{
        'separator': <String>[''],
        'year': <int>[year],
      });
      password = '$year.$month.$day';
      matches = matchDate.match(password: password);
      msg = 'Matches $password';
      checkMatches(msg, matches, Pattern.date, <String>[
        password,
      ], <List<int>>[
        <int>[0, password.length - 1],
      ], <String, List<Object>>{
        'separator': <String>['.'],
        'year': <int>[year],
      });
    }

    password = '02/02/02';
    matches = matchDate.match(password: password);
    msg = 'Matches zero-padded dates';
    checkMatches(msg, matches, Pattern.date, <String>[
      password,
    ], <List<int>>[
      <int>[0, password.length - 1],
    ], <String, List<Object>>{
      'separator': <String>['/'],
      'year': <int>[2002],
      'month': <int>[2],
      'day': <int>[2],
    });

    const List<String> prefixes = <String>['a', 'ab'];
    const List<String> suffixes = <String>['!'];
    const String pattern = '1/1/91';
    final List<List<Object>> generatedPws = genpws(pattern, prefixes, suffixes);

    for (final List<Object> data in generatedPws) {
      final String dataPassword = data[0] as String;
      final int i = data[1] as int;
      final int j = data[2] as int;
      matches = matchDate.match(password: dataPassword);
      msg = 'Matches embedded dates';
      checkMatches(msg, matches, Pattern.date, <String>[
        pattern,
      ], <List<int>>[
        <int>[i, j],
      ], <String, List<Object>>{
        'year': <int>[1991],
        'month': <int>[1],
        'day': <int>[1],
      });
    }

    matches = matchDate.match(password: '12/20/1991.12.20');
    msg = 'Matches overlapping dates';
    checkMatches(msg, matches, Pattern.date, <String>[
      '12/20/1991',
      '1991.12.20',
    ], <List<int>>[
      <int>[0, 9],
      <int>[6, 15],
    ], <String, List<Object>>{
      'separator': <String>['/', '.'],
      'year': <int>[1991, 1991],
      'month': <int>[12, 12],
      'day': <int>[20, 20],
    });

    matches = matchDate.match(password: '912/20/919');
    msg = 'Matches dates padded by non-ambiguous digits';
    checkMatches(msg, matches, Pattern.date, <String>[
      '12/20/91',
    ], <List<int>>[
      <int>[1, 8],
    ], <String, List<Object>>{
      'separator': <String>['/'],
      'year': <int>[1991],
      'month': <int>[12],
      'day': <int>[20],
    });
  });
}
