import 'dart:math';

// Binomial coefficients.
// Src: http://blog.plover.com/math/choose.html
int nCk(int n, int k) {
  if (k > n) return 0;
  if (k == 0) return 1;
  double result = 1;
  for (int i = 1; i <= k; i += 1) {
    result *= n--;
    result /= i;
  }
  return result.round();
}

double log10(double n) {
  if (n == 0) return 0;
  return log(n) / ln10;
}

double log2(double n) {
  return log(n) / ln2;
}

int factorial(int n) {
  int result = 1;
  for (int i = 2; i <= n; i += 1) {
    result *= i;
  }
  return result;
}
