import '../../options.dart';
import '../../types.dart';

Feedback? dateFeedback({
  required MatchEstimated match,
  required Options options,
  bool? isSoleMatch,
}) {
  return Feedback(
    warning: options.translation.warnings.dates,
    suggestions: <String>[options.translation.suggestions.dates],
  );
}
