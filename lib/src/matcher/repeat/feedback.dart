import '../../options.dart';
import '../../types.dart';

Feedback? repeatFeedback({
  required RepeatMatchEstimated match,
  required Options options,
  bool? isSoleMatch,
}) {
  return Feedback(
    warning: match.baseToken.length == 1
        ? options.translation.warnings.simpleRepeat
        : options.translation.warnings.extendedRepeat,
    suggestions: <String>[options.translation.suggestions.repeated],
  );
}
