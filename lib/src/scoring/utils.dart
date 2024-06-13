import 'dart:math';

double log10(num n) {
  if (n == 0) return 0;
  return log(n) / ln10;
}

int factorial(int n) {
  int result = 1;
  for (int i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}
