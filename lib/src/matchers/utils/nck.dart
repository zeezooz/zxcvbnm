/// Binomial coefficients.
/// Src: http://blog.plover.com/math/choose.html
double nCk(int n, int k) {
  if (k > n) return 0;
  if (k == 0) return 1;
  int count = n;
  double result = 1;
  for (int i = 1; i <= k; i++) {
    result *= count--;
    result /= i;
  }
  return result;
}
