import 'dart:async';

import 'types.dart';

List<Match> synchronousMatches(List<FutureOr<List<Match>>> matches) {
  final List<Match> result = <Match>[];
  for (final FutureOr<List<Match>> item in matches) {
    if (item is List<Match>) result.addAll(item);
  }
  return result;
}

List<Future<List<Match>>> asynchronousMatches(
  List<FutureOr<List<Match>>> matches,
) {
  final List<Future<List<Match>>> result = <Future<List<Match>>>[];
  for (final FutureOr<List<Match>> item in matches) {
    if (item is Future<List<Match>>) result.add(item);
  }
  return result;
}
