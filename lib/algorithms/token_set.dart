import 'dart:math';

import '../applicable.dart';
import '../algorithms/core.dart' as core;

class TokenSet {
  /// Apply the ratio calculation to token sets
  double apply(
    String s1,
    String s2,
    Applicable ratio, {
    double scoreCutoff = 0.0,
  }) {
    // Handle edge cases according to RapidFuzz implementation
    if (scoreCutoff > 100) return 0.0;

    // RapidFuzz handles empty strings specially
    if (s1.isEmpty || s2.isEmpty) {
      return 0.0;
    }

    // Split the strings into tokens and deduplicate them
    var tokens1 = s1.split(RegExp(r'\s+')).toSet();
    var tokens2 = s2.split(RegExp(r'\s+')).toSet();

    // Handle empty token sets
    if (tokens1.isEmpty || tokens2.isEmpty) {
      return 0.0;
    }

    // Calculate intersection and differences
    var intersection = tokens1.intersection(tokens2);
    var diff1to2 = tokens1.difference(tokens2);
    var diff2to1 = tokens2.difference(tokens1);

    // If one string's tokens are completely contained in the other's
    if (intersection.isNotEmpty && (diff1to2.isEmpty || diff2to1.isEmpty)) {
      return 100.0;
    }

    // Create joined strings for comparison
    var diffAB = (diff1to2.toList()..sort()).join(' ');
    var diffBA = (diff2to1.toList()..sort()).join(' ');
    var sortedIntersection = (intersection.toList()..sort()).join(' ');

    // Calculate string lengths for similarity calculations
    int abLen = diffAB.length;
    int baLen = diffBA.length;
    int sectLen = sortedIntersection.length;

    // Calculate the different combinations of tokens needed for comparisons
    int sectAbLen = sectLen + (sectLen > 0 ? 1 : 0) + abLen;
    int sectBaLen = sectLen + (sectLen > 0 ? 1 : 0) + baLen;

    // Calculate indel distance between diffAB and diffBA
    int dist = core.indelDistance(diffAB, diffBA);

    // Calculate the similarity score
    double result = 0.0;
    if (sectAbLen + sectBaLen > 0) {
      result = 100.0 - 100.0 * dist / (sectAbLen + sectBaLen);
      if (result < scoreCutoff) result = 0.0;
    }

    // Exit early if intersection is empty since the other ratios would be 0
    if (intersection.isEmpty) return result;

    // Calculate distances based on length differences
    int sectAbDist = (sectLen > 0 ? 1 : 0) + abLen;
    double sectAbRatio = 0.0;
    if (sectLen + sectAbLen > 0) {
      sectAbRatio = 100.0 - 100.0 * sectAbDist / (sectLen + sectAbLen);
      if (sectAbRatio < scoreCutoff) sectAbRatio = 0.0;
    }

    int sectBaDist = (sectLen > 0 ? 1 : 0) + baLen;
    double sectBaRatio = 0.0;
    if (sectLen + sectBaLen > 0) {
      sectBaRatio = 100.0 - 100.0 * sectBaDist / (sectLen + sectBaLen);
      if (sectBaRatio < scoreCutoff) sectBaRatio = 0.0;
    }

    // Return the maximum of the three calculated scores
    return [result, sectAbRatio, sectBaRatio].reduce(max);
  }
}

/// Calculates token set ratio using the ratio algorithm
double tokenSetRatio(String s1, String s2, {double scoreCutoff = 0.0}) {
  if (scoreCutoff > 100) return 0.0;

  // RapidFuzz handles empty strings specially
  if (s1.isEmpty || s2.isEmpty) {
    return 0.0;
  }

  // Split the strings into tokens and deduplicate them
  var tokens1 = s1.split(RegExp(r'\s+')).toSet();
  var tokens2 = s2.split(RegExp(r'\s+')).toSet();

  // Handle empty token sets
  if (tokens1.isEmpty || tokens2.isEmpty) {
    return 0.0;
  }

  // Calculate intersection and differences
  var intersection = tokens1.intersection(tokens2);
  var diff1to2 = tokens1.difference(tokens2);
  var diff2to1 = tokens2.difference(tokens1);

  // If one string's tokens are completely contained in the other's
  if (intersection.isNotEmpty && (diff1to2.isEmpty || diff2to1.isEmpty)) {
    return 100.0;
  }

  // Create joined strings for comparison
  var diffAB = (diff1to2.toList()..sort()).join(' ');
  var diffBA = (diff2to1.toList()..sort()).join(' ');
  var sortedIntersection = (intersection.toList()..sort()).join(' ');

  // Calculate string lengths for similarity calculations
  int abLen = diffAB.length;
  int baLen = diffBA.length;
  int sectLen = sortedIntersection.length;

  // Calculate the different combinations of tokens needed for comparisons
  int sectAbLen = sectLen + (sectLen > 0 ? 1 : 0) + abLen;
  int sectBaLen = sectLen + (sectLen > 0 ? 1 : 0) + baLen;

  // Calculate indel distance between diffAB and diffBA
  int dist = core.indelDistance(diffAB, diffBA);

  // Calculate the similarity score
  double result = 0.0;
  if (sectAbLen + sectBaLen > 0) {
    result = 100.0 - 100.0 * dist / (sectAbLen + sectBaLen);
    if (result < scoreCutoff) result = 0.0;
  }

  // Exit early if intersection is empty since the other ratios would be 0
  if (intersection.isEmpty) return result;

  // Calculate distances based on length differences
  int sectAbDist = (sectLen > 0 ? 1 : 0) + abLen;
  double sectAbRatio = 0.0;
  if (sectLen + sectAbLen > 0) {
    sectAbRatio = 100.0 - 100.0 * sectAbDist / (sectLen + sectAbLen);
    if (sectAbRatio < scoreCutoff) sectAbRatio = 0.0;
  }

  int sectBaDist = (sectLen > 0 ? 1 : 0) + baLen;
  double sectBaRatio = 0.0;
  if (sectLen + sectBaLen > 0) {
    sectBaRatio = 100.0 - 100.0 * sectBaDist / (sectLen + sectBaLen);
    if (sectBaRatio < scoreCutoff) sectBaRatio = 0.0;
  }

  // Return the maximum of the three calculated scores
  return [result, sectAbRatio, sectBaRatio].reduce(max);
}

/// Calculates partial token set ratio using the partial ratio algorithm
double tokenSetPartialRatio(String s1, String s2, {double scoreCutoff = 0.0}) {
  if (scoreCutoff > 100) return 0.0;

  // RapidFuzz handles empty strings specially
  if (s1.isEmpty || s2.isEmpty) {
    return 0.0;
  }

  // Split the strings into tokens and deduplicate them
  var tokens1 = s1.split(RegExp(r'\s+')).toSet();
  var tokens2 = s2.split(RegExp(r'\s+')).toSet();

  // Handle empty token sets
  if (tokens1.isEmpty || tokens2.isEmpty) {
    return 0.0;
  }

  // Calculate intersection and differences
  var intersection = tokens1.intersection(tokens2);
  var diff1to2 = tokens1.difference(tokens2);
  var diff2to1 = tokens2.difference(tokens1);

  // Exit early when there is a common word in both sequences
  if (intersection.isNotEmpty) {
    return 100.0;
  }

  // Create joined strings for comparison
  var diffAB = (diff1to2.toList()..sort()).join(' ');
  var diffBA = (diff2to1.toList()..sort()).join(' ');

  // Calculate partial ratio between the differences
  return core.partialRatio(diffAB, diffBA, scoreCutoff: scoreCutoff);
}
