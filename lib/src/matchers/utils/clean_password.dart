import 'dart:collection';

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

/// A replacement in a password.
class PasswordChange {
  /// Creates a new instance.
  const PasswordChange({
    required this.l33t,
    required this.clean,
  });

  /// The original string.
  final String l33t;

  /// The replaced string.
  final String clean;

  @override
  String toString() => '$l33t -> $clean';
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
  final bool allChanges;
  final TrieNode trieRoot;
  final List<IndexedPasswordChange> nextChanges = <IndexedPasswordChange>[];
}
