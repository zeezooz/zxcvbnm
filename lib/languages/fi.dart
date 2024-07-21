import '../src/options.dart';
import 'common.dart' as common;
import 'fi/common_words.dart';
import 'fi/female_first_names.dart';
import 'fi/last_names.dart';
import 'fi/male_first_names.dart';
import 'fi/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  femaleFirstNames,
  lastNames,
  maleFirstNames,
  wikipedia,
};
