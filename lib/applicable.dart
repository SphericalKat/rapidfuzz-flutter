/// A ratio/algorithm that can be applied
abstract class Applicable {
  /// Returns the score of similarity computed from [s1] and [s2]
  /// Optionally takes a [scoreCutoff] which will return early if the score is below the threshold
  double apply(String s1, String s2, {double scoreCutoff = 0.0});
}
