import '../src/options.dart';
import 'ar/first_names.dart';
import 'ar/last_names.dart';
import 'common.dart' as common;

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  firstNames,
  lastNames,
};
