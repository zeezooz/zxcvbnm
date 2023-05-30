import 'dart:math';

import '../../data/const.dart';
import '../../types.dart';

double dateScoring(DateMatch match) {
  final int year = match.year;
  final String separator = match.separator;
  // Base guesses: (year distance from referenceYear) * num_days * num_years.
  final int yearSpace = max((year - referenceYear).abs(), minYearSpace);
  double guesses = yearSpace * 365;
  // Add factor of 4 for separator selection (one of ~4 choices).
  if (separator.isNotEmpty) guesses *= 4;
  return guesses;
}
