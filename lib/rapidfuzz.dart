
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'rapidfuzz_bindings_generated.dart';


double ratio(String str1, String str2) {
  final str1Pointer = str1.toNativeUtf8();
  final str2Pointer = str2.toNativeUtf8();
  return _bindings.ratio(str1Pointer.cast<Char>(), str2Pointer.cast<Char>());
}

double partialRatio(String str1, String str2) {
  final str1Pointer = str1.toNativeUtf8();
  final str2Pointer = str2.toNativeUtf8();
  return _bindings.partial_ratio(str1Pointer.cast<Char>(), str2Pointer.cast<Char>());
}

double tokenSortRatio(String str1, String str2) {
  final str1Pointer = str1.toNativeUtf8();
  final str2Pointer = str2.toNativeUtf8();
  return _bindings.token_sort_ratio(str1Pointer.cast<Char>(), str2Pointer.cast<Char>());
}

double tokenSetRatio(String str1, String str2) {
  final str1Pointer = str1.toNativeUtf8();
  final str2Pointer = str2.toNativeUtf8();
  return _bindings.token_set_ratio(str1Pointer.cast<Char>(), str2Pointer.cast<Char>());
}

const String _libName = 'rapidfuzz';

/// The dynamic library in which the symbols for [RapidfuzzBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final RapidfuzzBindings _bindings = RapidfuzzBindings(_dylib);
