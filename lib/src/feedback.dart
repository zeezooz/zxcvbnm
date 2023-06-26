import 'options.dart';
import 'types.dart';

class Feedback {
  const Feedback({
    this.warning,
    List<String>? suggestions,
  }) : suggestions = suggestions ?? const <String>[];

  Feedback._default(Options options)
      : this(
          suggestions: <String>[
            options.translation.suggestions.useWords,
            options.translation.suggestions.noNeed,
          ],
        );

  factory Feedback.fromMatches(
    int score,
    List<MatchEstimated> matches,
    Options options,
  ) {
    if (matches.isEmpty) return Feedback._default(options);
    if (score > 2) return Feedback();
    final String extraFeedback = options.translation.suggestions.anotherWord;
    Feedback? feedback = _longestMatch(matches)
        .feedback(options, isSoleMatch: matches.length == 1);
    if (feedback != null) {
      feedback.suggestions.insert(0, extraFeedback);
    } else {
      feedback = Feedback(suggestions: <String>[extraFeedback]);
    }
    return feedback;
  }

  final String? warning;
  final List<String> suggestions;

  @override
  String toString() => '$warning $suggestions';

  static MatchEstimated _longestMatch(List<MatchEstimated> sequence) {
    MatchEstimated longestMatch = sequence[0];
    for (final MatchEstimated match in sequence.skip(1)) {
      if (match.token.length > longestMatch.token.length) {
        longestMatch = match;
      }
    }
    return longestMatch;
  }
}
