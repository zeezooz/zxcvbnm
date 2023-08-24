import '../../../../matchers/base_matcher.dart';
import '../../../../types.dart';
import '../../types.dart';

///  Dictionary reverse matching.
class MatchReverse extends BaseMatcher {
  MatchReverse(this.defaultMatch);

  final DefaultMatch defaultMatch;

  @override
  List<List<ReverseMatch>> match(String password) {
    final String reversedPassword = password.split('').reversed.join('');
    return <List<ReverseMatch>>[
      defaultMatch(reversedPassword)
          .map((DictionaryMatch match) => match.toReverseMatch())
          .where((ReverseMatch match) {
        // Ignore palindromes because they're matched as a dictionary match.
        return match.token.toLowerCase() != match.matchedWord;
      }).toList(),
    ];
  }
}
