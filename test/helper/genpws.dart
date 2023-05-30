List<List<Object>> genpws(
  String pattern,
  List<String> prefixes,
  List<String> suffixes,
) {
  final List<List<Object>> result = <List<Object>>[];
  final List<String> slicedPrefixes = prefixes.toList();
  final List<String> slicedSuffixes = suffixes.toList();
  final List<List<String>> combined = <List<String>>[
    slicedPrefixes,
    slicedSuffixes,
  ];
  for (final List<String> lst in combined) {
    if (!lst.contains('')) lst.insert(0, '');
  }
  for (final String prefix in slicedPrefixes) {
    for (final String suffix in slicedSuffixes) {
      final int i = prefix.length;
      final int j = prefix.length + pattern.length - 1;
      result.add(<Object>[prefix + pattern + suffix, i, j]);
    }
  }
  return result;
}
