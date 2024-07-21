import '../src/options.dart';
import 'common.dart' as common;
import 'fr/common_words.dart';
import 'fr/first_names.dart';
import 'fr/last_names.dart';
import 'fr/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
