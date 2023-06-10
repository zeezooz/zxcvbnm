import '../../types.dart';
import '../common/dictionaries.dart' as common;
import 'commonWords.dart';
import 'firstnames.dart';
import 'lastnames.dart';
import 'wikipedia.dart';

const Dictionaries dictionaries = <Dictionary, List<Object>>{
  ...common.dictionaries,
  Dictionary.commonWords: commonWords,
  Dictionary.firstnames: firstnames,
  Dictionary.lastnames: lastnames,
  Dictionary.wikipedia: wikipedia,
};
