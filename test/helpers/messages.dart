import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

Future<bool> initializeMessages(String? localeName) async {
  final String? availableLocale = Intl.verifiedLocale(
    localeName,
    messages.containsKey,
    onFailure: (_) => null,
  );
  if (availableLocale == null) {
    return Future<bool>.value(false);
  }
  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(
    availableLocale,
    (String localeName) => messages[localeName],
  );
  return Future<bool>.value(true);
}

final Map<String, MessageLookupByLibrary> messages =
    <String, MessageLookupByLibrary>{
  'en': MessageLookupEn(),
  'es': MessageLookupEs(),
};

class MessageLookupEn extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  @override
  final Map<String, Function> messages = <String, Function>{
    'message1': MessageLookupByLibrary.simpleMessage(
      'Message 1 in English.',
    ),
    'Warnings_common': MessageLookupByLibrary.simpleMessage(
      'Warnings_common in English from initializeMessages.',
    ),
    'Suggestions_anotherWord': MessageLookupByLibrary.simpleMessage(
      'Suggestions_anotherWord in English from initializeMessages.',
    ),
    'TimeEstimations_ltSecond': MessageLookupByLibrary.simpleMessage(
      'less than a second from initializeMessages',
    ),
    'TimeEstimations_seconds': (int number) => Intl.pluralLogic(
          number,
          one: '$number second from initializeMessages',
          other: '$number seconds from initializeMessages',
        ),
    'TimeEstimations_hours': (int number) => Intl.pluralLogic(
          number,
          one: '$number hour from initializeMessages',
          other: '$number hours from initializeMessages',
        ),
  };
}

class MessageLookupEs extends MessageLookupByLibrary {
  @override
  String get localeName => 'es';

  @override
  final Map<String, Function> messages = <String, Function>{
    'message1': MessageLookupByLibrary.simpleMessage(
      'Message 1 in Spanish.',
    ),
    'Warnings_common': MessageLookupByLibrary.simpleMessage(
      'Warnings_common in Spanish from initializeMessages.',
    ),
    'Suggestions_anotherWord': MessageLookupByLibrary.simpleMessage(
      'Suggestions_anotherWord in Spanish from initializeMessages.',
    ),
    'TimeEstimations_ltSecond': MessageLookupByLibrary.simpleMessage(
      'menos de un segundo from initializeMessages',
    ),
    'TimeEstimations_seconds': (int number) => Intl.pluralLogic(
          number,
          one: '$number segundo from initializeMessages',
          other: '$number segundos from initializeMessages',
        ),
    'TimeEstimations_hours': (int number) => Intl.pluralLogic(
          number,
          one: '$number hora from initializeMessages',
          other: '$number horas from initializeMessages',
        ),
  };
}
