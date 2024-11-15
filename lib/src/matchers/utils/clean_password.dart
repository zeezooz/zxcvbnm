import 'dart:collection';

import '../l33t_matcher.dart';
import 'trie_node.dart';

/// Returns up to [limit] variants of the [password] with replacements
/// from the [trieRoot].
List<PasswordWithChanges> cleanPassword(
  String password,
  int limit,
  TrieNode trieRoot,
) {
  final List<PasswordWithChanges> result = <PasswordWithChanges>[];
  for (final bool allChanges in <bool>[true, false]) {
    final Queue<_QueueItem> queue = Queue<_QueueItem>()
      ..add(
        _QueueItem(
          password: password,
          index: 0,
          clean: '',
          changes: <IndexedPasswordChange>[],
          lastL33t: '',
          lastL33tCount: 0,
          allChanges: true,
          trieRoot: trieRoot,
        ),
      );
    while (queue.isNotEmpty) {
      final _QueueItem item = queue.removeLast();
      if (item.nextChanges.isNotEmpty) {
        if (!allChanges) {
          final String character =
              password.substring(item.index, item.index + 1);
          queue.add(
            _QueueItem(
              password: password,
              index: item.index + 1,
              clean: item.clean + character,
              changes: item.changes,
              lastL33t: item.lastL33t,
              lastL33tCount: item.lastL33tCount,
              allChanges: false,
              trieRoot: trieRoot,
            ),
          );
        }
        queue.addAll(<_QueueItem>[
          for (final IndexedPasswordChange change in item.nextChanges.reversed)
            _QueueItem(
              password: password,
              index: item.index + change.l33t.length,
              clean: item.clean + change.clean,
              changes: <IndexedPasswordChange>[...item.changes, change],
              lastL33t: change.l33t,
              lastL33tCount:
                  item.lastL33t == change.l33t ? item.lastL33tCount + 1 : 1,
              allChanges: item.allChanges,
              trieRoot: trieRoot,
            ),
        ]);
      } else if (item.index >= password.length &&
          allChanges == item.allChanges) {
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

/// A changed password and replacements made.
class PasswordWithChanges {
  /// Creates a new instance.
  const PasswordWithChanges({
    required this.password,
    required this.changes,
  });

  /// The password with [changes].
  final String password;

  /// The replacements made.
  final List<IndexedPasswordChange> changes;

  @override
  String toString() => '"$password" (${changes.join(', ')})';
}

/// A replacement in a password with [start] index.
class IndexedPasswordChange extends PasswordChange {
  /// Creates a new instance.
  const IndexedPasswordChange({
    required String l33t,
    required String clean,
    required this.start,
  }) : super(l33t: l33t, clean: clean);

  /// The index of a password were the replacement was made.
  final int start;

  @override
  String toString() => '$l33t -> $clean [$start]';
}

class _QueueItem {
  _QueueItem({
    required this.password,
    required int index,
    required String clean,
    required this.changes,
    required this.lastL33t,
    required this.lastL33tCount,
    required this.allChanges,
    required this.trieRoot,
  })  : _clean = clean,
        _index = index {
    do {
      final List<TrieNode> nodes = <TrieNode>[];
      TrieNode? current = trieRoot;
      for (int i = _index; i < password.length; i++) {
        final String character = password.substring(i, i + 1);
        current = current?.children[character];
        if (current == null) break;
        nodes.add(current);
      }
      // Iterate backward to get wider substitutions first.
      for (int i = _index + nodes.length - 1; i >= _index; i--) {
        current = nodes[i - _index];
        // Skip if this would be a 4th or more consecutive substitution of
        // the same letter. This should work in all language as there
        // shouldn't be the same letter more than four times in a row.
        // So we can ignore the rest to save calculation time.
        if (lastL33t == current.l33t && lastL33tCount >= 3) continue;
        for (final String clean in current.cleanList) {
          nextChanges.add(
            IndexedPasswordChange(
              l33t: current.l33t,
              clean: clean,
              start: _clean.length,
            ),
          );
        }
      }
      if (nextChanges.isEmpty && _index < password.length) {
        final String character = password.substring(_index, _index + 1);
        _index++;
        _clean += character;
      }
    } while (nextChanges.isEmpty && _index < password.length);
  }

  final String password;
  int _index;
  int get index => _index;
  String _clean;
  String get clean => _clean;
  final List<IndexedPasswordChange> changes;
  final String lastL33t;
  final int lastL33tCount;
  final bool allChanges;
  final TrieNode trieRoot;
  final List<IndexedPasswordChange> nextChanges = <IndexedPasswordChange>[];
}
