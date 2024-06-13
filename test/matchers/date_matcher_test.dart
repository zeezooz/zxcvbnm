import 'package:test/test.dart';
import 'package:zxcvbnm/src/matchers/date_matcher.dart';
import 'package:zxcvbnm/src/options.dart';

import '../helper/generate_passwords.dart';

void main() {
  group('DateMatcher.', () {
    final Options options = Options();
    final DateMatcher matchDate = DateMatcher(options);

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
                  password: password,
                  start: 0,
                  end: password.length,
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
                  password: password,
                  start: 0,
                  end: password.length,
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
      'Matches the date with year closest to currentYear when ambiguous.',
      () {
        const String password = '111504';
        expect(
          matchDate.match(password),
          <List<DateMatchTest>>[
            <DateMatchTest>[
              DateMatchTest(
                password: password,
                start: 0,
                end: password.length,
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
                password: password1,
                start: 0,
                end: password1.length,
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
                password: password2,
                start: 0,
                end: password2.length,
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
                password: password,
                start: 0,
                end: password.length,
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
                  password: password.password,
                  start: password.start,
                  end: password.end,
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
      () {
        const String password = '12/20/1991.12.20';
        expect(
          matchDate.match(password),
          <List<DateMatchTest>>[
            <DateMatchTest>[
              DateMatchTest(
                password: password,
                start: 0,
                end: 10,
                separator: '/',
                year: 1991,
                month: 12,
                day: 20,
              ),
              DateMatchTest(
                password: password,
                start: 6,
                end: 16,
                separator: '.',
                year: 1991,
                month: 12,
                day: 20,
              ),
            ],
          ],
        );
      },
    );

    test(
      'Matches dates padded by non-ambiguous digits.',
      () {
        const String password = '912/20/919';
        expect(
          matchDate.match(password),
          <List<DateMatchTest>>[
            <DateMatchTest>[
              DateMatchTest(
                password: password,
                start: 1,
                end: 9,
                separator: '/',
                year: 1991,
                month: 12,
                day: 20,
              ),
            ],
          ],
        );
      },
    );
  });

  group('DateMatch guesses.', () {
    final Options options = Options();

    test(
      'Guesses for 1123.',
      () {
        final DateMatch match = DateMatch(
          password: '1123',
          start: 0,
          end: 4,
          separator: '',
          year: 1923,
          month: 1,
          day: 1,
          options: options,
        );
        expect(
          match.estimatedGuesses,
          365 * (options.currentYear - match.year).abs(),
        );
      },
    );

    test(
      'Recent years assume minYearSpace. Extra guesses are added for '
      'separators.',
      () {
        final DateMatch match = DateMatch(
          password: '1/1/2020',
          start: 0,
          end: 8,
          separator: '/',
          year: 2020,
          month: 1,
          day: 1,
          options: options,
        );
        expect(
          match.estimatedGuesses,
          365 * options.minYearSpace * 4,
        );
      },
    );
  });
}

class DateMatchTest extends DateMatch {
  DateMatchTest({
    required String password,
    required int start,
    required int end,
    required String separator,
    required int year,
    int month = -1,
    int day = -1,
    double? guesses,
    Options? options,
  })  : guessesTest = guesses,
        super(
          password: password,
          start: start,
          end: end,
          separator: separator,
          year: year,
          month: month,
          day: day,
          options: options ?? Options(),
        );

  final double? guessesTest;

  @override
  double get guesses => guessesTest ?? super.guesses;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is DateMatch &&
      password == other.password &&
      start == other.start &&
      end == other.end &&
      separator == other.separator &&
      year == other.year &&
      (month < 0 || month == other.month) &&
      (day < 0 || day == other.day) &&
      (guessesTest == null || guessesTest == other.guesses);
}
