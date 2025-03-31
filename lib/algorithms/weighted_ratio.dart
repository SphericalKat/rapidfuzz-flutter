import 'dart:math';

import '../applicable.dart';
import '../algorithms/core.dart' as core;
import '../ratios/partial.dart';
import '../ratios/simple.dart';
import 'token_set.dart';
import 'token_sort.dart';

class WeightedRatio implements Applicable {
  static const unbaseScaleConst = 0.95;
  static const partialScaleConst = 0.90;
  static const tryPartialsConst = true;

  const WeightedRatio();

  @override
  double apply(String s1, String s2) {
    var len1 = s1.length;
    var len2 = s2.length;

    if (len1 == 0 || len2 == 0) {
      return 0;
    }

    var tryPartials = tryPartialsConst;
    var unbaseScale = unbaseScaleConst;
    var partialScale = partialScaleConst;

    var base = core.ratio(s1, s2);
    var lenRatio = max(len1, len2) / min(len1, len2);

    tryPartials = lenRatio >= 1.5;
    if (lenRatio > 8) partialScale = 0.6;

    if (tryPartials) {
      var partial = core.partialRatio(s1, s2) * partialScale;
      var partialSor =
          TokenSort().apply(s1, s2, PartialRatio()) *
          unbaseScale *
          partialScale;
      var partialSet =
          TokenSet().apply(s1, s2, PartialRatio()) * unbaseScale * partialScale;

      return [base, partial, partialSor, partialSet].reduce(max);
    } else {
      var tokenSort = TokenSort().apply(s1, s2, SimpleRatio()) * unbaseScale;
      var tokenSet = TokenSet().apply(s1, s2, SimpleRatio()) * unbaseScale;

      return [base, tokenSort, tokenSet].reduce(max);
    }
  }
}
