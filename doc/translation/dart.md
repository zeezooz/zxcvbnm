# Translating in Dart

The package uses [intl](https://pub.dev/packages/intl) to translate messages.
You can use your own translation or override some messages by loading a
translation with necessary keys.

## Usage

Load the translation:

```dart
import 'package:zxcvbnm/messages.dart';
...
await initializeZxcvbnmMessages('es');
```

and set the global locale:

```dart
import 'package:intl/intl.dart';
...
Intl.defaultLocale = 'es';
```

or override the current locale for a particular operation:

```dart
import 'package:intl/intl.dart';
...
Intl.withLocale('es', () => doSomething());
```

## Using your own translation or overriding some messages

* Create an ARB file with the translation. Use
[lib/src/l10n/intl_en.arb](https://github.com/zeezooz/zxcvbnm/blob/main/lib/src/l10n/intl_en.arb)
as a template. You can add only the messages you want to override.

* Add [intl_translation](https://pub.dev/packages/intl_translation) to
dev_dependencies or activate it globally:

```shell
dart pub global activate intl_translation
```

If you added it to dev_dependencies, replace `dart pub global run` with `dart run`
in the next command.

* Create an output directory if necessary.

* Locate the translation.dart file. Use `.dart_tool/package_config.json` to get
the package's rootUri. Remove the initial "file://" and append
"/lib/src/translation.dart" to get the full path.

* Generate Dart files:

```shell
dart pub global run intl_translation:generate_from_arb --output-dir output_directory --no-use-deferred-loading path/to/translation.dart path/to/your.arb
```

* Load the translation from the generated files.

```dart
import 'output_directory/messages_all.dart';
...
await initializeMessages('es');
```

When overriding a translation, make sure that you load your translation after
the package translation and use
[intl_multiple_translations](https://pub.dev/packages/intl_multiple_translations)
or a similar package. See
[example/translation_example.dart](https://github.com/zeezooz/zxcvbnm/blob/main/example/translation_example.dart).
