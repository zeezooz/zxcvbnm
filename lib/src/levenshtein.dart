import 'package:algorithmic/string_metrics.dart' show levenshteinDistanceOf;

import 'types.dart';

LevenshteinDistance? levenshteinDistance(
  String password,
  RankedDictionary rankedDictionary,
  int threshold,
) {
  for (final String entry in rankedDictionary.keys) {
    // If password is too small use the password length divided by 4 while
    // the threshold needs to be at least 1.
    final int usedThreshold =
        password.length <= entry.length || password.length <= threshold
            ? (password.length / 4).ceil()
            : threshold;
    if ((password.length - entry.length).abs() > usedThreshold) continue;
    final int distance = levenshteinDistanceOf(password, entry);
    if (distance <= usedThreshold) {
      return LevenshteinDistance(
        distance: distance,
        entry: entry,
      );
    }
  }
  return null;
}

class LevenshteinDistance {
  const LevenshteinDistance({
    required this.distance,
    required this.entry,
  });

  final int distance;
  final String entry;
}
