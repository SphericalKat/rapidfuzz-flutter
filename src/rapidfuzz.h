#ifndef RAPIDFUZZ_H_
#define RAPIDFUZZ_H_

// This ensures C++ symbols are properly exported as C symbols
#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
// For Windows
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
// For macOS, Linux, etc.
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

// Declare your C-compatible functions here
FFI_PLUGIN_EXPORT double ratio(const char* str1, const char* str2);
FFI_PLUGIN_EXPORT double partial_ratio(const char* str1, const char* str2);
FFI_PLUGIN_EXPORT double token_sort_ratio(const char* str1, const char* str2);
FFI_PLUGIN_EXPORT double token_set_ratio(const char* str1, const char* str2);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // RAPIDFUZZ_H_
