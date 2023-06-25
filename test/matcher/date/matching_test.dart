import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/date/matching.dart';
import 'package:zxcvbnm/src/types.dart';

import '../../helper/generate_passwords.dart';

class DateMatchTest extends DateMatch {
  const DateMatchTest({
    required int i,
    required int j,
    required String token,
    required String separator,
    required int year,
    int month = -1,
    int day = -1,
  }) : super(
          i: i,
          j: j,
          token: token,
          separator: separator,
          year: year,
          month: month,
          day: day,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is DateMatch &&
      i == other.i &&
      j == other.j &&
      token == other.token &&
      separator == other.separator &&
      year == other.year &&
      (month < 0 || month == other.month) &&
      (day < 0 || day == other.day);
}

void main() {
  group('Date matching.', () {
    final MatchDate matchDate = MatchDate();

    const List<String> separators = <String>['', ' ', '-', '/', r'\', '_', '.'];
    for (final String separator in separators) {
      test(
        "Matches dates that use '$separator' as a separator.",
        () {
          final String password = '13${separator}2${separator}1921';
          expect(
            matchDate.match(password),
            <List<DateMatchTest>>[
              <DateMatchTest>[
                DateMatchTest(
                  i: 0,
                  j: password.length - 1,
                  token: password,
                  separator: separator,
                  year: 1921,
                  month: 2,
                  day: 13,
                ),
              ],
            ],
          );
        },
      );
    }

    const List<String> formats = <String>['mdy', 'dmy', 'ymd', 'ydm'];
    for (final String format in formats) {
      test(
        "Matches dates with '$format' format.",
        () {
          const int d = 8;
          const int m = 8;
          const int y = 88;
          final String password = format
              .replaceFirst('y', y.toString())
              .replaceFirst('m', m.toString())
              .replaceFirst('d', d.toString());
          expect(
            matchDate.match(password),
            <List<DateMatchTest>>[
              <DateMatchTest>[
                DateMatchTest(
                  i: 0,
                  j: password.length - 1,
                  token: password,
                  separator: '',
                  year: 1988,
                  month: 8,
                  day: 8,
                ),
              ],
            ],
          );
        },
      );
    }

    test(
      'Matches the date with year closest to referenceYear when ambiguous.',
      () {
        const String password = '111504';
        expect(
          matchDate.match(password),
          <List<DateMatchTest>>[
            <DateMatchTest>[
              DateMatchTest(
                i: 0,
                j: password.length - 1,
                token: password,
                separator: '',
                year: 2004,
                month: 11,
                day: 15,
              ),
            ],
          ],
        );
      },
    );

    const List<List<int>> dates = <List<int>>[
      <int>[1, 1, 1999],
      <int>[11, 8, 2000],
      <int>[9, 12, 2005],
      <int>[22, 11, 1551],
    ];
    for (final List<int> dmy in dates) {
      final int day = dmy[0];
      final int month = dmy[1];
      final int year = dmy[2];
      final String password1 = '$year$month$day';
      test(
        'Matches $password1.',
        () => expect(
          matchDate.match(password1),
          <List<DateMatchTest>>[
            <DateMatchTest>[
              DateMatchTest(
                i: 0,
                j: password1.length - 1,
                token: password1,
                separator: '',
                year: year,
              ),
            ],
          ],
        ),
      );
      final String password2 = '$year.$month.$day';
      test(
        'Matches $password2.',
        () => expect(
          matchDate.match(password2),
          <List<DateMatchTest>>[
            <DateMatchTest>[
              DateMatchTest(
                i: 0,
                j: password2.length - 1,
                token: password2,
                separator: '.',
                year: year,
              ),
            ],
          ],
        ),
      );
    }

    test(
      'Matches zero-padded dates.',
      () {
        const String password = '02/02/02';
        expect(
          matchDate.match(password),
          <List<DateMatchTest>>[
            <DateMatchTest>[
              DateMatchTest(
                i: 0,
                j: password.length - 1,
                token: password,
                separator: '/',
                year: 2002,
                month: 2,
                day: 2,
              ),
            ],
          ],
        );
      },
    );

    test(
      'Matches embedded dates.',
      () {
        const List<String> prefixes = <String>['a', 'ab'];
        const List<String> suffixes = <String>['!'];
        const String token = '1/1/91';
        final List<IndexedPassword> passwords =
            generatePasswords(token, prefixes, suffixes);
        for (final IndexedPassword password in passwords) {
          expect(
            matchDate.match(password.password),
            <List<DateMatchTest>>[
              <DateMatchTest>[
                DateMatchTest(
                  i: password.i,
                  j: password.j,
                  token: token,
                  separator: '/',
                  year: 1991,
                  month: 1,
                  day: 1,
                ),
              ],
            ],
          );
        }
      },
    );

    test(
      'Matches overlapping dates.',
      () => expect(
        matchDate.match('12/20/1991.12.20'),
        <List<DateMatchTest>>[
          <DateMatchTest>[
            DateMatchTest(
              i: 0,
              j: 9,
              token: '12/20/1991',
              separator: '/',
              year: 1991,
              month: 12,
              day: 20,
            ),
            DateMatchTest(
              i: 6,
              j: 15,
              token: '1991.12.20',
              separator: '.',
              year: 1991,
              month: 12,
              day: 20,
            ),
          ],
        ],
      ),
    );

    test(
      'Matches dates padded by non-ambiguous digits.',
      () => expect(
        matchDate.match('912/20/919'),
        <List<DateMatchTest>>[
          <DateMatchTest>[
            DateMatchTest(
              i: 1,
              j: 8,
              token: '12/20/91',
              separator: '/',
              year: 1991,
              month: 12,
              day: 20,
            ),
          ],
        ],
      ),
    );
  });
}
