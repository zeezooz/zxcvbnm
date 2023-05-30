import 'data/translation_keys.dart';
import 'types.dart';

class Options {
  Options();

  TranslationKeys translations = translationKeys;

  void setOptions(OptionsType options) {
    final TranslationKeys? translations = options.translations;
    if (translations != null) this.translations = translations;
  }
}

final Options options = Options();
