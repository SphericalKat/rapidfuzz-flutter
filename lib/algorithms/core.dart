import 'dart:math';

/// Calculates the Levenshtein distance between two strings
int levenshteinDistance(String s1, String s2) {
  if (s1.isEmpty) return s2.length;
  if (s2.isEmpty) return s1.length;

  final matrix = List<List<int>>.generate(
    s1.length + 1,
    (i) => List<int>.generate(s2.length + 1, (j) => 0),
  );

  // Initialize first row and column
  for (var i = 0; i <= s1.length; i++) {
    matrix[i][0] = i;
  }
  for (var j = 0; j <= s2.length; j++) {
    matrix[0][j] = j;
  }

  // Fill in the rest of the matrix
  for (var i = 0; i < s1.length; i++) {
    for (var j = 0; j < s2.length; j++) {
      if (s1[i] == s2[j]) {
        matrix[i + 1][j + 1] = matrix[i][j];
      } else {
        matrix[i + 1][j + 1] = min(
          min(matrix[i][j + 1] + 1, matrix[i + 1][j] + 1),
          matrix[i][j] + 1,
        );
      }
    }
  }

  return matrix[s1.length][s2.length];
}

/// Calculates the Jaro similarity between two strings
double jaroSimilarity(String s1, String s2) {
  if (s1 == s2) return 1.0;
  if (s1.isEmpty || s2.isEmpty) return 0.0;
  if (s1.length == 1 && s2.length == 1) return s1 == s2 ? 1.0 : 0.0;

  final matchWindow = (max(s1.length, s2.length) ~/ 2) - 1;
  final matches1 = List<bool>.filled(s1.length, false);
  final matches2 = List<bool>.filled(s2.length, false);
  var matches = 0;
  var transpositions = 0;

  // Find matches
  for (var i = 0; i < s1.length; i++) {
    final start = max(0, i - matchWindow);
    final end = min(i + matchWindow + 1, s2.length);
    for (var j = start; j < end; j++) {
      if (!matches2[j] && s1[i] == s2[j]) {
        matches1[i] = true;
        matches2[j] = true;
        matches++;
        break;
      }
    }
  }

  if (matches == 0) return 0.0;

  // Count transpositions
  var k = 0;
  for (var i = 0; i < s1.length; i++) {
    if (matches1[i]) {
      while (!matches2[k]) {
        k++;
      }
      if (s1[i] != s2[k]) transpositions++;
      k++;
    }
  }

  transpositions = transpositions ~/ 2;

  return (matches / s1.length +
          matches / s2.length +
          (matches - transpositions) / matches) /
      3.0;
}

/// Calculates the Jaro-Winkler similarity between two strings
double jaroWinklerSimilarity(
  String s1,
  String s2, {
  double weightFactor = 0.1,
}) {
  final jaro = jaroSimilarity(s1, s2);

  if (jaro < 0.7) return jaro;

  var prefixLength = 0;
  final maxPrefixLength = min(4, min(s1.length, s2.length));

  for (var i = 0; i < maxPrefixLength; i++) {
    if (s1[i] != s2[i]) break;
    prefixLength++;
  }

  return jaro + (prefixLength * weightFactor * (1 - jaro));
}

/// Calculates the InDel distance (Insertion-Deletion distance) between two strings
int indelDistance(String s1, String s2) {
  if (s1.isEmpty) return s2.length;
  if (s2.isEmpty) return s1.length;

  // InDel distance is equivalent to Levenshtein where substitution cost is infinity
  // Since we can't represent infinity, we just make it higher than any possible distance
  final matrix = List<List<int>>.generate(
    s1.length + 1,
    (i) => List<int>.generate(s2.length + 1, (j) => 0),
  );

  // Initialize first row and column
  for (var i = 0; i <= s1.length; i++) {
    matrix[i][0] = i;
  }
  for (var j = 0; j <= s2.length; j++) {
    matrix[0][j] = j;
  }

  for (var i = 0; i < s1.length; i++) {
    for (var j = 0; j < s2.length; j++) {
      if (s1[i] == s2[j]) {
        matrix[i + 1][j + 1] = matrix[i][j];
      } else {
        matrix[i + 1][j + 1] = min(
          matrix[i][j + 1] + 1, // deletion
          matrix[i + 1][j] + 1, // insertion
        );
      }
    }
  }

  return matrix[s1.length][s2.length];
}

/// Calculates normalized similarity using the indel distance
/// This is a key component of the original RapidFuzz implementation
double indelNormalizedSimilarity(
  String s1,
  String s2, {
  double scoreCutoff = 0.0,
}) {
  if (s1 == s2) return 1.0;
  if (s1.isEmpty && s2.isEmpty) return 1.0;
  if (s1.isEmpty || s2.isEmpty) return 0.0;

  final dist = indelDistance(s1, s2);
  final maxDistance = s1.length + s2.length;
  final normDist = dist / maxDistance;
  final similarity = 1.0 - normDist;

  return (similarity >= scoreCutoff) ? similarity : 0.0;
}

/// Calculates the longest common subsequence between two strings
String longestCommonSubsequence(String s1, String s2) {
  if (s1.isEmpty || s2.isEmpty) return '';

  final matrix = List<List<int>>.generate(
    s1.length + 1,
    (i) => List<int>.generate(s2.length + 1, (j) => 0),
  );

  // Fill in the matrix
  for (var i = 0; i < s1.length; i++) {
    for (var j = 0; j < s2.length; j++) {
      if (s1[i] == s2[j]) {
        matrix[i + 1][j + 1] = matrix[i][j] + 1;
      } else {
        matrix[i + 1][j + 1] = max(matrix[i + 1][j], matrix[i][j + 1]);
      }
    }
  }

  // Backtrack to find the LCS
  final lcs = StringBuffer();
  var i = s1.length;
  var j = s2.length;
  while (i > 0 && j > 0) {
    if (s1[i - 1] == s2[j - 1]) {
      lcs.write(s1[i - 1]);
      i--;
      j--;
    } else if (matrix[i - 1][j] > matrix[i][j - 1]) {
      i--;
    } else {
      j--;
    }
  }

  return lcs.toString().split('').reversed.join();
}

/// Calculates a simple ratio between two strings
/// Matches the behavior of RapidFuzz's ratio implementation
double ratio(String s1, String s2, {double scoreCutoff = 0.0}) {
  // Following the original RapidFuzz implementation
  if (s1 == s2) return 100.0;

  // In RapidFuzz, empty strings give a score of 0
  if (s1.isEmpty || s2.isEmpty) return 0.0;

  // The original implementation uses indel_normalized_similarity * 100
  return indelNormalizedSimilarity(s1, s2, scoreCutoff: scoreCutoff / 100) *
      100;
}

/// Represents a score alignment for partial ratio calculations
class ScoreAlignment {
  final double score;
  final int srcStart;
  final int srcEnd;
  final int destStart;
  final int destEnd;

  ScoreAlignment({
    this.score = 0.0,
    this.srcStart = 0,
    this.srcEnd = 0,
    this.destStart = 0,
    this.destEnd = 0,
  });
}

/// Calculates a partial ratio between two strings
/// Matches the behavior of RapidFuzz's partial_ratio implementation
double partialRatio(String s1, String s2, {double scoreCutoff = 0.0}) {
  final len1 = s1.length;
  final len2 = s2.length;

  // RapidFuzz swaps the strings to ensure s1 is always the shorter one
  if (len1 > len2) {
    return partialRatio(s2, s1, scoreCutoff: scoreCutoff);
  }

  // Handle cutoff > 100
  if (scoreCutoff > 100) return 0.0;

  // Handle empty strings - RapidFuzz returns 100 if both empty, 0 otherwise
  if (len1 == 0 || len2 == 0) {
    return (len1 == len2) ? 100.0 : 0.0;
  }

  // Perfect match
  if (s1 == s2) return 100.0;

  // Find best substring match
  var bestScore = 0.0;

  // When len2 > len1, try to find the best matching substring
  if (len2 > len1) {
    // Try all possible substrings of s2 with length len1
    for (var i = 0; i <= len2 - len1; i++) {
      final subStr = s2.substring(i, i + len1);
      final currentScore = ratio(s1, subStr, scoreCutoff: bestScore);
      bestScore = max(bestScore, currentScore);
      if (bestScore == 100.0) return 100.0;
    }
  }

  // For strings of same length, check ratio in both directions
  if (s1.length == s2.length && bestScore != 100.0) {
    final reversedScore = ratio(s2, s1, scoreCutoff: bestScore);
    bestScore = max(bestScore, reversedScore);
  }

  // Also check beginning and end of string s2 for partial matches
  // Check partial matches with the beginning of s2 (increasing size)
  for (var i = 1; i < len1; i++) {
    final s1Substr = s1.substring(0, i);
    final s2Substr = s2.substring(0, i);
    if (s1.codeUnitAt(i - 1) != s2.codeUnitAt(i - 1)) continue;

    final currentScore = ratio(s1Substr, s2Substr, scoreCutoff: bestScore);
    if (currentScore > bestScore) {
      bestScore = currentScore;
      if (bestScore == 100.0) return 100.0;
    }
  }

  // Check partial matches with the end of s2 (decreasing size)
  for (var i = len2 - 1; i >= len2 - len1; i--) {
    final s1Substr = s1.substring(len1 - (len2 - i));
    final s2Substr = s2.substring(i);
    if (s1.codeUnitAt(0) != s2.codeUnitAt(i)) continue;

    final currentScore = ratio(s1Substr, s2Substr, scoreCutoff: bestScore);
    if (currentScore > bestScore) {
      bestScore = currentScore;
      if (bestScore == 100.0) return 100.0;
    }
  }

  return bestScore;
}
