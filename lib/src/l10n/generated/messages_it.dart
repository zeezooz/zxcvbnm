// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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

typedef String? MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'it';

  static m0(number) =>
      "${Intl.plural(number, one: '${number} giorno', other: '${number} giorni')}";

  static m1(number) =>
      "${Intl.plural(number, one: '${number} ora', other: '${number} ore')}";

  static m2(number) =>
      "${Intl.plural(number, one: '${number} minuto', other: '${number} minuti')}";

  static m3(number) =>
      "${Intl.plural(number, one: '${number} mese', other: '${number} mesi')}";

  static m4(number) =>
      "${Intl.plural(number, one: '${number} secondo', other: '${number} secondi')}";

  static m5(number) =>
      "${Intl.plural(number, one: '${number} anno', other: '${number} anni')}";

  @override
  final Map<String, dynamic> messages =
      _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
        'Suggestions_allUppercase': MessageLookupByLibrary.simpleMessage(
            'Scrivi alcune lettere in maiuscolo, ma non tutte.'),
        'Suggestions_anotherWord': MessageLookupByLibrary.simpleMessage(
            'Aggiungi un maggior numero di parole meno comuni.'),
        'Suggestions_associatedYears': MessageLookupByLibrary.simpleMessage(
            'Evita gli anni associati alla tua persona.'),
        'Suggestions_capitalization': MessageLookupByLibrary.simpleMessage(
            'Scrivi la prima lettera e almeno un\'altra in maiuscolo.'),
        'Suggestions_dates': MessageLookupByLibrary.simpleMessage(
            'Evita le date e gli anni associati alla tua persona.'),
        'Suggestions_l33t': MessageLookupByLibrary.simpleMessage(
            'Evita prevedibili sostituzioni di lettere come \"@\" per \"a\".'),
        'Suggestions_longerKeyboardPattern': MessageLookupByLibrary.simpleMessage(
            'Usa combinazioni di tasti più lunghe e cambia più volte la direzione di digitazione.'),
        'Suggestions_noNeed': MessageLookupByLibrary.simpleMessage(
            'Puoi creare password complesse senza utilizzare simboli, numeri o lettere maiuscole.'),
        'Suggestions_recentYears':
            MessageLookupByLibrary.simpleMessage('Evita gli anni recenti.'),
        'Suggestions_repeated': MessageLookupByLibrary.simpleMessage(
            'Evita la ripetizione di parole e caratteri.'),
        'Suggestions_reverseWords': MessageLookupByLibrary.simpleMessage(
            'Evita di scrivere parole di uso comune al contrario.'),
        'Suggestions_sequences': MessageLookupByLibrary.simpleMessage(
            'Evita le sequenze di caratteri comuni.'),
        'Suggestions_useWords': MessageLookupByLibrary.simpleMessage(
            'Usa più parole, ma evita frasi comuni.'),
        'TimeEstimations_centuries':
            MessageLookupByLibrary.simpleMessage('secoli'),
        'TimeEstimations_days': m0,
        'TimeEstimations_hours': m1,
        'TimeEstimations_ltSecond':
            MessageLookupByLibrary.simpleMessage('meno di un secondo'),
        'TimeEstimations_minutes': m2,
        'TimeEstimations_months': m3,
        'TimeEstimations_seconds': m4,
        'TimeEstimations_years': m5,
        'Warnings_common': MessageLookupByLibrary.simpleMessage(
            'Questa è una password di uso comune.'),
        'Warnings_commonNames': MessageLookupByLibrary.simpleMessage(
            'I nomi e cognomi comuni sono facili da indovinare.'),
        'Warnings_dates': MessageLookupByLibrary.simpleMessage(
            'Le date sono facili da indovinare.'),
        'Warnings_extendedRepeat': MessageLookupByLibrary.simpleMessage(
            'Le combinazioni di caratteri ripetuti come \"abcabcabc\" sono facili da indovinare.'),
        'Warnings_keyPattern': MessageLookupByLibrary.simpleMessage(
            'Le brevi combinazioni di tasti sono facili da indovinare.'),
        'Warnings_namesByThemselves': MessageLookupByLibrary.simpleMessage(
            'I singoli nomi o cognomi sono facili da indovinare.'),
        'Warnings_recentYears': MessageLookupByLibrary.simpleMessage(
            'Gli anni recenti sono facili da indovinare.'),
        'Warnings_sequences': MessageLookupByLibrary.simpleMessage(
            'Le sequenze di caratteri comuni come \"abc\" sono facili da indovinare.'),
        'Warnings_similarToCommon': MessageLookupByLibrary.simpleMessage(
            'Questa assomiglia a una password di uso comune.'),
        'Warnings_simpleRepeat': MessageLookupByLibrary.simpleMessage(
            'I caratteri ripetuti come \"aaa\" sono facili da indovinare.'),
        'Warnings_straightRow': MessageLookupByLibrary.simpleMessage(
            'Le sequenze lineari dei tasti sulla tastiera sono facili da indovinare.'),
        'Warnings_topHundred': MessageLookupByLibrary.simpleMessage(
            'Questa è una password usata spesso.'),
        'Warnings_topTen': MessageLookupByLibrary.simpleMessage(
            'Questa è una password molto usata.'),
        'Warnings_userInputs': MessageLookupByLibrary.simpleMessage(
            'Non devono essere presenti dati personali o relativi alla pagina.'),
        'Warnings_wordByItself': MessageLookupByLibrary.simpleMessage(
            'Le singole parole sono facili da indovinare.')
      };
}
