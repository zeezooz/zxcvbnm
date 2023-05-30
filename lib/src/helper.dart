import 'types.dart';

/// Sort on i primary, j secondary.
void sort(List<Match> matches) {
  matches.sort((Match m1, Match m2) {
    int result = m1.i - m2.i;
    if (result == 0) result = m1.j - m2.j;
    return result;
  });
}
