import 'dart:async';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/helper.dart';
import 'package:zxcvbnm/src/types.dart';

void main() {
  group('Filter matches.', () {
    final Match match1 = BruteForceMatch(i: 3, j: 5, token: '937');
    final Match match2 = BruteForceMatch(i: 0, j: 1, token: '46');
    final Future<List<Match>> match3 = Future<List<Match>>.value(<Match>[]);
    final Future<List<Match>> match4 = Future<List<Match>>.value(<Match>[]);

    test(
      'Empty matches.',
      () {
        expect(
          synchronousMatches(<FutureOr<List<Match>>>[]),
          <Match>[],
        );
        expect(
          synchronousMatches(<FutureOr<List<Match>>>[<Match>[]]),
          <Match>[],
        );
        expect(
          asynchronousMatches(<FutureOr<List<Match>>>[]),
          <Future<List<Match>>>[],
        );
        expect(
          asynchronousMatches(<FutureOr<List<Match>>>[<Match>[]]),
          <Future<List<Match>>>[],
        );
      },
    );

    test(
      'Ignores other type.',
      () {
        expect(
          synchronousMatches(<FutureOr<List<Match>>>[match3]),
          <Match>[],
        );
        expect(
          synchronousMatches(<FutureOr<List<Match>>>[<Match>[], match3]),
          <Match>[],
        );
        expect(
          asynchronousMatches(<FutureOr<List<Match>>>[
            <Match>[match1],
            <Match>[match2],
          ]),
          <Future<List<Match>>>[],
        );
      },
    );

    test(
      'Returns right type.',
      () {
        expect(
          synchronousMatches(<FutureOr<List<Match>>>[
            <Match>[match1, match2],
            match3,
            match4,
          ]),
          <Match>[match1, match2],
        );
        expect(
          synchronousMatches(<FutureOr<List<Match>>>[
            match3,
            <Match>[match1],
            match4,
            <Match>[match2],
          ]),
          <Match>[match1, match2],
        );
        expect(
          asynchronousMatches(<FutureOr<List<Match>>>[
            <Match>[match1, match2],
            match3,
            match4,
          ]),
          <Future<List<Match>>>[match3, match4],
        );
        expect(
          asynchronousMatches(<FutureOr<List<Match>>>[
            <Match>[match1],
            match3,
            <Match>[match2],
            match4,
          ]),
          <Future<List<Match>>>[match3, match4],
        );
      },
    );
  });
}
