import '../../feedback.dart';
import '../../options.dart';
import '../../types.dart';

Feedback? spatialFeedback({
  required SpatialMatchEstimated match,
  required Options options,
  bool? isSoleMatch,
}) {
  String warning = options.translation.warnings.keyPattern;
  if (match.turns == 1) {
    warning = options.translation.warnings.straightRow;
  }
  return Feedback(
    warning: warning,
    suggestions: <String>[
      options.translation.suggestions.longerKeyboardPattern,
    ],
  );
}
