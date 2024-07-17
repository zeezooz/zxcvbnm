import '../src/options.dart';
import 'common/diceware.dart';
import 'common/passwords.dart';

/// Dictionaries that should be used to check against.
const Dictionaries dictionaries = <Dictionary, List<List<Object>>>{
  Dictionary.diceware: <List<Object>>[diceware],
  Dictionary.passwords: <List<Object>>[passwords],
};
