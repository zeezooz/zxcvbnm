List<IndexedPassword> generatePasswords(
  String token,
  List<String> prefixes,
  List<String> suffixes,
) {
  final List<IndexedPassword> result = <IndexedPassword>[];
  final List<String> prefixesCopy = prefixes.toList();
  if (!prefixesCopy.contains('')) prefixesCopy.insert(0, '');
  final List<String> suffixesCopy = suffixes.toList();
  if (!suffixesCopy.contains('')) suffixesCopy.insert(0, '');
  for (final String prefix in prefixesCopy) {
    for (final String suffix in suffixesCopy) {
      result.add(
        IndexedPassword(
          password: prefix + token + suffix,
          start: prefix.length,
          end: prefix.length + token.length,
        ),
      );
    }
  }
  return result;
}

class IndexedPassword {
  const IndexedPassword({
    required this.password,
    required this.start,
    required this.end,
  });

  final String password;
  final int start;
  final int end;
}
