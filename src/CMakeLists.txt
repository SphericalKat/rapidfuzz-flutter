# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(rapidfuzz_library VERSION 0.0.1 LANGUAGES CXX)

# Set C++ standard needed for RapidFuzz
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add RapidFuzz as a subdirectory to use its CMake configuration
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/RapidFuzz ${CMAKE_CURRENT_BINARY_DIR}/rapidfuzz)

# Create your wrapper library with a distinct name
add_library(rapidfuzz_wrapper SHARED
  "rapidfuzz.cpp"
)

# Link against RapidFuzz (which is an INTERFACE library)
target_link_libraries(rapidfuzz_wrapper PRIVATE rapidfuzz::rapidfuzz)

set_target_properties(rapidfuzz_wrapper PROPERTIES
  PUBLIC_HEADER rapidfuzz.h
  OUTPUT_NAME "rapidfuzz"  # This ensures the output file is still named "rapidfuzz"
)

target_compile_definitions(rapidfuzz_wrapper PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(rapidfuzz_wrapper PRIVATE "-Wl,-z,max-page-size=16384")
endif()
