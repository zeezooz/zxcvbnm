import '../../types.dart';

typedef DefaultMatch = List<DictionaryMatch> Function(
  String password, {
  bool useLevenshtein,
});
