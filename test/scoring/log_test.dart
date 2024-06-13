import 'dart:math';

import 'package:test/test.dart';
import 'package:zxcvbnm/src/scoring/utils.dart';

void main() {
  group('Scoring utils: log.', () {
    test(
      'log10 should calculate correctly.',
      () {
        const List<List<double>> data = <List<double>>[
          <double>[1, 0],
          <double>[10, 1],
          <double>[100, 2],
        ];
        for (final List<double> item in data) {
          expect(
            log10(item[0]),
            item[1],
          );
        }
      },
    );

    const int firstNumber = 17;
    const int secondNumber = 4;
    const double epsilon = 1e-10;

    test(
      'Product rule.',
      () => expect(
        log10(firstNumber * secondNumber),
        closeTo(log10(firstNumber) + log10(secondNumber), epsilon),
      ),
    );

    test(
      'Quotient rule.',
      () => expect(
        log10(firstNumber / secondNumber),
        closeTo(log10(firstNumber) - log10(secondNumber), epsilon),
      ),
    );

    test(
      'Base switch rule.',
      () => expect(
        log10(e),
        closeTo(1 / log(10), epsilon),
      ),
    );

    test(
      'Power rule.',
      () => expect(
        log10(pow(firstNumber, secondNumber)),
        closeTo(secondNumber * log10(firstNumber), epsilon),
      ),
    );

    test(
      'Base rule.',
      () => expect(
        log10(firstNumber),
        closeTo(log(firstNumber) / log(10), epsilon),
      ),
    );
  });
}
