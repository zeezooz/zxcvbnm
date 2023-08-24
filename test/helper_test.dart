import 'dart:async';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/helper.dart';
import 'package:zxcvbnm/src/matchers/base_matcher.dart';
import 'package:zxcvbnm/src/matchers/brute_force_matcher.dart';

void main() {
  group('Filter matches.', () {
    final BaseMatch match1 = BruteForceMatch(
      password: '393937',
      start: 3,
      end: 6,
    );
    final BaseMatch match2 = BruteForceMatch(
      password: '46',
      start: 0,
      end: 2,
    );
    final Future<List<BaseMatch>> match3 =
        Future<List<BaseMatch>>.value(<BaseMatch>[]);
    final Future<List<BaseMatch>> match4 =
        Future<List<BaseMatch>>.value(<BaseMatch>[]);

    test(
      'Empty matches.',
      () {
        expect(
          synchronousMatches(<FutureOr<List<BaseMatch>>>[]),
          <BaseMatch>[],
        );
        expect(
          synchronousMatches(<FutureOr<List<BaseMatch>>>[<BaseMatch>[]]),
          <BaseMatch>[],
        );
        expect(
          asynchronousMatches(<FutureOr<List<BaseMatch>>>[]),
          <Future<List<BaseMatch>>>[],
        );
        expect(
          asynchronousMatches(<FutureOr<List<BaseMatch>>>[<BaseMatch>[]]),
          <Future<List<BaseMatch>>>[],
        );
      },
    );

    test(
      'Ignores other type.',
      () {
        expect(
          synchronousMatches(<FutureOr<List<BaseMatch>>>[match3]),
          <BaseMatch>[],
        );
        expect(
          synchronousMatches(
            <FutureOr<List<BaseMatch>>>[<BaseMatch>[], match3],
          ),
          <BaseMatch>[],
        );
        expect(
          asynchronousMatches(<FutureOr<List<BaseMatch>>>[
            <BaseMatch>[match1],
            <BaseMatch>[match2],
          ]),
          <Future<List<BaseMatch>>>[],
        );
      },
    );

    test(
      'Returns right type.',
      () {
        expect(
          synchronousMatches(<FutureOr<List<BaseMatch>>>[
            <BaseMatch>[match1, match2],
            match3,
            match4,
          ]),
          <BaseMatch>[match1, match2],
        );
        expect(
          synchronousMatches(<FutureOr<List<BaseMatch>>>[
            match3,
            <BaseMatch>[match1],
            match4,
            <BaseMatch>[match2],
          ]),
          <BaseMatch>[match1, match2],
        );
        expect(
          asynchronousMatches(<FutureOr<List<BaseMatch>>>[
            <BaseMatch>[match1, match2],
            match3,
            match4,
          ]),
          <Future<List<BaseMatch>>>[match3, match4],
        );
        expect(
          asynchronousMatches(<FutureOr<List<BaseMatch>>>[
            <BaseMatch>[match1],
            match3,
            <BaseMatch>[match2],
            match4,
          ]),
          <Future<List<BaseMatch>>>[match3, match4],
        );
      },
    );
  });
}
