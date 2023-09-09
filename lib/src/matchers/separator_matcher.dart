import '../feedback.dart';
import 'base_matcher.dart';

/// Matches separators (any semi-repeated special character).
class SeparatorMatcher extends BaseMatcher {
  @override
  List<List<SeparatorMatch>> match(String password) {
    final List<SeparatorMatch> result = <SeparatorMatch>[];
    final List<MapEntry<String, int>> mostUsedSeparators = password
        .split('')
        .where(separators.contains)
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
    // If the special character is only used once, don't treat it like
    // a separator.
    if (mostUsedSeparators.isEmpty || mostUsedSeparators[0].value < 2) {
      return <List<SeparatorMatch>>[result];
    }
    final String separator = mostUsedSeparators[0].key;
    final RegExp separatorRegExp =
        RegExp('([^$separator\n])($separator)(?!$separator)');
    for (final RegExpMatch match in separatorRegExp.allMatches(password)) {
      // Add one to the index because we changed the regex from negative
      // lookbehind to something simple. This simple approach uses the first
      // character before the separator too but we only need the index of the
      // separator.
      // https://github.com/zxcvbn-ts/zxcvbn/issues/202
      final int start = match.start + 1;
      result.add(
        SeparatorMatch(
          password: password,
          start: start,
          end: start + 1,
        ),
      );
    }
    return <List<SeparatorMatch>>[result];
  }

  /// Separators to match.
  static const Set<String> separators = <String>{
    ' ',
    ',',
    ';',
    ':',
    '|',
    '/',
    r'\',
    '_',
    '.',
    '-',
  };
}

/// A match for a separator.
class SeparatorMatch extends BaseMatch {
  /// Creates a match.
  SeparatorMatch({
    required String password,
    required int start,
    required int end,
  }) : super(password: password, start: start, end: end);

  @override
  double get estimatedGuesses => SeparatorMatcher.separators.length.toDouble();

  @override
  Feedback? feedback({required bool isSoleMatch}) => null;
}
