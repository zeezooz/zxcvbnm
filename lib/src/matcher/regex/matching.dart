import '../../data/const.dart';
import '../../types.dart';

/// Regex matching.
class MatchRegex extends MatchingType {
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
            i: match.start,
            j: match.end - 1,
            token: match[0]!,
            regexName: name,
            regexMatch: match,
          ),
        );
      }
    });
    return <List<RegexMatch>>[matches];
  }
}
