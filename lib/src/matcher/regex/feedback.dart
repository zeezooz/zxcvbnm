import '../../feedback.dart';
import '../../options.dart';
import '../../types.dart';

Feedback? regexFeedback({
  required RegexMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  if (match.regexName == 'recentYear') {
    return Feedback(
      warning: options.translation.warnings.recentYears,
      suggestions: <String>[
        options.translation.suggestions.recentYears,
        options.translation.suggestions.associatedYears,
      ],
    );
  }
  return null;
}
