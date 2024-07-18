import '../src/options.dart';
import 'common.dart' as common;
import 'es_es/common_words.dart';
import 'es_es/first_names.dart';
import 'es_es/last_names.dart';
import 'es_es/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
