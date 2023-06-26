import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/src/time_estimates.dart';
import 'package:zxcvbnm/src/types.dart';

class AttackTimesTest extends AttackTimes {
  AttackTimesTest({
    required CrackTimesSeconds crackTimesSeconds,
    required CrackTimesDisplay crackTimesDisplay,
    required int score,
  }) : super(
          crackTimesSeconds: crackTimesSeconds,
          crackTimesDisplay: crackTimesDisplay,
          score: score,
        );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is AttackTimes &&
      crackTimesSeconds.onlineThrottling100PerHour ==
          other.crackTimesSeconds.onlineThrottling100PerHour &&
      crackTimesSeconds.onlineNoThrottling10PerSecond ==
          other.crackTimesSeconds.onlineNoThrottling10PerSecond &&
      crackTimesSeconds.offlineSlowHashing1e4PerSecond ==
          other.crackTimesSeconds.offlineSlowHashing1e4PerSecond &&
      crackTimesSeconds.offlineFastHashing1e10PerSecond ==
          other.crackTimesSeconds.offlineFastHashing1e10PerSecond &&
      crackTimesDisplay.onlineThrottling100PerHour ==
          other.crackTimesDisplay.onlineThrottling100PerHour &&
      crackTimesDisplay.onlineNoThrottling10PerSecond ==
          other.crackTimesDisplay.onlineNoThrottling10PerSecond &&
      crackTimesDisplay.offlineSlowHashing1e4PerSecond ==
          other.crackTimesDisplay.offlineSlowHashing1e4PerSecond &&
      crackTimesDisplay.offlineFastHashing1e10PerSecond ==
          other.crackTimesDisplay.offlineFastHashing1e10PerSecond &&
      score == other.score;
}

void main() {
  group('Time estimates.', () {
    final Options options = Options(translation: translation);
    final TimeEstimates timeEstimates = TimeEstimates(options);

    test(
      'Should be very weak.',
      () => expect(
        timeEstimates.estimateAttackTimes(10),
        AttackTimesTest(
          crackTimesSeconds: CrackTimesSeconds(
            onlineThrottling100PerHour: 360,
            onlineNoThrottling10PerSecond: 1,
            offlineSlowHashing1e4PerSecond: 0.001,
            offlineFastHashing1e10PerSecond: 1e-9,
          ),
          crackTimesDisplay: CrackTimesDisplay(
            onlineThrottling100PerHour: '6 minutes',
            onlineNoThrottling10PerSecond: '1 second',
            offlineSlowHashing1e4PerSecond: 'less than a second',
            offlineFastHashing1e10PerSecond: 'less than a second',
          ),
          score: 0,
        ),
      ),
    );

    test(
      'Should be weak.',
      () => expect(
        timeEstimates.estimateAttackTimes(100000),
        AttackTimesTest(
          crackTimesSeconds: CrackTimesSeconds(
            onlineThrottling100PerHour: 3600000,
            onlineNoThrottling10PerSecond: 10000,
            offlineSlowHashing1e4PerSecond: 10,
            offlineFastHashing1e10PerSecond: 0.00001,
          ),
          crackTimesDisplay: CrackTimesDisplay(
            onlineThrottling100PerHour: '1 month',
            onlineNoThrottling10PerSecond: '3 hours',
            offlineSlowHashing1e4PerSecond: '10 seconds',
            offlineFastHashing1e10PerSecond: 'less than a second',
          ),
          score: 1,
        ),
      ),
    );

    test(
      'Should be good.',
      () => expect(
        timeEstimates.estimateAttackTimes(10000000),
        AttackTimesTest(
          crackTimesSeconds: CrackTimesSeconds(
            onlineThrottling100PerHour: 360000000,
            onlineNoThrottling10PerSecond: 1000000,
            offlineSlowHashing1e4PerSecond: 1000,
            offlineFastHashing1e10PerSecond: 0.001,
          ),
          crackTimesDisplay: CrackTimesDisplay(
            onlineThrottling100PerHour: '11 years',
            onlineNoThrottling10PerSecond: '12 days',
            offlineSlowHashing1e4PerSecond: '17 minutes',
            offlineFastHashing1e10PerSecond: 'less than a second',
          ),
          score: 2,
        ),
      ),
    );

    test(
      'Should be very good.',
      () => expect(
        timeEstimates.estimateAttackTimes(1000000000),
        AttackTimesTest(
          crackTimesSeconds: CrackTimesSeconds(
            onlineThrottling100PerHour: 36000000000,
            onlineNoThrottling10PerSecond: 100000000,
            offlineSlowHashing1e4PerSecond: 100000,
            offlineFastHashing1e10PerSecond: 0.1,
          ),
          crackTimesDisplay: CrackTimesDisplay(
            onlineThrottling100PerHour: 'centuries',
            onlineNoThrottling10PerSecond: '3 years',
            offlineSlowHashing1e4PerSecond: '1 day',
            offlineFastHashing1e10PerSecond: 'less than a second',
          ),
          score: 3,
        ),
      ),
    );

    test(
      'Should be excellent.',
      () => expect(
        timeEstimates.estimateAttackTimes(100000000000),
        AttackTimesTest(
          crackTimesSeconds: CrackTimesSeconds(
            onlineThrottling100PerHour: 3600000000000,
            onlineNoThrottling10PerSecond: 10000000000,
            offlineSlowHashing1e4PerSecond: 10000000,
            offlineFastHashing1e10PerSecond: 10,
          ),
          crackTimesDisplay: CrackTimesDisplay(
            onlineThrottling100PerHour: 'centuries',
            onlineNoThrottling10PerSecond: 'centuries',
            offlineSlowHashing1e4PerSecond: '4 months',
            offlineFastHashing1e10PerSecond: '10 seconds',
          ),
          score: 4,
        ),
      ),
    );
  });
}
