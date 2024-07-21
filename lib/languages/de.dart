import '../src/options.dart';
import 'common.dart' as common;
import 'de/common_words.dart';
import 'de/first_names.dart';
import 'de/last_names.dart';
import 'de/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
