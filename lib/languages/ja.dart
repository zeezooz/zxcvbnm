import '../src/options.dart';
import 'common.dart' as common;
import 'ja/common_words.dart';
import 'ja/first_names.dart';
import 'ja/last_names.dart';
import 'ja/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  firstNames,
  lastNames,
  wikipedia,
};
