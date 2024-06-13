import '../../options.dart';

/// A tree of possible string replacements.
class TrieNode {
  /// Creates a tree node.
  TrieNode({
    this.l33t = '',
    List<String>? cleanList,
    Map<String, TrieNode>? children,
  })  : cleanList = cleanList ?? <String>[],
        children = children ?? <String, TrieNode>{};

  /// Creates a tree from the [l33tTable].
  TrieNode.fromL33tTable(L33tTable l33tTable)
      : l33t = '',
        cleanList = <String>[],
        children = <String, TrieNode>{} {
    l33tTable.forEach((String clean, List<String> l33tList) {
      for (final String l33t in l33tList) {
        _addChange(l33t, clean);
      }
    });
  }

  /// The string to replace.
  final String l33t;

  /// The list of replacements.
  final List<String> cleanList;

  /// The replacements for strings starting with [l33t].
  final Map<String, TrieNode> children;

  void _addChange(String l33t, String clean) {
    TrieNode current = this;
    final StringBuffer prefix = StringBuffer();
    for (final String character in l33t.split('')) {
      prefix.write(character);
      current = current.children.putIfAbsent(
        character,
        () => TrieNode(l33t: prefix.toString()),
      );
    }
    current.cleanList.add(clean);
  }

  @override
  String toString() => 'l33t: $l33t, cleanList: $cleanList,'
      ' children: $children';
}
