import '../src/options.dart';
import 'common.dart' as common;
import 'pl/common_words.dart';
import 'pl/female_first_names.dart';
import 'pl/female_last_names.dart';
import 'pl/male_first_names.dart';
import 'pl/male_last_names.dart';
import 'pl/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  ...common.dictionaries,
  commonWords,
  femaleFirstNames,
  femaleLastNames,
  maleFirstNames,
  maleLastNames,
  wikipedia,
};
