import 'dart:async';

import 'helper.dart';
import 'matcher/date/matching.dart';
import 'matcher/dictionary/matching.dart';
import 'matcher/regex/matching.dart';
import 'matcher/repeat/matching.dart';
import 'matcher/separator/matching.dart';
import 'options.dart';
import 'types.dart';

typedef Matchers = List<MatchingType>;

/// Omnimatch combine matchers.
class OmniMatch {
  OmniMatch(this.options) {
    matchers = <MatchingType>[
      MatchDate(),
      MatchDictionary(options),
      MatchRegex(),
      MatchRepeat(this),
      MatchSeparator(),
      // MatchSequence(),
      // MatchSpatial(),
    ];
  }

  final Options options;
  late final Matchers matchers;

  FutureOr<List<Match>> match(String password) async {
    final List<Match> matches = <Match>[];
    final List<Future<List<Match>>> futures = <Future<List<Match>>>[];
    final Matchers matchers = <MatchingType>[
      ...this.matchers,
      for (final Matcher matcher in options.matchers.values) matcher.matching,
    ];
    for (final MatchingType matcher in matchers) {
      final FutureOr<List<Match>> result = matcher.match(password);
      if (result is Future<List<Match>>) {
        futures.add(result);
      } else {
        matches.addAll(result);
      }
    }
    if (futures.isNotEmpty) {
      final List<List<Match>> results =
          await Future.wait(futures, eagerError: true);
      for (final List<Match> result in results) {
        matches.addAll(result);
      }
    }
    sort(matches);
    return matches;
  }
}
