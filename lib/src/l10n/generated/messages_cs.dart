// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'cs';

  static m0(number) => "${Intl.plural(number, one: '${number} den', other: '${number} dny')}";

  static m1(number) => "${Intl.plural(number, one: '${number} hodina', other: '${number} hodiny')}";

  static m2(number) => "${Intl.plural(number, one: '${number} minuta', other: '${number} minuty')}";

  static m3(number) => "${Intl.plural(number, one: '${number} měsíc', other: '${number} měsíce')}";

  static m4(number) => "${Intl.plural(number, one: '${number} sekundu', other: '${number} sekundy')}";

  static m5(number) => "${Intl.plural(number, one: '${number} rok', other: '${number} roky')}";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'Suggestions_allUppercase': MessageLookupByLibrary.simpleMessage('Některá písmena velká, ale ne všechna.'),
    'Suggestions_anotherWord': MessageLookupByLibrary.simpleMessage('Přidejte více slov, která jsou méně obvyklá.'),
    'Suggestions_associatedYears': MessageLookupByLibrary.simpleMessage('Vyhněte se rokům, které jsou s vámi spojeny.'),
    'Suggestions_capitalization': MessageLookupByLibrary.simpleMessage('Pište více než první písmeno velkým písmenem.'),
    'Suggestions_dates': MessageLookupByLibrary.simpleMessage('Vyhněte se datům a rokům, které jsou s vámi spojeny.'),
    'Suggestions_l33t': MessageLookupByLibrary.simpleMessage('Vyhněte se předvídatelným záměnám písmen, jako je \"@\" za \"a\".'),
    'Suggestions_longerKeyboardPattern': MessageLookupByLibrary.simpleMessage('Používejte delší vzory klávesnice a několikrát změňte směr psaní.'),
    'Suggestions_noNeed': MessageLookupByLibrary.simpleMessage('Silná hesla můžete vytvářet bez použití symbolů, čísel nebo velkých písmen.'),
    'Suggestions_recentYears': MessageLookupByLibrary.simpleMessage('Vyhněte se posledním letům.'),
    'Suggestions_repeated': MessageLookupByLibrary.simpleMessage('Vyhněte se opakovaným slovům a znakům.'),
    'Suggestions_reverseWords': MessageLookupByLibrary.simpleMessage('Vyhněte se obrácenému hláskování běžných slov.'),
    'Suggestions_sequences': MessageLookupByLibrary.simpleMessage('Vyhněte se běžným sekvencím znaků.'),
    'Suggestions_useWords': MessageLookupByLibrary.simpleMessage('Používejte více slov, ale vyhněte se běžným frázím.'),
    'TimeEstimations_centuries': MessageLookupByLibrary.simpleMessage('staletí'),
    'TimeEstimations_days': m0,
    'TimeEstimations_hours': m1,
    'TimeEstimations_ltSecond': MessageLookupByLibrary.simpleMessage('méně než sekundu'),
    'TimeEstimations_minutes': m2,
    'TimeEstimations_months': m3,
    'TimeEstimations_seconds': m4,
    'TimeEstimations_years': m5,
    'Warnings_common': MessageLookupByLibrary.simpleMessage('Toto je běžně používané heslo.'),
    'Warnings_commonNames': MessageLookupByLibrary.simpleMessage('Běžná jména a příjmení lze snadno uhodnout.'),
    'Warnings_dates': MessageLookupByLibrary.simpleMessage('Termíny lze snadno uhodnout.'),
    'Warnings_extendedRepeat': MessageLookupByLibrary.simpleMessage('Opakované vzory znaků jako \"abcabcabc\" lze snadno uhodnout.'),
    'Warnings_keyPattern': MessageLookupByLibrary.simpleMessage('Krátké vzory klávesnice lze snadno uhodnout.'),
    'Warnings_namesByThemselves': MessageLookupByLibrary.simpleMessage('Jednotlivá jména nebo příjmení lze snadno uhodnout.'),
    'Warnings_recentYears': MessageLookupByLibrary.simpleMessage('Poslední roky lze snadno uhodnout.'),
    'Warnings_sequences': MessageLookupByLibrary.simpleMessage('Běžné sekvence znaků jako \"abc\" lze snadno uhodnout.'),
    'Warnings_similarToCommon': MessageLookupByLibrary.simpleMessage('Je to podobné jako u běžně používaného hesla.'),
    'Warnings_simpleRepeat': MessageLookupByLibrary.simpleMessage('Opakované znaky jako \"aaa\" lze snadno uhodnout.'),
    'Warnings_straightRow': MessageLookupByLibrary.simpleMessage('Rovné řady kláves na klávesnici lze snadno uhodnout.'),
    'Warnings_topHundred': MessageLookupByLibrary.simpleMessage('Toto je často používané heslo.'),
    'Warnings_topTen': MessageLookupByLibrary.simpleMessage('Toto je velmi často používané heslo.'),
    'Warnings_userInputs': MessageLookupByLibrary.simpleMessage('Neměly by zde být žádné osobní údaje ani údaje související se stránkou.'),
    'Warnings_wordByItself': MessageLookupByLibrary.simpleMessage('Jednotlivá slova lze snadno uhodnout.')
  };
}
