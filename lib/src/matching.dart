import 'dart:async';

import 'helper.dart';
import 'matcher/date/matching.dart';
import 'matcher/dictionary/matching.dart';
import 'matcher/regex/matching.dart';
import 'matcher/repeat/matching.dart';
import 'matcher/separator/matching.dart';
import 'matcher/sequence/matching.dart';
import 'matcher/spatial/matching.dart';
import 'options.dart';
import 'types.dart';

typedef Matchers = List<MatchingType>;

/// Omnimatch combine matchers.
class OmniMatch extends MatchingType {
  OmniMatch(this.options) {
    matchers = <MatchingType>[
      MatchDate(),
      MatchDictionary(options),
      MatchRegex(),
      MatchRepeat(this),
      MatchSeparator(),
      MatchSequence(),
      MatchSpatial(options),
    ];
  }

  final Options options;
  late final Matchers matchers;

  @override
  List<FutureOr<List<Match>>> match(String password) {
    final List<Match> matches = <Match>[];
    final List<Future<List<Match>>> futures = <Future<List<Match>>>[];
    final Matchers matchers = <MatchingType>[
      ...this.matchers,
      for (final Matcher matcher in options.matchers.values) matcher.matching,
    ];
    for (final MatchingType matcher in matchers) {
      final List<FutureOr<List<Match>>> result = matcher.match(password);
      matches.addAll(synchronousMatches(result));
      futures.addAll(asynchronousMatches(result));
    }
    return <FutureOr<List<Match>>>[matches, ...futures];
  }
}
