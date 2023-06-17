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
        .where((ReverseMatch match) {
      // Ignore palindromes because they're matched as a dictionary match.
      return match.token.toLowerCase() != match.matchedWord;
    }).toList();
  }
}
