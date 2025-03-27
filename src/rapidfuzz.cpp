#include "rapidfuzz.h"

// Include RapidFuzz headers
#include <rapidfuzz/fuzz.hpp>
#include <string>

// Implement your extern "C" functions to call RapidFuzz C++ code
FFI_PLUGIN_EXPORT double ratio(const char* str1, const char* str2) {
    // Convert C strings to C++ strings
    std::string s1(str1);
    std::string s2(str2);
    
    // Call RapidFuzz's C++ API
    double similarity = rapidfuzz::fuzz::ratio(s1, s2);
    
    return similarity;
}

FFI_PLUGIN_EXPORT double partial_ratio(const char* str1, const char* str2) {
    // Convert C strings to C++ strings
    std::string s1(str1);
    std::string s2(str2);

    // Call RapidFuzz's C++ API
    double similarity = rapidfuzz::fuzz::partial_ratio(s1, s2);

    return similarity;
}

FFI_PLUGIN_EXPORT double token_sort_ratio(const char* str1, const char* str2) {
    // Convert C strings to C++ strings
    std::string s1(str1);
    std::string s2(str2);

    // Call RapidFuzz's C++ API
    double similarity = rapidfuzz::fuzz::token_sort_ratio(s1, s2);

    return similarity;
}

FFI_PLUGIN_EXPORT double token_set_ratio(const char* str1, const char* str2) {
    // Convert C strings to C++ strings
    std::string s1(str1);
    std::string s2(str2);

    // Call RapidFuzz's C++ API
    double similarity = rapidfuzz::fuzz::token_set_ratio(s1, s2);

    return similarity;
}



