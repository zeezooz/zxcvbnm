import 'dart:math';

/// Returns the logarithm with base 10 of [n].
double log10(num n) {
  if (n == 0) return 0;
  return log(n) / ln10;
}

/// Returns the factorial of [n].
int factorial(int n) {
  int result = 1;
  for (int i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}
