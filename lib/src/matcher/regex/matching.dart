import '../../data/const.dart';
import '../../matchers/base_matcher.dart';
import '../../options.dart';
import '../../types.dart';

/// Regex matching.
class MatchRegex extends BaseMatcher {
  MatchRegex(this.options);

  final Options options;

  @override
  List<List<RegexMatch>> match(
    String password, {
    Map<String, RegExp>? regexes,
  }) {
    regexes ??= regexen;
    final List<RegexMatch> matches = <RegexMatch>[];
    regexes.forEach((String name, RegExp regex) {
      for (final RegExpMatch match in regex.allMatches(password)) {
        matches.add(
          RegexMatch(
            password: password,
            start: match.start,
            end: match.end,
            regexName: name,
            regexMatch: match,
            options: options,
          ),
        );
      }
    });
    return <List<RegexMatch>>[matches];
  }
}
