import 'package:intl/intl.dart';
import 'package:intl/src/intl_helpers.dart';
import 'package:intl_multiple_translations/intl_multiple_translations.dart';
import 'package:test/test.dart';
import 'package:zxcvbnm/languages/common.dart';
import 'package:zxcvbnm/messages.dart';

import 'helpers/messages.dart';

void main() {
  setUp(() {
    messageLookup =
        UninitializedLocaleData<void>('initializeMessages(<locale>)', null);
  });

  group('Translation.', () {
    test(
      'Should translate.',
      () async {
        await initializeZxcvbnmMessages('es');
        Intl.withLocale('en', () {
          expect(
            Translation.warnings.common,
            'This is a commonly used password.',
          );
        });
        Intl.withLocale('es', () {
          expect(
            Translation.warnings.common,
            'Es una contraseña usada comúnmente.',
          );
        });
      },
    );

    test(
      'Should allow override.',
      () async {
        initializeMultipleTranslations();
        await initializeZxcvbnmMessages('es');
        await initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Translation.warnings.dates,
            'Las fechas son fáciles de adivinar.',
          );
          expect(
            Intl.message('message1'),
            'Message 1 in Spanish.',
          );
          expect(
            Translation.warnings.common,
            'Warnings_common in Spanish from initializeMessages.',
          );
        });
      },
    );
  });
}
