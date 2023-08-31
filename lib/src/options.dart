import 'data/l33t_table.dart';
import 'data/translation_keys.dart';
import 'matcher/dictionary/variants/matching/unmunger/trie_node.dart';
import 'matchers/base_matcher.dart';
import 'types.dart';

class Options {
  Options({
    this.translation = translationKeys,
    List<BaseMatcher>? matchers,
    Dictionaries? dictionaries,
    L33tTable? l33tTable,
    this.graph = const <String, GraphEntry>{},
    this.useLevenshteinDistance = false,
    this.levenshteinThreshold = 2,
    this.l33tMaxSubstitutions = 512,
    this.maxLength = 256,
  })  : matchers = matchers ?? <BaseMatcher>[],
        _dictionaries = dictionaries ?? <Dictionary, List<Object>>{},
        _l33tTable = l33tTable ?? l33tTableDefault,
        _trieNodeRoot = TrieNode.fromL33tTable(l33tTable ?? l33tTableDefault) {
    _setRankedDictionaries();
  }

  /// Defines an object with a key value match to translate the feedback
  /// given by this library. The default values are plain keys so that you
  /// can use your own i18n library. Already implemented language can be
  /// found with something like @zxcvbn-ts/language-en.
  Translation translation;

  final List<BaseMatcher> matchers;

  /// Define dictionary that should be used to check against. The matcher will
  /// search the dictionaries for similar password with l33t speak and reversed
  /// words. The recommended sets are found in @zxcvbn-ts/language-common and
  /// @zxcvbn-ts/language-en.
  Dictionaries _dictionaries;

  Dictionaries get dictionaries => _dictionaries;

  set dictionaries(Dictionaries value) {
    _dictionaries = value;
    _setRankedDictionaries();
  }

  RankedDictionaries rankedDictionaries = <Dictionary, RankedDictionary>{};

  Map<Dictionary, int> rankedDictionariesMaxWordSize = <Dictionary, int>{};

  /// Define an object with l33t substitutions. For example that an "a" can
  /// be exchanged with a "4" or a "@".
  L33tTable _l33tTable;

  L33tTable get l33tTable => _l33tTable;

  set l33tTable(L33tTable value) {
    _l33tTable = value;
    _trieNodeRoot = TrieNode.fromL33tTable(_l33tTable);
  }

  TrieNode _trieNodeRoot;

  TrieNode get trieNodeRoot => _trieNodeRoot;

  /// Defines keyboard layouts as an object which are used to find sequences.
  /// Already implemented layouts can be found in @zxcvbn-ts/language-common.
  Graph graph;

  /// Defines if the levenshtein algorithm should be used. This will be only
  /// used on the complete password and not on parts of it. This will
  /// decrease the calcTime a bit but will significantly improve the password
  /// check. The recommended sets are found in @zxcvbn-ts/language-common
  /// and @zxcvbn-ts/language-en.
  /// Default is false.
  bool useLevenshteinDistance;

  /// Defines how many characters can be different to match a dictionary word
  /// with the levenshtein algorithm.
  /// Default is 2.
  int levenshteinThreshold;

  /// The l33t matcher will check how many characters can be exchanged with
  /// the l33t table. If they are to many it will decrease the calcTime
  /// significantly. So we cap it at a reasonable value by default which will
  /// probably already seems like a strong password anyway.
  /// Default is 512.
  int l33tMaxSubstitutions;

  /// Defines how many character of the password are checked. A password longer
  /// than the default are considered strong anyway, but it can be increased
  /// as pleased. Be aware that this could open some attack vectors.
  /// Default is 256.
  int maxLength;

  /// The current year used to calculate date guesses.
  final int currentYear = DateTime.now().year;

  /// The minimum number of years used to calculate date guesses.
  int get minYearSpace => 20;

  Options copyWith({
    Translation? translation,
    List<BaseMatcher>? matchers,
    Dictionaries? dictionaries,
    List<Object>? userInputs,
    L33tTable? l33tTable,
    Graph? graph,
    bool? useLevenshteinDistance,
    int? levenshteinThreshold,
    int? l33tMaxSubstitutions,
    int? maxLength,
  }) {
    dictionaries ??= _dictionaries;
    final Dictionaries newDictionaries = <Dictionary, List<Object>>{
      ...dictionaries,
      if (userInputs != null)
        Dictionary.userInputs: <Object>[
          ...?dictionaries[Dictionary.userInputs],
          ...userInputs,
        ],
    };
    return Options(
      translation: translation ?? this.translation,
      matchers: matchers ?? this.matchers,
      dictionaries: newDictionaries,
      l33tTable: l33tTable ?? _l33tTable,
      graph: graph ?? this.graph,
      useLevenshteinDistance:
          useLevenshteinDistance ?? this.useLevenshteinDistance,
      levenshteinThreshold: levenshteinThreshold ?? this.levenshteinThreshold,
      l33tMaxSubstitutions: l33tMaxSubstitutions ?? this.l33tMaxSubstitutions,
      maxLength: maxLength ?? this.maxLength,
    );
  }

  void extendUserInputsDictionary(List<Object> list) {
    final List<Object> newList = <Object>[
      ...?dictionaries[Dictionary.userInputs],
      ...list,
    ];
    rankedDictionaries[Dictionary.userInputs] =
        _sanitizedRankedDictionary(newList);
    rankedDictionariesMaxWordSize[Dictionary.userInputs] =
        _rankedDictionariesMaxWordSize(newList);
  }

  RankedDictionary _sanitizedRankedDictionary(List<Object> list) {
    final List<String> sanitizedInputs = <String>[
      for (final Object input in list)
        if (input is String || input is num || input is bool)
          input.toString().toLowerCase(),
    ];
    return _rankedDictionary(sanitizedInputs);
  }

  void _setRankedDictionaries() {
    final RankedDictionaries rankedDictionaries =
        <Dictionary, RankedDictionary>{};
    final Map<Dictionary, int> rankedDictionariesMaxWordSize =
        <Dictionary, int>{};
    _dictionaries.forEach((Dictionary dictionary, List<Object> list) {
      rankedDictionaries[dictionary] = dictionary == Dictionary.userInputs
          ? _sanitizedRankedDictionary(list)
          : _rankedDictionary(list);
      rankedDictionariesMaxWordSize[dictionary] =
          _rankedDictionariesMaxWordSize(list);
    });
    this.rankedDictionaries = rankedDictionaries;
    this.rankedDictionariesMaxWordSize = rankedDictionariesMaxWordSize;
  }

  RankedDictionary _rankedDictionary(List<Object> list) {
    final RankedDictionary result = <String, int>{};
    // Rank starts at 1, not 0.
    int rank = 1;
    for (Object word in list) {
      if (word is! String) word = word.toString();
      result[word] = rank++;
    }
    return result;
  }

  int _rankedDictionariesMaxWordSize(List<Object> list) {
    int result = 0;
    for (final Object entry in list) {
      final int length =
          entry is String ? entry.length : entry.toString().length;
      if (length > result) result = length;
    }
    return result;
  }
}
