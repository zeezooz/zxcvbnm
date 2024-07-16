import '../../options.dart';
import 'diceware.dart';
import 'passwords.dart';

/// Dictionaries that should be used to check against.
const Dictionaries dictionaries = <Dictionary, List<Object>>{
  Dictionary.diceware: diceware,
  Dictionary.passwords: passwords,
};
