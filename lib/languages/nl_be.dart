import '../src/options.dart';
import 'common.dart' as common;
import 'nl_be/boys_first_names.dart';
import 'nl_be/common_words.dart';
import 'nl_be/girls_first_names.dart';
import 'nl_be/last_names.dart';
import 'nl_be/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  boysFirstNames,
  commonWords,
  girlsFirstNames,
  lastNames,
  wikipedia,
};
