import 'package:algorithmic/string_metrics.dart' show levenshteinDistanceOf;

/// Returns the first entry from the [entries] whose Levenshtein distance
/// from the [password] is less than the [threshold].
LevenshteinDistance? levenshteinDistance(
  String password,
  Iterable<String> entries,
  int threshold,
) {
  for (final String entry in entries) {
    // If password is too small use the password length divided by 4 while
    // the threshold needs to be at least 1.
    final int usedThreshold =
        password.length <= entry.length || password.length <= threshold
            ? (password.length / 4).ceil()
            : threshold;
    if ((password.length - entry.length).abs() > usedThreshold) continue;
    final int distance = levenshteinDistanceOf(password, entry);
    if (distance <= usedThreshold) {
      return LevenshteinDistance(distance: distance, entry: entry);
    }
  }
  return null;
}

/// A Levenshtein distance and the corresponding entry.
class LevenshteinDistance {
  /// Creates a new instance.
  const LevenshteinDistance({
    required this.distance,
    required this.entry,
  });

  /// The Levenshtein distance.
  final int distance;

  /// The matched string.
  final String entry;
}
