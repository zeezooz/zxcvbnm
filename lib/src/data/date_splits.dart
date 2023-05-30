const Map<int, List<List<int>>> dateSplits = <int, List<List<int>>>{
  4: <List<int>>[
    // For length-4 strings, eg 1191 or 9111, two ways to split:
    <int>[1, 2], // 1 1 91 (2nd split starts at index 1, 3rd at index 2)
    <int>[2, 3], // 91 1 1
  ],
  5: <List<int>>[
    <int>[1, 3], // 1 11 91
    <int>[2, 3], // 11 1 91
//  <int>[2, 3], // 91 1 11    <- Duplicate previous one.
    <int>[2, 4], // 91 11 1    <- New and must be added as bug fix.
  ],
  6: <List<int>>[
    <int>[1, 2], // 1 1 1991
    <int>[2, 4], // 11 11 91
    <int>[4, 5], // 1991 1 1
  ],
  7: <List<int>>[
    <int>[1, 3], // 1 11 1991
    <int>[2, 3], // 11 1 1991
    <int>[4, 5], // 1991 1 11
    <int>[4, 6], // 1991 11 1
  ],
  8: <List<int>>[
    <int>[2, 4], // 11 11 1991
    <int>[4, 6], // 1991 11 11
  ],
};
