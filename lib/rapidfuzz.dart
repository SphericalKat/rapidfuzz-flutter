import 'package:rapidfuzz/algorithms/token_set.dart' as token_set;
import 'package:rapidfuzz/algorithms/token_sort.dart' as token_sort;
import 'package:rapidfuzz/algorithms/weighted_ratio.dart';
import 'package:rapidfuzz/applicable.dart';
import 'package:rapidfuzz/extraction.dart';
import 'package:rapidfuzz/models/extracted_result.dart';
import 'package:rapidfuzz/algorithms/core.dart' as core;

/// Calculates a Levenshtein simple ratio between the strings
/// This indicates a measure of similarity
double ratio(String str1, String str2, {double scoreCutoff = 0.0}) {
  return core.ratio(str1, str2, scoreCutoff: scoreCutoff);
}

/// Inconsistent substrings lead to problems in matching.
/// This ratio uses a heuristic called "best partial" for when two strings are
/// of noticeably different lengths.
double partialRatio(String str1, String str2, {double scoreCutoff = 0.0}) {
  return core.partialRatio(str1, str2, scoreCutoff: scoreCutoff);
}

/// Find all alphanumeric tokens in the string and sort these tokens
/// and then take ratio of resulting joined strings.
double tokenSortRatio(String str1, String str2, {double scoreCutoff = 0.0}) {
  // Call the function from token_sort.dart to prevent recursion
  return token_sort.tokenSortRatio(str1, str2, scoreCutoff: scoreCutoff);
}

/// Find all alphanumeric tokens in the string and sort these tokens
/// and then take partial ratio of resulting joined strings.
double tokenSortPartialRatio(
  String str1,
  String str2, {
  double scoreCutoff = 0.0,
}) {
  // Call the function from token_sort.dart to prevent recursion
  return token_sort.tokenSortPartialRatio(str1, str2, scoreCutoff: scoreCutoff);
}

/// Splits the strings into tokens and computes intersections and remainders
/// between the tokens of the two strings. A comparison string is then
/// built up and is compared using the simple ratio algorithm.
/// Useful for strings where words appear redundantly.
double tokenSetRatio(String str1, String str2, {double scoreCutoff = 0.0}) {
  // Call the function from token_set.dart to prevent recursion
  return token_set.tokenSetRatio(str1, str2, scoreCutoff: scoreCutoff);
}

/// Splits the strings into tokens and computes intersections and remainders
/// between the tokens of the two strings. A comparison string is then
/// built up and is compared using the partial ratio algorithm.
/// Useful for strings where words appear redundantly.
double tokenSetPartialRatio(String s1, String s2, {double scoreCutoff = 0.0}) {
  // Call the function from token_set.dart to prevent recursion
  return token_set.tokenSetPartialRatio(s1, s2, scoreCutoff: scoreCutoff);
}

/// Calculates a weighted ratio between [s1] and [s2] using the best option from
/// the above fuzzy matching algorithms
///
/// Example:
/// ```dart
/// weightedRatio("The quick brown fox jimps ofver the small lazy dog", "the quick brown fox jumps over the small lazy dog") // 97
/// ```
double weightedRatio(String s1, String s2, {double scoreCutoff = 0.0}) {
  final weighted = WeightedRatio();
  return weighted.apply(
    s1.toLowerCase(),
    s2.toLowerCase(),
    scoreCutoff: scoreCutoff,
  );
}

/// Returns a sorted list of [ExtractedResult] which contains the top [limit]
/// most similar choices. Will reject any items with scores below the [cutoff].
/// Default [cutoff] is 0.
/// Uses [WeightedRatio] as the default algorithm.
/// [getter] is optional for [String]  types, but MUST NOT be null for any other
/// types
List<ExtractedResult<T>> extractTop<T>({
  required String query,
  required List<T> choices,
  required int limit,
  int cutoff = 0,
  Applicable ratio = const WeightedRatio(),
  String Function(T obj)? getter,
}) {
  var extractor = Extractor(cutoff);
  return extractor.extractTop(query, choices, ratio, limit, getter);
}

/// Creates a list of [ExtractedResult] which contains all the choices with
/// their corresponding score where higher is more similar.
/// Uses [WeightedRatio] as the default algorithm
/// [getter] is optional for [String]  types, but MUST NOT be null for any other
/// types
List<ExtractedResult<T>> extractAll<T>({
  required String query,
  required List<T> choices,
  int cutoff = 0,
  Applicable ratio = const WeightedRatio(),
  String Function(T obj)? getter,
}) {
  var extractor = Extractor(cutoff);
  return extractor.extractWithoutOrder(query, choices, ratio, getter);
}

/// Returns a sorted list of [ExtractedResult] without any cutoffs.
/// Uses [WeightedRatio] as the default algorithm.
/// [getter] is optional for [String]  types, but MUST NOT be null for any other
/// types
List<ExtractedResult<T>> extractAllSorted<T>({
  required String query,
  required List<T> choices,
  int cutoff = 0,
  Applicable ratio = const WeightedRatio(),
  String Function(T obj)? getter,
}) {
  var extractor = Extractor(cutoff);
  return extractor.extractSorted(query, choices, ratio, getter);
}

/// Find the single best match above the [cutoff] in a list of choices.
/// [getter] is optional for [String]  types, but MUST NOT be null for any other
/// types
ExtractedResult<T> extractOne<T>({
  required String query,
  required List<T> choices,
  int cutoff = 0,
  Applicable ratio = const WeightedRatio(),
  String Function(T obj)? getter,
}) {
  var extractor = Extractor(cutoff);
  return extractor.extractOne(query, choices, ratio, getter);
}
