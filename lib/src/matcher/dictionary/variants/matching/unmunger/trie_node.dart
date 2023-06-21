import '../../../../../types.dart';

class TrieNode {
  TrieNode({
    this.l33t = '',
    List<String>? cleanList,
    Map<String, TrieNode>? children,
  })  : cleanList = cleanList ?? <String>[],
        children = children ?? <String, TrieNode>{};

  TrieNode.fromL33tTable(L33tTable l33tTable)
      : l33t = '',
        cleanList = <String>[],
        children = <String, TrieNode>{} {
    l33tTable.forEach((String clean, List<String> l33tList) {
      for (final String l33t in l33tList) {
        addChange(l33t, clean);
      }
    });
  }

  final String l33t;
  final List<String> cleanList;
  final Map<String, TrieNode> children;

  @override
  String toString() => 'l33t: $l33t, cleanList: $cleanList,'
      ' children: $children';

  void addChange(String l33t, String clean) {
    TrieNode current = this;
    final StringBuffer prefix = StringBuffer();
    for (int i = 0; i < l33t.length; i++) {
      final String character = l33t.substring(i, i + 1);
      prefix.write(character);
      current = current.children.putIfAbsent(
        character,
        () => TrieNode(l33t: prefix.toString()),
      );
    }
    current.cleanList.add(clean);
  }
}
