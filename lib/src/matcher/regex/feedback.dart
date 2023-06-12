import '../../options.dart';
import '../../types.dart';

Feedback? regexFeedback({
  required RegexMatchEstimated match,
  required Options options,
  bool? isSoleMatch,
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
  return Feedback();
}
