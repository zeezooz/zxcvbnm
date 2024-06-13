import 'package:test/test.dart';
import 'package:zxcvbnm/src/matchers/utils/nck.dart';

void main() {
  group('nCk.', () {
    test('Should calculate correctly.', () {
      const List<List<int>> data = <List<int>>[
        <int>[0, 0, 1],
        <int>[1, 0, 1],
        <int>[5, 0, 1],
        <int>[0, 1, 0],
        <int>[0, 5, 0],
        <int>[2, 1, 2],
        <int>[4, 2, 6],
        <int>[33, 7, 4272048],
      ];
      for (final List<int> item in data) {
        expect(
          nCk(item[0], item[1]),
          item[2],
        );
      }
    });

    test('Should mirror identity.', () {
      const int n = 49;
      const int k = 12;
      expect(
        nCk(n, k),
        nCk(n, n - k),
      );
    });

    test("Should pascal's triangle identity.", () {
      const int n = 49;
      const int k = 12;
      expect(
        nCk(n, k),
        nCk(n - 1, k - 1) + nCk(n - 1, k),
      );
    });
  });
}
