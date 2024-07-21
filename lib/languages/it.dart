import '../src/options.dart';
import 'common.dart' as common;
import 'it/common_words.dart';
import 'it/first_names.dart';
import 'it/last_names.dart';
import 'it/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
