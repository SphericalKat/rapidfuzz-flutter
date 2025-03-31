import '../applicable.dart';
import '../algorithms/core.dart' as core;

class TokenSort {
  /// Apply the ratio calculation to sorted tokens
  double apply(
    String s1,
    String s2,
    Applicable ratio, {
    double scoreCutoff = 0.0,
  }) {
    // Handle edge cases according to RapidFuzz implementation
    if (scoreCutoff > 100) return 0.0;

    if (s1.isEmpty || s2.isEmpty) {
      // RapidFuzz returns 0 when either string is empty
      return 0.0;
    }

    var sorted1 = _sort(s1);
    var sorted2 = _sort(s2);

    return ratio.apply(sorted1, sorted2, scoreCutoff: scoreCutoff);
  }

  /// Split string into tokens, sort them and join them back
  static String _sort(String s) {
    if (s.isEmpty) return '';

    // RapidFuzz uses whitespace to split tokens, so we'll do the same
    var words = s.split(RegExp(r'\s+'))..sort();
    return words.join(' ').trim();
  }
}

/// Calculates token sort ratio using the ratio algorithm
double tokenSortRatio(String s1, String s2, {double scoreCutoff = 0.0}) {
  if (scoreCutoff > 100) return 0.0;

  // Handle edge cases according to RapidFuzz implementation
  if (s1.isEmpty || s2.isEmpty) {
    return 0.0;
  }

  var sorted1 = TokenSort._sort(s1);
  var sorted2 = TokenSort._sort(s2);

  return core.ratio(sorted1, sorted2, scoreCutoff: scoreCutoff);
}

/// Calculates token sort partial ratio using the partial ratio algorithm
double tokenSortPartialRatio(String s1, String s2, {double scoreCutoff = 0.0}) {
  if (scoreCutoff > 100) return 0.0;

  // Handle edge cases according to RapidFuzz implementation
  if (s1.isEmpty || s2.isEmpty) {
    return 0.0;
  }

  var sorted1 = TokenSort._sort(s1);
  var sorted2 = TokenSort._sort(s2);

  return core.partialRatio(sorted1, sorted2, scoreCutoff: scoreCutoff);
}
