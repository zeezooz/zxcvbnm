import 'dart:collection';

import '../../../../../types.dart';
import 'trie_node.dart';

List<PasswordWithChanges> cleanPassword(
  String string,
  int limit,
  TrieNode trieRoot,
) {
  final List<PasswordWithChanges> result = <PasswordWithChanges>[];
  for (final bool allChanges in <bool>[true, false]) {
    final Queue<QueueItem> queue = Queue<QueueItem>()
      ..add(
        QueueItem(
          string: string,
          index: 0,
          clean: '',
          changes: <IndexedPasswordChange>[],
          allChanges: true,
          trieRoot: trieRoot,
        ),
      );
    while (queue.isNotEmpty) {
      final QueueItem item = queue.removeLast();
      if (item.nextChanges.isNotEmpty) {
        if (!allChanges) {
          final String character = string.substring(item.index, item.index + 1);
          queue.add(
            QueueItem(
              string: string,
              index: item.index + 1,
              clean: item.clean + character,
              changes: item.changes,
              allChanges: false,
              trieRoot: trieRoot,
            ),
          );
        }
        queue.addAll(<QueueItem>[
          for (final IndexedPasswordChange change in item.nextChanges.reversed)
            QueueItem(
              string: string,
              index: item.index + change.l33t.length,
              clean: item.clean + change.clean,
              changes: <IndexedPasswordChange>[...item.changes, change],
              allChanges: item.allChanges,
              trieRoot: trieRoot,
            ),
        ]);
      } else if (item.index >= string.length && allChanges == item.allChanges) {
        result.add(
          PasswordWithChanges(
            password: item.clean,
            changes: item.changes,
          ),
        );
        if (result.length >= limit) return result;
      }
    }
  }
  return result;
}

class PasswordWithChanges {
  const PasswordWithChanges({
    required this.password,
    required this.changes,
  });

  final String password;
  final List<IndexedPasswordChange> changes;

  @override
  String toString() => '"$password" (${changes.join(', ')})';
}

class IndexedPasswordChange extends PasswordChange {
  const IndexedPasswordChange({
    required String l33t,
    required String clean,
    required this.i,
  }) : super(l33t: l33t, clean: clean);

  final int i;

  @override
  String toString() => '$l33t -> $clean [$i]';
}

class QueueItem {
  QueueItem({
    required this.string,
    required int index,
    required String clean,
    required this.changes,
    required this.allChanges,
    required this.trieRoot,
  })  : _clean = clean,
        _index = index {
    do {
      final List<TrieNode> nodes = <TrieNode>[];
      TrieNode? current = trieRoot;
      for (int i = _index; i < string.length; i += 1) {
        final String character = string.substring(i, i + 1);
        current = current?.children[character];
        if (current == null) break;
        nodes.add(current);
      }
      // Iterate backward to get wider substitutions first.
      for (int i = _index + nodes.length - 1; i >= _index; i -= 1) {
        current = nodes[i - _index];
        for (final String clean in current.cleanList) {
          nextChanges.add(
            IndexedPasswordChange(
              l33t: current.l33t,
              clean: clean,
              i: _clean.length,
            ),
          );
        }
      }
      if (nextChanges.isEmpty && _index < string.length) {
        final String character = string.substring(_index, _index + 1);
        _index++;
        _clean += character;
      }
    } while (nextChanges.isEmpty && _index < string.length);
  }

  final String string;
  int _index;
  int get index => _index;
  String _clean;
  String get clean => _clean;
  final List<IndexedPasswordChange> changes;
  final bool allChanges;
  final TrieNode trieRoot;
  final List<IndexedPasswordChange> nextChanges = <IndexedPasswordChange>[];
}
