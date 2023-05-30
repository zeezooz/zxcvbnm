import '../../options.dart';
import '../../types.dart';

FeedbackType? bruteforceFeedback({
  required Match match,
  bool? isSoleMatch,
}) {
  return FeedbackType(
    warning: options.translations.warnings.dates,
    suggestions: <String>[options.translations.suggestions.dates],
  );
}
