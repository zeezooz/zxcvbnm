import 'package:test/test.dart';
import 'package:zxcvbnm/languages/en.dart';
import 'package:zxcvbnm/src/feedback.dart';
import 'package:zxcvbnm/src/matchers/base_matcher.dart';
import 'package:zxcvbnm/src/options.dart';
import 'package:zxcvbnm/zxcvbnm.dart';

void main() {
  group('Async matcher.', () {
    final Options options = Options(
      translation: translation,
      matchers: <BaseMatcher>[MatchAsync()],
      dictionaries: dictionaries,
      graph: adjacencyGraph,
    );
    final Zxcvbnm zxcvbnm = Zxcvbnm(options);

    test(
      'Should use async matcher as a future.',
      () async => expect(
        zxcvbnm.async('ep8fkw8ds'),
        completes,
      ),
    );

    test(
      'Should throw an error for wrong function usage.',
      () => expect(
        () => zxcvbnm('ep8fkw8ds'),
        throwsUnsupportedError,
      ),
    );
  });
}

class MatchAsync extends BaseMatcher {
  @override
  List<Future<List<BaseMatch>>> match(String password) {
    return <Future<List<BaseMatch>>>[
      Future<List<BaseMatch>>.delayed(
        Duration(seconds: 2),
        () => <BaseMatch>[
          AsyncMatch(
            password: password,
            start: 0,
            end: password.length,
          ),
        ],
      ),
    ];
  }
}

class AsyncMatch extends BaseMatch {
  AsyncMatch({
    required String password,
    required int start,
    required int end,
  }) : super(password: password, start: start, end: end);

  @override
  double get estimatedGuesses => length * 10;

  @override
  Feedback? feedback({required bool isSoleMatch}) {
    return Feedback(warning: 'So async.');
  }
}
