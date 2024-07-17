import 'package:intl/intl.dart';

/// Defines feedback messages for translation.
class Translation {
  /// Warnings messages.
  static const Warnings warnings = Warnings();

  /// Suggestions messages.
  static const Suggestions suggestions = Suggestions();

  /// Time estimations messages.
  static const TimeEstimations timeEstimations = TimeEstimations();
}

/// Warnings messages.
class Warnings {
  /// Const constructor.
  const Warnings();

  /// Straight keyboard sequences like "qwerty".
  String get straightRow => Intl.message(
        'Straight rows of keys on your keyboard are easy to guess.',
        name: 'Warnings_straightRow',
        desc: 'Straight keyboard sequences like "qwerty".',
      );

  /// Keyboard sequences like "qazxc".
  String get keyPattern => Intl.message(
        'Short keyboard patterns are easy to guess.',
        name: 'Warnings_keyPattern',
        desc: 'Keyboard sequences like "qazxc".',
      );

  /// Repeated characters like "aaa".
  String get simpleRepeat => Intl.message(
        'Repeated characters like "aaa" are easy to guess.',
        name: 'Warnings_simpleRepeat',
        desc: 'Repeated characters like "aaa".',
      );

  /// Repeated character patterns like "abcabcabc".
  String get extendedRepeat => Intl.message(
        'Repeated character patterns like "abcabcabc" are easy to guess.',
        name: 'Warnings_extendedRepeat',
        desc: 'Repeated character patterns like "abcabcabc".',
      );

  /// Character sequences like "abc".
  String get sequences => Intl.message(
        'Common character sequences like "abc" are easy to guess.',
        name: 'Warnings_sequences',
        desc: 'Character sequences like "abc".',
      );

  /// Recent years.
  String get recentYears => Intl.message(
        'Recent years are easy to guess.',
        name: 'Warnings_recentYears',
        desc: 'Recent years.',
      );

  /// Dates.
  String get dates => Intl.message(
        'Dates are easy to guess.',
        name: 'Warnings_dates',
        desc: 'Dates.',
      );

  /// Top 10 frequently used passwords.
  String get topTen => Intl.message(
        'This is a heavily used password.',
        name: 'Warnings_topTen',
        desc: 'Top 10 frequently used passwords.',
      );

  /// Top 100 frequently used passwords.
  String get topHundred => Intl.message(
        'This is a frequently used password.',
        name: 'Warnings_topHundred',
        desc: 'Top 100 frequently used passwords.',
      );

  /// Frequently used passwords.
  String get common => Intl.message(
        'This is a commonly used password.',
        name: 'Warnings_common',
        desc: 'Frequently used passwords.',
      );

  /// Similar to a frequently used password.
  String get similarToCommon => Intl.message(
        'This is similar to a commonly used password.',
        name: 'Warnings_similarToCommon',
        desc: 'Similar to a frequently used password.',
      );

  /// Single words.
  String get wordByItself => Intl.message(
        'Single words are easy to guess.',
        name: 'Warnings_wordByItself',
        desc: 'Single words.',
      );

  /// Single names or surnames.
  String get namesByThemselves => Intl.message(
        'Single names or surnames are easy to guess.',
        name: 'Warnings_namesByThemselves',
        desc: 'Single names or surnames.',
      );

  /// Names and surnames.
  String get commonNames => Intl.message(
        'Common names and surnames are easy to guess.',
        name: 'Warnings_commonNames',
        desc: 'Names and surnames.',
      );

  /// Words from the user dictionary.
  String get userInputs => Intl.message(
        'There should not be any personal or page related data.',
        name: 'Warnings_userInputs',
        desc: 'Words from the user dictionary.',
      );
}

/// Suggestions messages.
class Suggestions {
  /// Const constructor.
  const Suggestions();

  /// L33t words.
  String get l33t => Intl.message(
        'Avoid predictable letter substitutions like "@" for "a".',
        name: 'Suggestions_l33t',
        desc: 'L33t words.',
      );

  /// Reversed words.
  String get reverseWords => Intl.message(
        'Avoid reversed spellings of common words.',
        name: 'Suggestions_reverseWords',
        desc: 'Reversed words.',
      );

  /// All letters are capitalized.
  String get allUppercase => Intl.message(
        'Capitalize some, but not all letters.',
        name: 'Suggestions_allUppercase',
        desc: 'All letters are capitalized.',
      );

  /// The first letter is capitalized.
  String get capitalization => Intl.message(
        'Capitalize more than the first letter.',
        name: 'Suggestions_capitalization',
        desc: 'The first letter is capitalized.',
      );

  /// Dates.
  String get dates => Intl.message(
        'Avoid dates and years that are associated with you.',
        name: 'Suggestions_dates',
        desc: 'Dates.',
      );

  /// Recent years.
  String get recentYears => Intl.message(
        'Avoid recent years.',
        name: 'Suggestions_recentYears',
        desc: 'Recent years.',
      );

  /// Recent years.
  String get associatedYears => Intl.message(
        'Avoid years that are associated with you.',
        name: 'Suggestions_associatedYears',
        desc: 'Recent years.',
      );

  /// Character sequences like "abc".
  String get sequences => Intl.message(
        'Avoid common character sequences.',
        name: 'Suggestions_sequences',
        desc: 'Character sequences like "abc".',
      );

  /// Repeats.
  String get repeated => Intl.message(
        'Avoid repeated words and characters.',
        name: 'Suggestions_repeated',
        desc: 'Repeats.',
      );

  /// Keyboard sequences.
  String get longerKeyboardPattern => Intl.message(
        'Use longer keyboard patterns and change typing direction multiple '
        'times.',
        name: 'Suggestions_longerKeyboardPattern',
        desc: 'Keyboard sequences.',
      );

  /// Default suggestion.
  String get anotherWord => Intl.message(
        'Add more words that are less common.',
        name: 'Suggestions_anotherWord',
        desc: 'Default suggestion.',
      );

  /// Empty password.
  String get useWords => Intl.message(
        'Use multiple words, but avoid common phrases.',
        name: 'Suggestions_useWords',
        desc: 'Empty password.',
      );

  /// Empty password.
  String get noNeed => Intl.message(
        'You can create strong passwords without using symbols, numbers, or '
        'uppercase letters.',
        name: 'Suggestions_noNeed',
        desc: 'Empty password.',
      );
}

/// Time estimations messages.
class TimeEstimations {
  /// Const constructor.
  const TimeEstimations();

  /// Less than a second.
  String get ltSecond => Intl.message(
        'less than a second',
        name: 'TimeEstimations_ltSecond',
        desc: 'Less than a second.',
      );

  /// Seconds.
  String seconds(int number) => Intl.plural(
        number,
        one: '$number second',
        other: '$number seconds',
        name: 'TimeEstimations_seconds',
        desc: 'Seconds.',
        args: <int>[number],
      );

  /// Minutes.
  String minutes(int number) => Intl.plural(
        number,
        one: '$number minute',
        other: '$number minutes',
        name: 'TimeEstimations_minutes',
        desc: 'Minutes.',
        args: <int>[number],
      );

  /// Hours.
  String hours(int number) => Intl.plural(
        number,
        one: '$number hour',
        other: '$number hours',
        name: 'TimeEstimations_hours',
        desc: 'Hours.',
        args: <int>[number],
      );

  /// Days.
  String days(int number) => Intl.plural(
        number,
        one: '$number day',
        other: '$number days',
        name: 'TimeEstimations_days',
        desc: 'Days.',
        args: <int>[number],
      );

  /// Months.
  String months(int number) => Intl.plural(
        number,
        one: '$number month',
        other: '$number months',
        name: 'TimeEstimations_months',
        desc: 'Months.',
        args: <int>[number],
      );

  /// Years.
  String years(int number) => Intl.plural(
        number,
        one: '$number year',
        other: '$number years',
        name: 'TimeEstimations_years',
        desc: 'Years.',
        args: <int>[number],
      );

  /// Centuries.
  String get centuries => Intl.message(
        'centuries',
        name: 'TimeEstimations_centuries',
        desc: 'Centuries.',
      );

  /// Format the time estimation from [period] and [number].
  String displayTime(TimeEstimationsPeriod period, int number) {
    switch (period) {
      case TimeEstimationsPeriod.ltSecond:
        return ltSecond;
      case TimeEstimationsPeriod.seconds:
        return seconds(number);
      case TimeEstimationsPeriod.minutes:
        return minutes(number);
      case TimeEstimationsPeriod.hours:
        return hours(number);
      case TimeEstimationsPeriod.days:
        return days(number);
      case TimeEstimationsPeriod.months:
        return months(number);
      case TimeEstimationsPeriod.years:
        return years(number);
      case TimeEstimationsPeriod.centuries:
        return centuries;
    }
  }
}

/// Periods for time estimation.
enum TimeEstimationsPeriod {
  /// Less than a second.
  ltSecond,

  /// Seconds.
  seconds,

  /// Minutes.
  minutes,

  /// Hours.
  hours,

  /// Days.
  days,

  /// Months.
  months,

  /// Years.
  years,

  /// Centuries.
  centuries,
}
