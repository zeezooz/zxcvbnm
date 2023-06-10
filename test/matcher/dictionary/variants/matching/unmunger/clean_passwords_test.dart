import 'package:test/test.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/matching/unmunger/clean_password.dart';
import 'package:zxcvbnm/src/matcher/dictionary/variants/matching/unmunger/trie_node.dart';

class IndexedPasswordChangesTest extends IndexedPasswordChange {
  const IndexedPasswordChangesTest({
    required String l33t,
    required String clean,
    required int i,
  }) : super(l33t: l33t, clean: clean, i: i);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is IndexedPasswordChange &&
      l33t == other.l33t &&
      clean == other.clean &&
      i == other.i;
}

class PasswordWithChangesTest extends PasswordWithChanges {
  const PasswordWithChangesTest({
    required String password,
    required List<IndexedPasswordChangesTest> changes,
  }) : super(password: password, changes: changes);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  bool operator ==(Object other) =>
      other is PasswordWithChanges &&
      password == other.password &&
      changes.join(',') == other.changes.join(',');
}

void main() {
  group('cleanPassword', () {
    final TrieNode trieNode = TrieNode.fromL33tTable(
      <String, List<String>>{
        'a': <String>['@', '4'],
        'f': <String>['v'],
        'm': <String>['^^', 'nn', '2n', r'/\/\'],
        'u': <String>['|_|', 'v'],
        'w': <String>['vv'],
        'fi': <String>['ﬁ'],
      },
    );

    test(
      'Should get correct clean passwords.',
      () => expect(
        cleanPassword(r'P4|_|$nn4rd', 100, trieNode),
        <PasswordWithChangesTest>[
          PasswordWithChangesTest(
            password: r'Pau$mard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 4,
              ),
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 5,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'Pau$m4rd',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 4,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'Pau$nnard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 6,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'Pau$nn4rd',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'Pa|_|$mard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 6,
              ),
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 7,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'Pa|_|$m4rd',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 6,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'Pa|_|$nnard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 8,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'Pa|_|$nn4rd',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4u$mard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 4,
              ),
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 5,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4u$m4rd',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 4,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4u$nnard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 6,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4u$nn4rd',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '|_|',
                clean: 'u',
                i: 2,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4|_|$mard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 6,
              ),
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 7,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4|_|$m4rd',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'nn',
                clean: 'm',
                i: 6,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4|_|$nnard',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '4',
                clean: 'a',
                i: 8,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: r'P4|_|$nn4rd',
            changes: <IndexedPasswordChangesTest>[],
          ),
        ],
      ),
    );

    test(
      'Should substitute to multiple variants correctly.',
      () => expect(
        cleanPassword('vv', 100, trieNode),
        <PasswordWithChangesTest>[
          PasswordWithChangesTest(
            password: 'w',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'vv',
                clean: 'w',
                i: 0,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'ff',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 0,
              ),
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'fu',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 0,
              ),
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'u',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'uf',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'u',
                i: 0,
              ),
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'uu',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'u',
                i: 0,
              ),
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'u',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'fv',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 0,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'uv',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'u',
                i: 0,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'vf',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'vu',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'u',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'vv',
            changes: <IndexedPasswordChangesTest>[],
          ),
        ],
      ),
    );

    test(
      'Should limit the substitutions correctly.',
      () => expect(
        cleanPassword('vv', 3, trieNode),
        <PasswordWithChangesTest>[
          PasswordWithChangesTest(
            password: 'w',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'vv',
                clean: 'w',
                i: 0,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'ff',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 0,
              ),
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'fu',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'f',
                i: 0,
              ),
              IndexedPasswordChangesTest(
                l33t: 'v',
                clean: 'u',
                i: 1,
              ),
            ],
          ),
        ],
      ),
    );

    test(
      'Should substitute to multiple symbols correctly.',
      () => expect(
        cleanPassword('p@ciﬁc', 100, trieNode),
        <PasswordWithChangesTest>[
          PasswordWithChangesTest(
            password: 'pacific',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '@',
                clean: 'a',
                i: 1,
              ),
              IndexedPasswordChangesTest(
                l33t: 'ﬁ',
                clean: 'fi',
                i: 4,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'paciﬁc',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: '@',
                clean: 'a',
                i: 1,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'p@cific',
            changes: <IndexedPasswordChangesTest>[
              IndexedPasswordChangesTest(
                l33t: 'ﬁ',
                clean: 'fi',
                i: 4,
              ),
            ],
          ),
          PasswordWithChangesTest(
            password: 'p@ciﬁc',
            changes: <IndexedPasswordChangesTest>[],
          ),
        ],
      ),
    );
  });
}
