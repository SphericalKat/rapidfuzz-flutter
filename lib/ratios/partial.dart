import '../applicable.dart';
import '../algorithms/core.dart' as core;

class PartialRatio implements Applicable {
  const PartialRatio();

  @override
  double apply(String s1, String s2, {double scoreCutoff = 0.0}) {
    return core.partialRatio(s1, s2, scoreCutoff: scoreCutoff);
  }
}
