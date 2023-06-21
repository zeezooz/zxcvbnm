import '../../types.dart';
import '../common/dictionaries.dart' as common;
import 'common_words.dart';
import 'first_names.dart';
import 'last_names.dart';
import 'wikipedia.dart';

const Dictionaries dictionaries = <Dictionary, List<Object>>{
  ...common.dictionaries,
  Dictionary.commonWords: commonWords,
  Dictionary.firstNames: firstNames,
  Dictionary.lastNames: lastNames,
  Dictionary.wikipedia: wikipedia,
};
