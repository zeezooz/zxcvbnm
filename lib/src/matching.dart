import 'dart:async';

import 'helper.dart';
import 'matcher/date/matching.dart';
import 'matcher/dictionary/matching.dart';
import 'matcher/regex/matching.dart';
import 'matcher/repeat/matching.dart';
import 'matcher/separator/matching.dart';
import 'matcher/sequence/matching.dart';
import 'matcher/spatial/matching.dart';
import 'matchers/base_matcher.dart';
import 'options.dart';

typedef Matchers = List<BaseMatcher>;

/// Omnimatch combine matchers.
class OmniMatch extends BaseMatcher {
  OmniMatch(this.options) {
    matchers = <BaseMatcher>[
      MatchDate(options),
      MatchDictionary(options),
      MatchRegex(options),
      MatchRepeat(options, this),
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
