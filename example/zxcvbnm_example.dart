// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:zxcvbnm/languages/en.dart' as en;
import 'package:zxcvbnm/languages/es_es.dart' as es;
import 'package:zxcvbnm/messages.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

Future<void> main() async {
  const String localeName = 'es';
  await initializeZxcvbnmMessages(localeName);
  Intl.defaultLocale = localeName;
  final Zxcvbnm zxcvbnm = Zxcvbnm(
    Options(
      dictionaries: <Dictionaries>{
        ...en.dictionaries,
        if (localeName == 'es') ...es.dictionaries,
      },
    ),
  );
  final Result result = zxcvbnm('password');
  print('score: ${result.score}/4');
  print('guesses: ${result.guesses}');
  print('guessesLog10: ${result.guessesLog10}');
  print('warning: ${result.feedback.warning ?? ''}');
  print('suggestions: ${result.feedback.suggestions.join(' ')}');
  print(
    'onlineThrottling100PerHour: '
    '${result.crackTimesSeconds.onlineThrottling100PerHour} '
    '(${result.crackTimesDisplay.onlineThrottling100PerHour})',
  );
  print(
    'onlineNoThrottling10PerSecond: '
    '${result.crackTimesSeconds.onlineNoThrottling10PerSecond} '
    '(${result.crackTimesDisplay.onlineNoThrottling10PerSecond})',
  );
  print(
    'offlineSlowHashing1e4PerSecond: '
    '${result.crackTimesSeconds.offlineSlowHashing1e4PerSecond} '
    '(${result.crackTimesDisplay.offlineSlowHashing1e4PerSecond})',
  );
  print(
    'offlineFastHashing1e10PerSecond: '
    '${result.crackTimesSeconds.offlineFastHashing1e10PerSecond} '
    '(${result.crackTimesDisplay.offlineFastHashing1e10PerSecond})',
  );
}
