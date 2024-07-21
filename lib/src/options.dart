import '../languages/common/adjacency_graph.dart';
import '../languages/common/l33t_table.dart' as common;
import 'matchers/base_matcher.dart';
import 'matchers/utils/trie_node.dart';

class Options {
  Options({
    List<BaseMatcher>? matchers,
    Set<Dictionaries>? dictionaries,
    L33tTable? l33tTable,
    this.graph = adjacencyGraph,
    this.useLevenshteinDistance = false,
    this.levenshteinThreshold = 2,
    this.l33tMaxSubstitutions = 512,
    this.maxLength = 256,
  })  : matchers = matchers ?? <BaseMatcher>[],
        _dictionaries = dictionaries ?? <Dictionaries>{},
        _l33tTable = l33tTable ?? common.l33tTable,
        _trieNodeRoot = TrieNode.fromL33tTable(l33tTable ?? common.l33tTable) {
    _setRankedDictionaries();
  }

  final List<BaseMatcher> matchers;

  /// Define dictionary that should be used to check against. The matcher will
  /// search the dictionaries for similar password with l33t speak and reversed
  /// words. The recommended sets are found in @zxcvbn-ts/language-common and
  /// @zxcvbn-ts/language-en.
  Set<Dictionaries> _dictionaries;

  Set<Dictionaries> get dictionaries => _dictionaries;

  set dictionaries(Set<Dictionaries> value) {
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
    List<BaseMatcher>? matchers,
    Set<Dictionaries>? dictionaries,
    List<String>? userInputs,
    L33tTable? l33tTable,
    Graph? graph,
    bool? useLevenshteinDistance,
    int? levenshteinThreshold,
    int? l33tMaxSubstitutions,
    int? maxLength,
  }) {
    dictionaries ??= _dictionaries;
    final Set<Dictionaries> newDictionaries = <Dictionaries>{
      ...dictionaries,
      if (userInputs != null)
        <Dictionary, List<String>>{Dictionary.userInputs: userInputs},
    };
    return Options(
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

  void extendUserInputsDictionary(Set<List<String>> lists) {
    final Set<List<String>> newList = <List<String>>{
      for (final Dictionaries dictionary in _dictionaries)
        if (dictionary.containsKey(Dictionary.userInputs))
          dictionary[Dictionary.userInputs]!,
      ...lists,
    };
    rankedDictionaries[Dictionary.userInputs] =
        _sanitizedRankedDictionary(newList);
    rankedDictionariesMaxWordSize[Dictionary.userInputs] =
        _rankedDictionariesMaxWordSize(newList);
  }

  RankedDictionary _sanitizedRankedDictionary(Set<List<String>> lists) {
    final Set<List<String>> sanitizedInputs = <List<String>>{
      for (final List<String> list in lists)
        <String>[
          for (final String input in list) input.toLowerCase(),
        ],
    };
    return _rankedDictionary(sanitizedInputs);
  }

  void _setRankedDictionaries() {
    final Map<Dictionary, Set<List<String>>> dictionaries =
        <Dictionary, Set<List<String>>>{};
    for (final Dictionaries dictionary in _dictionaries) {
      for (final MapEntry<Dictionary, List<String>> entry
          in dictionary.entries) {
        dictionaries
            .putIfAbsent(
              entry.key,
              () => <List<String>>{},
            )
            .add(entry.value);
      }
    }
    final RankedDictionaries rankedDictionaries =
        <Dictionary, RankedDictionary>{};
    final Map<Dictionary, int> rankedDictionariesMaxWordSize =
        <Dictionary, int>{};
    dictionaries.forEach((Dictionary dictionary, Set<List<String>> lists) {
      rankedDictionaries[dictionary] = dictionary == Dictionary.userInputs
          ? _sanitizedRankedDictionary(lists)
          : _rankedDictionary(lists);
      rankedDictionariesMaxWordSize[dictionary] =
          _rankedDictionariesMaxWordSize(lists);
    });
    this.rankedDictionaries = rankedDictionaries;
    this.rankedDictionariesMaxWordSize = rankedDictionariesMaxWordSize;
  }

  RankedDictionary _rankedDictionary(Set<List<String>> lists) {
    final RankedDictionary result = <String, int>{};
    for (final List<String> list in lists) {
      // Rank starts at 1, not 0.
      int rank = 1;
      for (Object word in list) {
        if (word is! String) word = word.toString();
        if (!result.containsKey(word) || result[word]! > rank) {
          result[word] = rank;
        }
        rank++;
      }
    }
    return result;
  }

  int _rankedDictionariesMaxWordSize(Set<List<String>> lists) {
    int result = 0;
    for (final List<String> list in lists) {
      for (final Object entry in list) {
        final int length =
            entry is String ? entry.length : entry.toString().length;
        if (length > result) result = length;
      }
    }
    return result;
  }
}

/// Types of dictionaries.
enum Dictionary {
  /// The dictionary used to generate a password by rolling dice.
  /// https://en.wikipedia.org/wiki/Diceware
  diceware,

  /// The most often used passwords.
  passwords,

  /// The most often used words.
  commonWords,

  /// The most common names.
  names,

  /// The most often used words from Wikipedia.
  wikipedia,

  /// The optional user dictionary.
  userInputs,
}

typedef Dictionaries = Map<Dictionary, List<String>>;

typedef RankedDictionary = Map<String, int>;

typedef RankedDictionaries = Map<Dictionary, RankedDictionary>;

typedef L33tTable = Map<String, List<String>>;

typedef GraphEntry = Map<String, List<String?>>;

typedef Graph = Map<String, GraphEntry>;
