import 'dart:async';

import 'helper.dart';
import 'matcher/dictionary/matching.dart';
import 'matcher/separator/matching.dart';
import 'matcher/sequence/matching.dart';
import 'matcher/spatial/matching.dart';
import 'matchers/base_matcher.dart';
import 'matchers/date_matcher.dart';
import 'matchers/reg_ex_matcher.dart';
import 'matchers/repeat_matcher.dart';
import 'options.dart';

typedef Matchers = List<BaseMatcher>;

/// All matchers combined.
class OmniMatcher extends BaseMatcher {
  OmniMatcher(this.options) {
    matchers = <BaseMatcher>[
      DateMatcher(options),
      MatchDictionary(options),
      RegExMatcher(options),
      RepeatMatcher(this),
      MatchSeparator(),
      MatchSequence(options),
      MatchSpatial(options),
    ];
  }

  final Options options;
  late final Matchers matchers;

  @override
  List<FutureOr<List<BaseMatch>>> match(String password) {
    final List<BaseMatch> matches = <BaseMatch>[];
    final List<Future<List<BaseMatch>>> futures = <Future<List<BaseMatch>>>[];
    final Matchers matchers = <BaseMatcher>[
      ...this.matchers,
      ...options.matchers,
    ];
    for (final BaseMatcher matcher in matchers) {
      final List<FutureOr<List<BaseMatch>>> result = matcher.match(password);
      matches.addAll(synchronousMatches(result));
      futures.addAll(asynchronousMatches(result));
    }
    return <FutureOr<List<BaseMatch>>>[matches, ...futures];
  }
}
