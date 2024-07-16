<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A password strength estimator inspired by password crackers.
This is a Dart rewrite of [zxcvbn-ts](https://github.com/zxcvbn-ts/zxcvbn),
which is a rewrite and further evolution of [zxcvbn](https://github.com/dropbox/zxcvbn) by Dropbox.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Translation

The package uses [intl](https://pub.dev/packages/intl) to translate messages.
You can use your own translation or override some messages by loading a
translation with necessary keys. See
[lib/src/l10n/intl_en.arb](https://github.com/zeezooz/zxcvbnm/blob/main/lib/src/l10n/intl_en.arb)
for message keys. If you need to load more than 1 translation, use
[intl_multiple_translations](https://pub.dev/packages/intl_multiple_translations)
or a similar package.

### Dart

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

To use your own translation or override some messages:

* Create an ARB file with the translation. Use
[lib/src/l10n/intl_en.arb](https://github.com/zeezooz/zxcvbnm/blob/main/lib/src/l10n/intl_en.arb)
as a template.

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
"/lib/src/languages/common/translation.dart" to get the full path.

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
the package translation. See
[example/translation_example.dart](https://github.com/zeezooz/zxcvbnm/blob/main/example/translation_example.dart).

### Flutter

Add the localizations delegate:

```dart
import 'package:zxcvbnm/localizations.dart';
...
return MaterialApp(
  localizationsDelegates: [
    ZxcvbnmLocalizations.delegate,
    ...
  ],
  ...
);
```

To use your own translation or override some messages:

* Create an ARB file with the translation. Use
[lib/src/l10n/intl_en.arb](https://github.com/zeezooz/zxcvbnm/blob/main/lib/src/l10n/intl_en.arb)
as a template.

* Add [intl_utils](https://pub.dev/packages/intl_utils) to dev_dependencies
and enable it in pubspec.yaml:

```yaml
flutter_intl:
  enabled: true
```

* Generate Dart files:

```shell
dart run intl_utils:generate
```

* Use the generated delegate.

```dart
import 'generated/l10n.dart';
...
return MaterialApp(
  localizationsDelegates: [
    S.delegate,
    ...
  ],
  ...
);
```

When overriding a translation, make sure that you add your localization delegate
after the package localization delegate. See
[example/flutter_example](https://github.com/zeezooz/zxcvbnm/blob/main/example/flutter_example).

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
