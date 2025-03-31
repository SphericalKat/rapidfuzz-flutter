import 'dart:math';

import '../applicable.dart';
import '../algorithms/core.dart' as core;
import '../ratios/partial.dart';
import '../ratios/simple.dart';
import 'token_set.dart' as token_set;
import 'token_sort.dart' as token_sort;

class WeightedRatio implements Applicable {
  static const unbaseScaleConst = 0.95;
  static const partialScaleConst = 0.90;
  static const tryPartialsConst = true;

  const WeightedRatio();

  @override
  double apply(String s1, String s2, {double scoreCutoff = 0.0}) {
    // RapidFuzz returns 0 if cutoff > 100
    if (scoreCutoff > 100) return 0.0;

    var len1 = s1.length;
    var len2 = s2.length;

    // RapidFuzz returns 0 when either string is empty
    if (len1 == 0 || len2 == 0) {
      return 0.0;
    }

    var tryPartials = tryPartialsConst;
    var unbaseScale = unbaseScaleConst;
    var partialScale = partialScaleConst;

    var base = core.ratio(s1, s2, scoreCutoff: scoreCutoff);
    var lenRatio = max(len1, len2) / min(len1, len2);

    tryPartials = lenRatio >= 1.5;
    if (lenRatio > 8) partialScale = 0.6;

    if (tryPartials) {
      // Update score_cutoff when using the results of one algorithm as cutoff for the next
      scoreCutoff = max(scoreCutoff, base) / partialScale;
      var partial =
          core.partialRatio(s1, s2, scoreCutoff: scoreCutoff) * partialScale;

      scoreCutoff = max(scoreCutoff, partial) / (unbaseScale * partialScale);
      var partialSor =
          token_sort.tokenSortPartialRatio(s1, s2, scoreCutoff: scoreCutoff) *
          unbaseScale *
          partialScale;

      var partialSet =
          token_set.tokenSetPartialRatio(s1, s2, scoreCutoff: scoreCutoff) *
          unbaseScale *
          partialScale;

      return [base, partial, partialSor, partialSet].reduce(max);
    } else {
      scoreCutoff = max(scoreCutoff, base) / unbaseScale;
      var tokenSort =
          token_sort.tokenSortRatio(s1, s2, scoreCutoff: scoreCutoff) *
          unbaseScale;
      var tokenSet =
          token_set.tokenSetRatio(s1, s2, scoreCutoff: scoreCutoff) *
          unbaseScale;

      return [base, tokenSort, tokenSet].reduce(max);
    }
  }
}
