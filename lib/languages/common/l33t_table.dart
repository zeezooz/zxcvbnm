import '../../src/options.dart';

/// Define an object with l33t substitutions. For example that an 'a' can
/// be exchanged with a '4' or a '@'.
const L33tTable l33tTable = <String, List<String>>{
  'a': <String>['4', '@'],
  'b': <String>['8'],
  'c': <String>['(', '{', '[', '<'],
  'd': <String>['6', '|)'],
  'e': <String>['3'],
  'f': <String>['#'],
  'g': <String>['6', '9', '&'],
  'h': <String>['#', '|-|'],
  'i': <String>['1', '!', '|'],
  'k': <String>['<', '|<'],
  'l': <String>['!', '1', '|', '7'],
  'm': <String>['^^', 'nn', '2n', r'/\\/\\'],
  'n': <String>['//'],
  'o': <String>['0', '()'],
  'q': <String>['9'],
  's': <String>[r'$', '5'],
  't': <String>['+', '7'],
  'u': <String>['|_|'],
  'v': <String>['<', '>', '/'],
  'w': <String>['^/', 'uu', 'vv', '2u', '2v', r'\\/\\/'],
  'x': <String>['%', '><'],
  'z': <String>['2'],
};
