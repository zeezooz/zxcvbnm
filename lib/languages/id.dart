import '../src/options.dart';
import 'common.dart' as common;
import 'id/common_words.dart';
import 'id/names.dart';
import 'id/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  names,
  wikipedia,
};
