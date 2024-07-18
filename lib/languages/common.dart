import '../src/options.dart';
import 'common/diceware.dart';
import 'common/passwords.dart';

/// Dictionaries that should be used to check against.
const Set<Dictionaries> dictionaries = <Dictionaries>{
  diceware,
  passwords,
};
