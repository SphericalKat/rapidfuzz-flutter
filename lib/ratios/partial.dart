import '../applicable.dart';
import '../rapidfuzz.dart';

class PartialRatio implements Applicable {
  @override
  double apply(String s1, String s2) {
    return partialRatio(s1, s2);
  }
}
