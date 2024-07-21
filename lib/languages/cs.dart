import '../src/options.dart';
import 'common.dart' as common;
import 'cs/common_words.dart';
import 'cs/first_names.dart';
import 'cs/last_names.dart';
import 'cs/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
