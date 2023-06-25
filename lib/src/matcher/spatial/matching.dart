import '../../options.dart';
import '../../types.dart';

/// Spatial match (qwerty/dvorak/keypad and so on).
class MatchSpatial extends MatchingType {
  MatchSpatial(this.options);

  final Options options;

  final RegExp _shiftedRegExp =
      RegExp(r'[~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?]');

  @override
  List<List<SpatialMatch>> match(String password) {
    final List<SpatialMatch> matches = <SpatialMatch>[];
    for (final String graphName in options.graph.keys) {
      final GraphEntry graph = options.graph[graphName]!;
      matches.addAll(_helper(password, graph, graphName));
    }
    return <List<SpatialMatch>>[matches];
  }

  List<SpatialMatch> _helper(
    String password,
    GraphEntry graph,
    String graphName,
  ) {
    int shiftedCount;
    final List<SpatialMatch> matches = <SpatialMatch>[];
    int i = 0;
    final int passwordLength = password.length;
    while (i < passwordLength - 1) {
      int j = i + 1;
      int lastDirection = -1;
      int turns = 0;
      shiftedCount = _shiftedCount(graphName, password, i);
      while (true) {
        final String previousChar = password.substring(j - 1, j);
        final List<String?> adjacents = graph[previousChar] ?? <String?>[];
        bool found = false;
        int currentDirection = -1;
        // Consider growing pattern by one character if j hasn't gone over
        // the edge.
        if (j < passwordLength) {
          final String currentChar = password.substring(j, j + 1);
          final int adjacentsLength = adjacents.length;
          for (int k = 0; k < adjacentsLength; k++) {
            final String? adjacent = adjacents[k];
            currentDirection++;
            if (adjacent == null) continue;
            final int adjacentIndex = adjacent.indexOf(currentChar);
            if (adjacentIndex == -1) continue;
            found = true;
            if (adjacentIndex == 1) {
              // Index 1 in the adjacency means the key is shifted,
              // 0 means unshifted: A vs a, % vs 5, etc.
              // For example, 'q' is adjacent to the entry '2@'.
              // @ is shifted with index 1, 2 is unshifted.
              shiftedCount++;
            }
            if (lastDirection != currentDirection) {
              // Adding a turn is correct even in the initial case when
              // lastDirection is 0:
              // every spatial pattern starts with a turn.
              turns++;
              lastDirection = currentDirection;
            }
            break;
          }
        }
        // If the current pattern continued, extend j and try to grow again.
        if (found) {
          j++;
          // Otherwise push the pattern discovered so far, if any...
        } else {
          // Don't consider length 1 or 2 chains.
          if (j - i > 2) {
            matches.add(
              SpatialMatch(
                i: i,
                j: j - 1,
                token: password.substring(i, j),
                graph: graphName,
                turns: turns,
                shiftedCount: shiftedCount,
              ),
            );
          }
          // ...and then start a new search for the rest of the password.
          i = j;
          break;
        }
      }
    }
    return matches;
  }

  int _shiftedCount(String graphName, String password, int index) {
    if (!graphName.contains('keypad') &&
        // Initial character is shifted
        _shiftedRegExp.hasMatch(password.substring(index, index + 1))) {
      return 1;
    }
    return 0;
  }
}
