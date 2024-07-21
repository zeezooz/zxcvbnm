import '../languages/common/adjacency_graph.dart';
import '../languages/common/l33t_table.dart' as common;
import 'matchers/base_matcher.dart';
import 'matchers/utils/trie_node.dart';

/// Options.
class Options {
  /// Creates a new instance.
  Options({
    this.matchers = const <BaseMatcher>[],
    this.dictionaries = const <Dictionaries>{},
    this.l33tTable = common.l33tTable,
    this.graph = adjacencyGraph,
    this.useLevenshteinDistance = false,
    this.levenshteinThreshold = 2,
    this.l33tMaxSubstitutions = 512,
    this.maxLength = 256,
  });

  /// Additional matchers.
  final List<BaseMatcher> matchers;

  /// Define dictionary that should be used to check against. The matcher will
  /// search the dictionaries for similar password with l33t speak and reversed
  /// words.
  final Set<Dictionaries> dictionaries;

  RankedDictionaries? _rankedDictionaries;

  /// Ranks of words by dictionary type.
  RankedDictionaries get rankedDictionaries {
    if (_rankedDictionaries == null) _setRankedDictionaries();
    return _rankedDictionaries!;
  }

  Map<Dictionary, int>? _rankedDictionariesMaxWordSize;

  /// Maximum word length by dictionary type.
  Map<Dictionary, int> get rankedDictionariesMaxWordSize {
    if (_rankedDictionariesMaxWordSize == null) _setRankedDictionaries();
    return _rankedDictionariesMaxWordSize!;
  }

  /// Define an object with l33t substitutions. For example that an "a" can
  /// be exchanged with a "4" or a "@".
  final L33tTable l33tTable;

  TrieNode? _trieNodeRoot;

  /// A tree of l33t substitutions.
  TrieNode get trieNodeRoot =>
      _trieNodeRoot ??= TrieNode.fromL33tTable(l33tTable);

  /// Defines keyboard layouts as an object which are used to find sequences.
  final Graph graph;

  /// Defines if the levenshtein algorithm should be used. This will be only
  /// used on the complete password and not on parts of it. This will
  /// decrease the calcTime a bit but will significantly improve the password
  /// check. Default is false.
  final bool useLevenshteinDistance;

  /// Defines how many characters can be different to match a dictionary word
  /// with the levenshtein algorithm. Default is 2.
  final int levenshteinThreshold;

  /// The l33t matcher will check how many characters can be exchanged with
  /// the l33t table. If they are to many it will decrease the calcTime
  /// significantly. So we cap it at a reasonable value by default which will
  /// probably already seems like a strong password anyway. Default is 512.
  final int l33tMaxSubstitutions;

  /// Defines how many character of the password are checked. A password longer
  /// than the default are considered strong anyway, but it can be increased
  /// as pleased. Be aware that this could open some attack vectors.
  /// Default is 256.
  final int maxLength;

  /// The current year used to calculate date guesses.
  final int currentYear = DateTime.now().year;

  /// The minimum number of years used to calculate date guesses.
  int get minYearSpace => 20;

  /// Creates a new instance with updated values.
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
    dictionaries ??= this.dictionaries;
    final Set<Dictionaries> newDictionaries = <Dictionaries>{
      ...dictionaries,
      if (userInputs != null)
        <Dictionary, List<String>>{Dictionary.userInputs: userInputs},
    };
    return Options(
      matchers: matchers ?? this.matchers,
      dictionaries: newDictionaries,
      l33tTable: l33tTable ?? this.l33tTable,
      graph: graph ?? this.graph,
      useLevenshteinDistance:
          useLevenshteinDistance ?? this.useLevenshteinDistance,
      levenshteinThreshold: levenshteinThreshold ?? this.levenshteinThreshold,
      l33tMaxSubstitutions: l33tMaxSubstitutions ?? this.l33tMaxSubstitutions,
      maxLength: maxLength ?? this.maxLength,
    );
  }

  void _setRankedDictionaries() {
    final Map<Dictionary, Set<List<String>>> newDictionaries =
        <Dictionary, Set<List<String>>>{};
    for (final Dictionaries dictionary in dictionaries) {
      for (final MapEntry<Dictionary, List<String>> entry
          in dictionary.entries) {
        newDictionaries
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
    newDictionaries.forEach((Dictionary dictionary, Set<List<String>> lists) {
      rankedDictionaries[dictionary] = dictionary == Dictionary.userInputs
          ? _sanitizedRankedDictionary(lists)
          : _rankedDictionary(lists);
      rankedDictionariesMaxWordSize[dictionary] =
          _rankedDictionaryMaxWordSize(lists);
    });
    _rankedDictionaries = rankedDictionaries;
    _rankedDictionariesMaxWordSize = rankedDictionariesMaxWordSize;
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

  int _rankedDictionaryMaxWordSize(Set<List<String>> lists) {
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

/// A dictionary. Although a map can have multiple values, it's recommended to
/// store a single dictionary here.
typedef Dictionaries = Map<Dictionary, List<String>>;

/// Ranks of words.
typedef RankedDictionary = Map<String, int>;

/// Ranks of words by dictionary type.
typedef RankedDictionaries = Map<Dictionary, RankedDictionary>;

/// L33t substitutions.
typedef L33tTable = Map<String, List<String>>;

/// A keyboard layout.
typedef GraphEntry = Map<String, List<String?>>;

/// Keyboard layouts.
typedef Graph = Map<String, GraphEntry>;
