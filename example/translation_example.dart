// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:intl_multiple_translations/intl_multiple_translations.dart';
import 'package:zxcvbnm/messages.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

// Additional translation.
import 'l10n/generated/messages_all.dart';

Future<void> main() async {
  const String localeName = 'es';
  // Allow multiple translations per locale.
  initializeMultipleTranslations();
  // Load the package translation first.
  await initializeZxcvbnmMessages(localeName);
  // Then load an additional translation to override the package translation.
  await initializeMessages(localeName);
  // Set the locale.
  Intl.defaultLocale = localeName;
  final Zxcvbnm zxcvbnm = Zxcvbnm();
  final Result result = zxcvbnm('');
  print(result.feedback.suggestions.join('\n'));
}
