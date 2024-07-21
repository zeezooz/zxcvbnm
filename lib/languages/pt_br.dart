import '../src/options.dart';
import 'common.dart' as common;
import 'pt_br/common_words.dart';
import 'pt_br/first_names.dart';
import 'pt_br/last_names.dart';
import 'pt_br/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
