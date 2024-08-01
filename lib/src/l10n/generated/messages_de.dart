// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static m0(number) =>
      "${Intl.plural(number, one: '${number} Tag', other: '${number} Tage')}";

  static m1(number) =>
      "${Intl.plural(number, one: '${number} Stunde', other: '${number} Stunden')}";

  static m2(number) =>
      "${Intl.plural(number, one: '${number} Minute', other: '${number} Minuten')}";

  static m3(number) =>
      "${Intl.plural(number, one: '${number} Monat', other: '${number} Monate')}";

  static m4(number) =>
      "${Intl.plural(number, one: '${number} Sekunde', other: '${number} Sekunden')}";

  static m5(number) =>
      "${Intl.plural(number, one: '${number} Jahr', other: '${number} Jahre')}";

  @override
  final Map<String, dynamic> messages =
      _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
        'Suggestions_allUppercase': MessageLookupByLibrary.simpleMessage(
            'Einige, aber nicht alle Buchstaben groß schreiben.'),
        'Suggestions_anotherWord': MessageLookupByLibrary.simpleMessage(
            'Weitere Wörter, die weniger häufig vorkommen, hinzufügen.'),
        'Suggestions_associatedYears': MessageLookupByLibrary.simpleMessage(
            'Jahre, die mit persönlichen Daten in Verbindung gebracht werden können, vermeiden.'),
        'Suggestions_capitalization': MessageLookupByLibrary.simpleMessage(
            'Nicht nur den ersten Buchstaben groß schreiben.'),
        'Suggestions_dates': MessageLookupByLibrary.simpleMessage(
            'Daten, die mit persönlichen Daten in Verbindung gebracht werden können, vermeiden.'),
        'Suggestions_l33t': MessageLookupByLibrary.simpleMessage(
            'Vorhersehbare Buchstabenersetzungen wie \"@\" für \"a\" vermeiden.'),
        'Suggestions_longerKeyboardPattern': MessageLookupByLibrary.simpleMessage(
            'Längere Tastaturmuster in unterschiedlicher Tipprichtung verwenden.'),
        'Suggestions_noNeed': MessageLookupByLibrary.simpleMessage(
            'Es ist möglich, starke Passwörter zu erstellen, ohne Symbole, Zahlen oder Großbuchstaben zu verwenden.'),
        'Suggestions_recentYears': MessageLookupByLibrary.simpleMessage(
            'Die jüngsten Jahreszahlen vermeiden.'),
        'Suggestions_repeated': MessageLookupByLibrary.simpleMessage(
            'Wort- und Zeichenwiederholungen vermeiden.'),
        'Suggestions_reverseWords': MessageLookupByLibrary.simpleMessage(
            'Umgekehrte Schreibweise von gebräuchlichen Wörtern vermeiden.'),
        'Suggestions_sequences': MessageLookupByLibrary.simpleMessage(
            'Häufige Zeichenfolgen vermeiden.'),
        'Suggestions_useWords': MessageLookupByLibrary.simpleMessage(
            'Mehrere Wörter verwenden, aber allgemeine Phrasen vermeiden.'),
        'TimeEstimations_centuries':
            MessageLookupByLibrary.simpleMessage('Jahrhunderte'),
        'TimeEstimations_days': m0,
        'TimeEstimations_hours': m1,
        'TimeEstimations_ltSecond':
            MessageLookupByLibrary.simpleMessage('weniger als eine Sekunde'),
        'TimeEstimations_minutes': m2,
        'TimeEstimations_months': m3,
        'TimeEstimations_seconds': m4,
        'TimeEstimations_years': m5,
        'Warnings_common': MessageLookupByLibrary.simpleMessage(
            'Dies ist ein oft verwendetes Passwort.'),
        'Warnings_commonNames': MessageLookupByLibrary.simpleMessage(
            'Vornamen und Nachnamen sind leicht zu erraten.'),
        'Warnings_dates': MessageLookupByLibrary.simpleMessage(
            'Ein Datum ist leicht zu erraten.'),
        'Warnings_extendedRepeat': MessageLookupByLibrary.simpleMessage(
            'Sich wiederholende Zeichenmuster wie \"abcabcabc\" sind leicht zu erraten.'),
        'Warnings_keyPattern': MessageLookupByLibrary.simpleMessage(
            'Kurze Tastaturmuster sind leicht zu erraten.'),
        'Warnings_namesByThemselves': MessageLookupByLibrary.simpleMessage(
            'Einzelne Namen oder Nachnamen sind leicht zu erraten.'),
        'Warnings_recentYears': MessageLookupByLibrary.simpleMessage(
            'Die jüngsten Jahreszahlen sind leicht zu erraten.'),
        'Warnings_sequences': MessageLookupByLibrary.simpleMessage(
            'Häufige Zeichenfolgen wie \"abc\" sind leicht zu erraten.'),
        'Warnings_similarToCommon': MessageLookupByLibrary.simpleMessage(
            'Dies weist Ähnlichkeit zu anderen oft verwendeten Passwörtern auf.'),
        'Warnings_simpleRepeat': MessageLookupByLibrary.simpleMessage(
            'Sich wiederholende Zeichen wie \"aaa\" sind leicht zu erraten.'),
        'Warnings_straightRow': MessageLookupByLibrary.simpleMessage(
            'Gerade Linien von Tasten auf der Tastatur sind leicht zu erraten.'),
        'Warnings_topHundred': MessageLookupByLibrary.simpleMessage(
            'Dies ist ein häufig verwendetes Passwort.'),
        'Warnings_topTen': MessageLookupByLibrary.simpleMessage(
            'Dies ist ein sehr häufig verwendetes Passwort.'),
        'Warnings_userInputs': MessageLookupByLibrary.simpleMessage(
            'Es sollten keine persönlichen oder Seiten relevanten Daten vorkommen.'),
        'Warnings_wordByItself': MessageLookupByLibrary.simpleMessage(
            'Einzelne Wörter sind leicht zu erraten.')
      };
}
