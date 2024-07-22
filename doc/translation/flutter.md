# Translating in Flutter

The package uses [intl](https://pub.dev/packages/intl) to translate messages.
You can use your own translation or override some messages by loading a
translation with necessary keys.

## Usage

Install [zxcvbnm_flutter](https://pub.dev/packages/zxcvbnm_flutter).

Add the localizations delegate:

```dart
import 'package:zxcvbnm_flutter/zxcvbnm_flutter.dart';
...
return MaterialApp(
  localizationsDelegates: [
    ZxcvbnmLocalizations.delegate,
    ...
  ],
  ...
);
```

## Using your own translation or overriding some messages

* Create an ARB file with the translation. Use
[lib/src/l10n/intl_en.arb](https://github.com/zeezooz/zxcvbnm/blob/main/lib/src/l10n/intl_en.arb)
as a template. You can add only the messages you want to override.

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
after the package localization delegate and use
[intl_multiple_translations](https://pub.dev/packages/intl_multiple_translations)
or a similar package. See
[the example](https://github.com/zeezooz/zxcvbnm_flutter/blob/main/example/flutter_example).
