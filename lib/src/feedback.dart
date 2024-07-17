import 'matchers/base_matcher.dart';
import 'translation.dart';

class Feedback {
  const Feedback({
    this.warning,
    List<String>? suggestions,
  }) : suggestions = suggestions ?? const <String>[];

  Feedback._default()
      : this(
          suggestions: <String>[
            Translation.suggestions.useWords,
            Translation.suggestions.noNeed,
          ],
        );

  factory Feedback.fromMatches(
    int score,
    List<BaseMatch> matches,
  ) {
    if (matches.isEmpty) return Feedback._default();
    if (score > 2) return const Feedback();
    final String extraFeedback = Translation.suggestions.anotherWord;
    Feedback? feedback =
        _longestMatch(matches).feedback(isSoleMatch: matches.length == 1);
    if (feedback != null) {
      feedback = Feedback(
        warning: feedback.warning,
        suggestions: <String>[extraFeedback, ...feedback.suggestions],
      );
    } else {
      feedback = Feedback(suggestions: <String>[extraFeedback]);
    }
    return feedback;
  }

  final String? warning;
  final List<String> suggestions;

  @override
  String toString() => '$warning, $suggestions';

  static BaseMatch _longestMatch(List<BaseMatch> sequence) {
    BaseMatch longestMatch = sequence[0];
    for (final BaseMatch match in sequence.skip(1)) {
      if (match.length > longestMatch.length) {
        longestMatch = match;
      }
    }
    return longestMatch;
  }
}
