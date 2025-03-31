import '../applicable.dart';
import '../algorithms/core.dart' as core;

class SimpleRatio implements Applicable {
  const SimpleRatio();

  @override
  double apply(String s1, String s2, {double scoreCutoff = 0.0}) {
    return core.ratio(s1, s2, scoreCutoff: scoreCutoff);
  }
}
