import '../src/options.dart';
import 'common.dart' as common;
import 'en/common_words.dart';
import 'en/first_names.dart';
import 'en/last_names.dart';
import 'en/wikipedia.dart';

/// Dictionaries that should be used to check against.
const Dictionaries dictionaries = <Dictionary, List<List<Object>>>{
  ...common.dictionaries,
  Dictionary.commonWords: <List<Object>>[commonWords],
  Dictionary.names: <List<Object>>[firstNames, lastNames],
  Dictionary.wikipedia: <List<Object>>[wikipedia],
};
