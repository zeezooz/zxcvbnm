import 'dart:async';

import 'helper.dart';
import 'matchers/base_matcher.dart';
import 'matchers/date_matcher.dart';
import 'matchers/dictionary_matcher.dart';
import 'matchers/l33t_matcher.dart';
import 'matchers/reg_ex_matcher.dart';
import 'matchers/repeat_matcher.dart';
import 'matchers/reverse_matcher.dart';
import 'matchers/separator_matcher.dart';
import 'matchers/sequence_matcher.dart';
import 'matchers/spatial_matcher.dart';
import 'options.dart';

/// All matchers combined.
class OmniMatcher extends BaseMatcher {
  /// Creates a new instance.
  OmniMatcher(this.options) {
    final DictionaryMatcher dictionaryMatcher = DictionaryMatcher(options);
    matchers = <BaseMatcher>[
      DateMatcher(options),
      dictionaryMatcher,
      L33tMatcher(options, dictionaryMatcher),
      RegExMatcher(options),
      RepeatMatcher(this),
      ReverseMatcher(dictionaryMatcher),
      SeparatorMatcher(),
      SequenceMatcher(),
      SpatialMatcher(options),
    ];
  }

  /// Options.
  final Options options;

  /// Matchers used.
  late final List<BaseMatcher> matchers;

  @override
  List<FutureOr<List<BaseMatch>>> match(String password) {
    final List<BaseMatch> matches = <BaseMatch>[];
    final List<Future<List<BaseMatch>>> futures = <Future<List<BaseMatch>>>[];
    final List<BaseMatcher> matchers = <BaseMatcher>[
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
