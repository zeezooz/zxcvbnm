import '../../feedback.dart';
import '../../matchers/base_matcher.dart';
import '../../options.dart';

Feedback? sequenceFeedback({
  required BaseMatch match,
  required Options options,
  required bool isSoleMatch,
}) {
  return Feedback(
    warning: options.translation.warnings.sequences,
    suggestions: <String>[options.translation.suggestions.sequences],
  );
}
