import '../../data/const.dart';
import '../../types.dart';

/// Separators (any semi-repeated special character).
class MatchSeparator extends MatchingType {
  final RegExp _separatorRegex = RegExp('[${separatorChars.join('')}]');

  @override
  List<SeparatorMatch> match(String password) {
    final List<SeparatorMatch> result = <SeparatorMatch>[];
    if (password.isEmpty) return result;
    final String? mostUsedSeparator = _mostUsedSeparator(password);
    if (mostUsedSeparator == null) return result;
    final RegExp usedSeparatorRegex = _usedSeparatorRegex(mostUsedSeparator);
    for (final RegExpMatch match in usedSeparatorRegex.allMatches(password)) {
      // Add one to the index because we changed the regex from negative
      // lookbehind to something simple. This simple approach uses the first
      // character before the separator too but we only need the index of the
      // separator.
      // https://github.com/zxcvbn-ts/zxcvbn/issues/202
      final int i = match.start + 1;
      result.add(SeparatorMatch(i: i, j: i, token: mostUsedSeparator));
    }
    return result;
  }

  String? _mostUsedSeparator(String password) {
    final List<MapEntry<String, int>> mostUsedSeparators = password
        .split('')
        .where(_separatorRegex.hasMatch)
        .fold(<String, int>{}, (Map<String, int> counts, String separator) {
          counts[separator] = (counts[separator] ?? 0) + 1;
          return counts;
        })
        .entries
        .toList()
      ..sort(
        (MapEntry<String, int> a, MapEntry<String, int> b) =>
            b.value.compareTo(a.value),
      );
    if (mostUsedSeparators.isEmpty) return null;
    final MapEntry<String, int> match = mostUsedSeparators[0];
    // If the special character is only used once, don't treat it like
    // a separator.
    if (match.value < 2) return null;
    return match.key;
  }

  RegExp _usedSeparatorRegex(String separator) {
    return RegExp('([^$separator\n])($separator)(?!$separator)');
    // Negative lookbehind can be added again in a few years when it is more
    // supported by the browsers (currently 2023).
    // https://github.com/zxcvbn-ts/zxcvbn/issues/202
    // return RegExp('(?<!$separator)($separator)(?!$separator)');
  }
}
