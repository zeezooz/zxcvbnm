import 'dart:async';

import 'matchers/base_matcher.dart';

List<BaseMatch> synchronousMatches(List<FutureOr<List<BaseMatch>>> matches) {
  final List<BaseMatch> result = <BaseMatch>[];
  for (final FutureOr<List<BaseMatch>> item in matches) {
    if (item is List<BaseMatch>) result.addAll(item);
  }
  return result;
}

List<Future<List<BaseMatch>>> asynchronousMatches(
  List<FutureOr<List<BaseMatch>>> matches,
) {
  final List<Future<List<BaseMatch>>> result = <Future<List<BaseMatch>>>[];
  for (final FutureOr<List<BaseMatch>> item in matches) {
    if (item is Future<List<BaseMatch>>) result.add(item);
  }
  return result;
}
