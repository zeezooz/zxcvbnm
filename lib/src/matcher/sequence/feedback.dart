import '../../options.dart';
import '../../types.dart';

Feedback? sequenceFeedback({
  required MatchEstimated match,
  required Options options,
  bool? isSoleMatch,
}) {
  return Feedback(
    warning: options.translation.warnings.sequences,
    suggestions: <String>[options.translation.suggestions.sequences],
  );
}
