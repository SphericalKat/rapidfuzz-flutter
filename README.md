# rapidfuzz

A Flutter wrapper around the [rapidfuzz](https://github.com/maxbachmann/rapidfuzz) library.

## Usage

### Installation
```bash
flutter pub add rapidfuzz
```

### Import
```dart
import 'package:rapidfuzz/rapidfuzz.dart';
```

## Algorithms

### Ratio
Calculates a Levenshtein simple ratio between the strings
This indicates a measure of similarity

```dart
ratio("this is a test", "this is a test!") // 96.55171966552734
```
### Partial Ratio
Inconsistent substrings lead to problems in matching.
This ratio uses a heuristic called "best partial" for when two strings are
of noticeably different lengths.

```dart
partialRatio("this is a test", "this is a test!") // 100
```

### Token Sort Ratio
Find all alphanumeric tokens in the string and sort these tokens
and then take ratio of resulting joined strings.

```dart
ratio("fuzzy wuzzy was a bear", "wuzzy fuzzy was a bear") // 90.90908813476562
tokenSortRatio("fuzzy wuzzy was a bear", "wuzzy fuzzy was a bear") // 100
```

### Token Set Ratio
Splits the strings into tokens and computes intersections and remainders
between the tokens of the two strings. A comparison string is then
built up and is compared using the simple ratio algorithm.

```dart
tokenSortRatio("fuzzy was a bear", "fuzzy fuzzy was a bear") // 83.8709716796875
tokenSetRatio("fuzzy was a bear", "fuzzy fuzzy was a bear") // 100
```

### Weighted Ratio
Calculates a weighted ratio between [s1] and [s2] using the best option from
the above fuzzy matching algorithms

```dart
weightedRatio("The quick brown fox jimps ofver the small lazy dog", "the quick brown fox jumps over the small lazy dog") // 97
```

## Extraction
It is often more useful to extract the most similar strings from a list of strings than to calculate the ratio between two strings.

```dart
extractOne(
  query: 'cowboys',
  choices: [
    'Atlanta Falcons',
    'New York Jets',
    'New York Giants',
    'Dallas Cowboys'
  ],
  cutoff: 10,
) // (string Dallas Cowboys, score: 90, index: 3)
```

```dart
extractTop(
  query: 'goolge',
  choices: [
    'google',
    'bing',
    'facebook',
    'linkedin',
    'twitter',
    'googleplus',
    'bingnews',
    'plexoogl'
  ],
  limit: 4,
  cutoff: 50,
) // [(string google, score: 83, index: 0), (string googleplus, score: 75, index: 5)]
```
```dart
extractAllSorted(
  query: 'goolge',
  choices: [
    'google',
    'bing',
    'facebook',
    'linkedin',
    'twitter',
    'googleplus',
    'bingnews',
    'plexoogl'
  ],
  cutoff: 10,
) // [(string google, score: 83, index: 0), (string googleplus, score: 75, index: 5), (string plexoogl, score: 43, index: 7), (string bingnews, score: 29, index: 6), (string linkedin, score: 29, index: 3), (string facebook, score: 29, index: 2), (string bing, score: 23, index: 1), (string twitter, score: 15, index: 4)]
```
```dart
extractAll(
  query: 'goolge',
  choices: [
    'google',
    'bing',
    'facebook',
    'linkedin',
    'twitter',
    'googleplus',
    'bingnews',
    'plexoogl'
  ],
  cutoff: 10,
) // [(string google, score: 83, index: 0), (string bing, score: 23, index: 1), (string facebook, score: 29, index: 2), (string linkedin, score: 29, index: 3), (string twitter, score: 15, index: 4), (string googleplus, score: 75, index: 5), (string bingnews, score: 29, index: 6), (string plexoogl, score: 43, index: 7)]
```
### Extract using any a list of any type
All `extract` methods can receive `List<T>` and return `List<ExtractedResult<T>>`
```dart
class TestContainer {
  final String innerVal;
  TestContainer(this.innerVal);
}

extractOne<TestContainer>(
  query: 'cowboys',
  choices: [
    'Atlanta Falcons',
    'New York Jets',
    'New York Giants',
    'Dallas Cowboys'
  ].map((e) => TestContainer(e)).toList(),
  cutoff: 10,
  getter: (x) => x.innerVal
).toString(); // (string Dallas Cowboys, score: 90, index: 3)
```
