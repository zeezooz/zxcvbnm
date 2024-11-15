import '../src/options.dart';
import 'common.dart' as common;
import 'en/common_words.dart';
import 'en/first_names.dart';
import 'en/last_names.dart';
import 'en/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
