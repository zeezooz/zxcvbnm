import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/matching/unmunger/trie_node.dart';

class TrieNodeTest extends TrieNode {
  TrieNodeTest({
    String l33t = '',
    List<String>? cleanList,
    Map<String, TrieNodeTest>? children,
  }) : super(l33t: l33t, cleanList: cleanList, children: children);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) {
    if (other is! TrieNode ||
        l33t != other.l33t ||
        cleanList.join(',') != other.cleanList.join(',') ||
        children.length != other.children.length) return false;
    for (final String key in children.keys) {
      if (children[key] != other.children[key]) return false;
    }
    return true;
  }
}

void main() {
  group('L33t table to trie node.', () {
    test(
      'Should convert correctly.',
      () => expect(
        TrieNode.fromL33tTable(
          <String, List<String>>{
            'a': <String>['@', '4'],
            'f': <String>['v'],
            'm': <String>['^^', 'nn', '2n', r'/\/\'],
            'u': <String>['|_|', 'v'],
            'w': <String>['vv'],
          },
        ),
        TrieNodeTest(
          l33t: '',
          children: <String, TrieNodeTest>{
            '@': TrieNodeTest(
              l33t: '@',
              cleanList: <String>['a'],
            ),
            '4': TrieNodeTest(
              l33t: '4',
              cleanList: <String>['a'],
            ),
            'v': TrieNodeTest(
              l33t: 'v',
              cleanList: <String>['f', 'u'],
              children: <String, TrieNodeTest>{
                'v': TrieNodeTest(
                  l33t: 'vv',
                  cleanList: <String>['w'],
                ),
              },
            ),
            '^': TrieNodeTest(
              l33t: '^',
              children: <String, TrieNodeTest>{
                '^': TrieNodeTest(
                  l33t: '^^',
                  cleanList: <String>['m'],
                ),
              },
            ),
            'n': TrieNodeTest(
              l33t: 'n',
              children: <String, TrieNodeTest>{
                'n': TrieNodeTest(
                  l33t: 'nn',
                  cleanList: <String>['m'],
                ),
              },
            ),
            '2': TrieNodeTest(
              l33t: '2',
              children: <String, TrieNodeTest>{
                'n': TrieNodeTest(
                  l33t: '2n',
                  cleanList: <String>['m'],
                ),
              },
            ),
            '/': TrieNodeTest(
              l33t: '/',
              children: <String, TrieNodeTest>{
                r'\': TrieNodeTest(
                  l33t: r'/\',
                  children: <String, TrieNodeTest>{
                    '/': TrieNodeTest(
                      l33t: r'/\/',
                      children: <String, TrieNodeTest>{
                        r'\': TrieNodeTest(
                          l33t: r'/\/\',
                          cleanList: <String>['m'],
                        ),
                      },
                    ),
                  },
                ),
              },
            ),
            '|': TrieNodeTest(
              l33t: '|',
              children: <String, TrieNodeTest>{
                '_': TrieNodeTest(
                  l33t: '|_',
                  children: <String, TrieNodeTest>{
                    '|': TrieNodeTest(
                      l33t: '|_|',
                      cleanList: <String>['u'],
                    ),
                  },
                ),
              },
            ),
          },
        ),
      ),
    );
  });
}
