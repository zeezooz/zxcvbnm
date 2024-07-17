import '../../options.dart';
import '../common/dictionaries.dart' as common;
import 'common_words.dart';
import 'first_names.dart';
import 'last_names.dart';
import 'wikipedia.dart';

/// Dictionaries that should be used to check against.
const Dictionaries dictionaries = <Dictionary, List<List<Object>>>{
  ...common.dictionaries,
  Dictionary.commonWords: <List<Object>>[commonWords],
  Dictionary.names: <List<Object>>[firstNames, lastNames],
  Dictionary.wikipedia: <List<Object>>[wikipedia],
};
