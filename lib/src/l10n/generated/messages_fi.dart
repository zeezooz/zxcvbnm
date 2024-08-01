// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fi locale. All the
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
  String get localeName => 'fi';

  static m0(number) =>
      "${Intl.plural(number, one: '${number} päivä', other: '${number} päivää')}";

  static m1(number) =>
      "${Intl.plural(number, one: '${number} tunti', other: '${number} tuntia')}";

  static m2(number) =>
      "${Intl.plural(number, one: '${number} minuutti', other: '${number} minuuttia')}";

  static m3(number) =>
      "${Intl.plural(number, one: '${number} kuukausi', other: '${number} kuukautta')}";

  static m4(number) =>
      "${Intl.plural(number, one: '${number} sekunti', other: '${number} sekuntia')}";

  static m5(number) =>
      "${Intl.plural(number, one: '${number} vuosi', other: '${number} vuotta')}";

  @override
  final Map<String, dynamic> messages =
      _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
        'Suggestions_allUppercase': MessageLookupByLibrary.simpleMessage(
            'Kirjoita osa kirjaimista isolla, mutta älä kaikkia.'),
        'Suggestions_anotherWord': MessageLookupByLibrary.simpleMessage(
            'Käytä salasanassa lisää vähemmän tunnettuja sanoja.'),
        'Suggestions_associatedYears': MessageLookupByLibrary.simpleMessage(
            'Vältä sinuun liitettävissä olevien vuosilukujen käyttöä.'),
        'Suggestions_capitalization': MessageLookupByLibrary.simpleMessage(
            'Käytä isoja kirjaimia muutoinkin kuin vain ensimmäisessä kirjaimessa.'),
        'Suggestions_dates': MessageLookupByLibrary.simpleMessage(
            'Vältä sinuun liitettävissä olevia päivämääriä ja vuosilukuja.'),
        'Suggestions_l33t': MessageLookupByLibrary.simpleMessage(
            'Vältä ennustettavissa olevia kirjainvaihtoja kuten esimerkiksi @-merkin käyttöä a:n sijasta.'),
        'Suggestions_longerKeyboardPattern': MessageLookupByLibrary.simpleMessage(
            'Käytä salasanassa pidempiä näppäinsarjoja ja vaihda kirjoitussuuntaa useasti.'),
        'Suggestions_noNeed': MessageLookupByLibrary.simpleMessage(
            'Voit luoda vahvan salasanan myös käyttämättä symboleja, numeroita tai isoja kirjaimia.'),
        'Suggestions_recentYears':
            MessageLookupByLibrary.simpleMessage('Vältä lähivuosien käyttöä.'),
        'Suggestions_repeated': MessageLookupByLibrary.simpleMessage(
            'Vältä sanojen ja merkkien toistamista.'),
        'Suggestions_reverseWords': MessageLookupByLibrary.simpleMessage(
            'Vältä tunnettujen sanojen takaperin kirjoittamista.'),
        'Suggestions_sequences': MessageLookupByLibrary.simpleMessage(
            'Vältä tunnettuja merkkisarjoja.'),
        'Suggestions_useWords': MessageLookupByLibrary.simpleMessage(
            'Voit käyttää salasanassa useampia sanoja, mutta vältä kuitenkin tunnettuja lauseita.'),
        'TimeEstimations_centuries':
            MessageLookupByLibrary.simpleMessage('vuosikymmeniä'),
        'TimeEstimations_days': m0,
        'TimeEstimations_hours': m1,
        'TimeEstimations_ltSecond':
            MessageLookupByLibrary.simpleMessage('alle sekunti'),
        'TimeEstimations_minutes': m2,
        'TimeEstimations_months': m3,
        'TimeEstimations_seconds': m4,
        'TimeEstimations_years': m5,
        'Warnings_common': MessageLookupByLibrary.simpleMessage(
            'Tämä on hyvin yleinen salasana.'),
        'Warnings_commonNames': MessageLookupByLibrary.simpleMessage(
            'Yleisnimet ja sukunimet ovat helppoja arvata.'),
        'Warnings_dates': MessageLookupByLibrary.simpleMessage(
            'Päivät ovat helppoja arvata.'),
        'Warnings_extendedRepeat': MessageLookupByLibrary.simpleMessage(
            'Toistuvat merkkisarjat \"abcabcabc\" ovat helppoja arvata.'),
        'Warnings_keyPattern': MessageLookupByLibrary.simpleMessage(
            'Lyhyet näppäinsarjat ovat helppoja arvata.'),
        'Warnings_namesByThemselves': MessageLookupByLibrary.simpleMessage(
            'Yksittäiset nimet ja sukunimet ovat helppoja arvata.'),
        'Warnings_recentYears': MessageLookupByLibrary.simpleMessage(
            'Viime vuodet ovat helppoja arvata.'),
        'Warnings_sequences': MessageLookupByLibrary.simpleMessage(
            'Peräkkäiset merkit kuten \"abc\" ovat helppoja arvata.'),
        'Warnings_similarToCommon': MessageLookupByLibrary.simpleMessage(
            'Tämä on samankaltainen kuin usein käytetty salasana.'),
        'Warnings_simpleRepeat': MessageLookupByLibrary.simpleMessage(
            'Toistot kuten \"aaa\" ovat helppoja arvata.'),
        'Warnings_straightRow': MessageLookupByLibrary.simpleMessage(
            'Näppäimistön vierekkäiset kirjaimet ovat helppoja arvata.'),
        'Warnings_topHundred': MessageLookupByLibrary.simpleMessage(
            'Tämä on hyvin usein käytetty salasana.'),
        'Warnings_topTen': MessageLookupByLibrary.simpleMessage(
            'Tämä on yksi yleisimmistä salasanoista.'),
        'Warnings_userInputs': MessageLookupByLibrary.simpleMessage(
            'Salasanassa ei tulisi olla henkilökohtaista tai sivustoon liittyvää tietoa.'),
        'Warnings_wordByItself':
            MessageLookupByLibrary.simpleMessage('Sana on hyvin helppo arvata.')
      };
}
