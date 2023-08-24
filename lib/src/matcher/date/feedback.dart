import '../../feedback.dart';
import '../../matchers/base_matcher.dart';
import '../../options.dart';

Feedback? dateFeedback({
  required BaseMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  return Feedback(
    warning: options.translation.warnings.dates,
    suggestions: <String>[options.translation.suggestions.dates],
  );
}
