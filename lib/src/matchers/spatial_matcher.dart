import 'dart:math';

import '../feedback.dart';
import '../options.dart';
import '../translation.dart';
import '../types.dart';
import 'base_matcher.dart';
import 'utils/nck.dart';

/// Matches spatial sequences (qwerty/dvorak/keypad and so on).
class SpatialMatcher extends BaseMatcher {
  /// Creates a matcher.
  SpatialMatcher(this.options);

  /// Options.
  final Options options;

  @override
  List<List<SpatialMatch>> match(String password) {
    final List<SpatialMatch> matches = <SpatialMatch>[];
    options.graph.forEach((String graphName, GraphEntry graph) {
      matches.addAll(_matchGraph(password, graph, graphName));
    });
    return <List<SpatialMatch>>[matches];
  }

  List<SpatialMatch> _matchGraph(
    String password,
    GraphEntry graph,
    String graphName,
  ) {
    final List<SpatialMatch> matches = <SpatialMatch>[];
    int start = 0;
    while (start < password.length - 1) {
      int end = start + 1;
      int lastDirection = -1;
      int turns = 0;
      int shiftedCount;
      if (!graphName.contains('keypad') &&
          // Initial character is shifted
          _shiftedRegExp.hasMatch(password.substring(start, start + 1))) {
        shiftedCount = 1;
      } else {
        shiftedCount = 0;
      }
      while (true) {
        final String previousChar = password.substring(end - 1, end);
        final List<String?> adjacents = graph[previousChar] ?? <String?>[];
        bool found = false;
        int currentDirection = -1;
        // Consider growing pattern by one character if end hasn't gone over
        // the edge.
        if (end < password.length) {
          final String currentChar = password.substring(end, end + 1);
          for (final String? adjacent in adjacents) {
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
              // lastDirection is 0: every spatial pattern starts with a turn.
              turns++;
              lastDirection = currentDirection;
            }
            break;
          }
        }
        if (found) {
          // If the current pattern continued, extend end and try to grow again.
          end++;
        } else {
          // Otherwise push the pattern discovered so far, if any...
          // Don't consider length 1 or 2 chains.
          if (end - start > 2) {
            matches.add(
              SpatialMatch(
                password: password,
                start: start,
                end: end,
                graph: graph,
                graphName: graphName,
                turns: turns,
                shiftedCount: shiftedCount,
              ),
            );
          }
          // ...and then start a new search for the rest of the password.
          start = end;
          break;
        }
      }
    }
    return matches;
  }

  final RegExp _shiftedRegExp =
      RegExp(r'[~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?]');
}

/// A match for a spatial sequence.
class SpatialMatch extends BaseMatch {
  /// Creates a match.
  SpatialMatch({
    required String password,
    required int start,
    required int end,
    required this.graph,
    required this.graphName,
    required this.turns,
    required this.shiftedCount,
  }) : super(password: password, start: start, end: end);

  /// The matched adjacency graph.
  final GraphEntry graph;

  /// The name of the matched adjacency [graph].
  final String graphName;

  /// The number of direction changes.
  final int turns;

  /// The number of characters when using the Shift key.
  final int shiftedCount;

  @override
  double get estimatedGuesses {
    double guesses = 0;
    double averageDegree = 0;
    for (final List<String?> neighbors in graph.values) {
      averageDegree += neighbors.where((String? entry) => entry != null).length;
    }
    averageDegree /= graph.keys.length;
    // Estimate the number of possible patterns with token length or less with
    // turns or less.
    for (int i = 1; i < length; i++) {
      final int possibleTurns = min(turns, i);
      for (int j = 0; j < possibleTurns; j++) {
        guesses += nCk(i, j) * graph.keys.length * pow(averageDegree, j + 1);
      }
    }
    // Add extra guesses for shifted keys (% instead of 5, A instead of a).
    // Math is similar to extra guesses of l33t substitutions in dictionary
    // matches.
    if (shiftedCount > 0) {
      final int unShiftedCount = length - shiftedCount;
      if (unShiftedCount == 0) {
        guesses *= 2;
      } else {
        double shiftedVariations = 0;
        for (int i = 1; i <= min(shiftedCount, unShiftedCount); i++) {
          shiftedVariations += nCk(shiftedCount + unShiftedCount, i);
        }
        guesses *= shiftedVariations;
      }
    }
    return guesses.roundToDouble();
  }

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return Feedback(
      warning: turns == 1
          ? Translation.warnings.straightRow
          : Translation.warnings.keyPattern,
      suggestions: <String>[
        Translation.suggestions.longerKeyboardPattern,
      ],
    );
  }

  @override
  String toString() => '${super.toString()}, graphName: "$graphName", '
      'turns: $turns, shiftedCount: $shiftedCount';
}
