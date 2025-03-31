import '../applicable.dart';
import '../algorithms/core.dart' as core;

class PartialRatio implements Applicable {
  const PartialRatio();

  @override
  double apply(String s1, String s2) {
    return core.partialRatio(s1, s2);
  }
}
