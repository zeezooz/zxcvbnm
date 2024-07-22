A password strength estimator inspired by password crackers.
This is a Dart rewrite of
[zxcvbn-ts](https://github.com/zxcvbn-ts/zxcvbn),
which is a rewrite and further evolution of
[zxcvbn](https://github.com/dropbox/zxcvbn) by Dropbox.

The goal is to match [zxcvbn-ts](https://github.com/zxcvbn-ts/zxcvbn) in password evaluation. Although message translation and API may differ.

> zxcvbn is a password strength estimator inspired by password crackers.
> Through pattern matching and conservative estimation, it recognizes and
> weighs 40k common passwords, common names surnames, popular words from
> Wikipedia and common word in different language from different countries,
> and other common patterns like dates, repeats (aaa), sequences (abcd),
> keyboard patterns (qwertyuiop), and l33t speak.
>
> Consider using zxcvbn as an algorithmic alternative to password composition
> policy&nbsp;— it is more secure, flexible, and usable when sites require a
> minimal complexity score in place of annoying rules like "passwords must
> contain three of {lower, upper, numbers, symbols}".
>
> - **More secure**: policies often fail both ways, allowing weak passwords
> (P@ssword1) and disallowing strong passwords.
> - **More flexible**: zxcvbn allows many password styles to flourish so long as
> it detects sufficient complexity&nbsp;— passphrases are rated highly given
> enough uncommon words, keyboard patterns are ranked based on length and number
> of turns, and capitalization adds more complexity when it's unpredictaBle.
> - **More usable**: zxcvbn is designed to power simple, rule-free interfaces
> that give instant feedback. In addition to strength estimation, zxcvbn
> includes minimal, targeted verbal feedback that can help guide users towards
> less guessable passwords.
>
> For further detail and motivation, please refer to the USENIX Security '16
> [paper and presentation](https://www.usenix.org/conference/usenixsecurity16/technical-sessions/presentation/wheeler).

## Features

- Estimate strength of a password
- Get a score for the password
- Localization support for [dictionaries](#dictionaries) and feedback
  [translations](#translation)
- Extend existing dictionaries with your own
- Usable without dictionaries at all, which reduce the scoring efficiency
  rapidly. This is not recommended
- [Custom matchers](https://github.com/zeezooz/zxcvbnm/blob/main/test/custom_matcher_test.dart),
  including
  [asynchronous ones](https://github.com/zeezooz/zxcvbnm/blob/main/test/async_matcher_test.dart)

## Usage

```dart
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/zxcvbnm.dart';
...
final Zxcvbnm zxcvbnm = Zxcvbnm(dictionaries: dictionaries);
final Result result = zxcvbnm('password');
print('score: ${result.score}/4');
```

### Dictionaries

Dictionaries contain easy-to-guess words to check a password for. By default, no
dictionaries are used, which may allow some weak passwords, so it's recommended
to specify some dictionaries. They are `Set`s, so you can combine them using the
spread operator:

```dart
import 'package:zxcvbnm/languages/en.dart' as en;
import 'package:zxcvbnm/languages/es_es.dart' as es;
...
dictionaries: {
  ...en.dictionaries,
  if (localeName == 'es') ...es.dictionaries,
}
```

#### Included dictionaries

- `common` - [Diceware](https://en.wikipedia.org/wiki/Diceware) and the most
  often used passwords. These dictionaries are already included in the locale
  specific dictionaries, so you usually don't need to add them explicitly
- `cs` - Czech
- `de` - German
- `en` - English
- `es_es` - Spanish (Spain)
- `fi` - Finnish
- `fr` - French
- `id` - Indonesian
- `it` - Italian
- `ja` - Japanese
- `nl_be` - Dutch (Belgium)
- `pl` - Polish
- `pt_br` - Portuguese (Brazil)

Locale specific dictionaries contain the most often used words, the most common
names, and the most often used words from Wikipedia.

### Translation

The package uses [intl](https://pub.dev/packages/intl) to translate messages.
You can use your own translation or override some messages by loading a
translation with necessary keys. If you need to load more than 1 translation
per locale, use
[intl_multiple_translations](https://pub.dev/packages/intl_multiple_translations)
or a similar package.

#### Included languages

- `cs` - Czech
- `de` - German
- `en` (default) - English
- `es` - Spanish (Spain)
- `fi` - Finnish
- `fr` - French
- `id` - Indonesian
- `it` - Italian
- `ja` - Japanese
- `nl` - Dutch (Belgium)
- `pl` - Polish
- `pt` - Portuguese (Brazil)

#### Dart

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

See
[doc/translation/dart.md](https://github.com/zeezooz/zxcvbnm/blob/main/doc/translation/dart.md)
to learn how to use your own translation or override some messages.

#### Flutter

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

See
[doc/translation/flutter.md](https://github.com/zeezooz/zxcvbnm/blob/main/doc/translation/flutter.md)
to learn how to use your own translation or override some messages.

## Contribution

Please feel free to
[open an issue](https://github.com/zeezooz/zxcvbnm/issues/new) or provide a pull
request.
