import '../../../../types.dart';
import '../../types.dart';

///  Dictionary reverse matching.
class MatchReverse {
  MatchReverse(this.defaultMatch);

  final DefaultMatch defaultMatch;

  List<ReverseMatch> match(String password) {
    final String reversedPassword = password.split('').reversed.join('');
    return defaultMatch(reversedPassword)
        .map((DictionaryMatch match) => match.toReverseMatch(password))
        .toList();
  }
}
