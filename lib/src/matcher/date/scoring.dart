import 'dart:math';

import '../../data/const.dart';
import '../../types.dart';

double dateScoring(DateMatch match) {
  // Base guesses: (year distance from referenceYear) * num_days * num_years.
  final int yearSpace = max((match.year - referenceYear).abs(), minYearSpace);
  double guesses = yearSpace * 365;
  // Add factor of 4 for separator selection (one of ~4 choices).
  if (match.separator.isNotEmpty) guesses *= 4;
  return guesses;
}
