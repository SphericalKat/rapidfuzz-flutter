#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint rapidfuzz.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rapidfuzz'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  # Your wrapper code and RapidFuzz library
  s.source_files += '../src/**/*.{h,hpp,c,cpp,cc,mm}'
  
  # Exclude unnecessary files
  s.exclude_files = '../src/rapidfuzz/test/**/*', 
                    '../src/rapidfuzz/examples/**/*',
                    '../src/rapidfuzz/benchmarks/**/*'




  # Create a symbolic link to help with includes
  s.script_phase = {
    :name => 'Setup RapidFuzz Headers',
    :script => <<-SCRIPT
      set -e
      # Remove any old copying from previous builds
      rm -rf "${PODS_TARGET_SRCROOT}/../my_rapidfuzz"
      
      # Create a standard "include/rapidfuzz" tree
      mkdir -p "${PODS_TARGET_SRCROOT}/../my_rapidfuzz/include/rapidfuzz"
      
      # Copy the details/ subfolder
      cp -r "${PODS_TARGET_SRCROOT}/../src/rapidfuzz/rapidfuzz/details" \
            "${PODS_TARGET_SRCROOT}/../my_rapidfuzz/include/rapidfuzz/"
      
      # Copy fuzz.hpp (and any other .hpp you need)
      cp "${PODS_TARGET_SRCROOT}/../src/rapidfuzz/rapidfuzz/*.hpp" \
         "${PODS_TARGET_SRCROOT}/../my_rapidfuzz/include/rapidfuzz/"
      
      echo ">> Created a clean RapidFuzz include structure at my_rapidfuzz/include/rapidfuzz"
      find "${PODS_TARGET_SRCROOT}/../my_rapidfuzz" -type f
    SCRIPT
  }
                  
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'HEADER_SEARCH_PATHS' => [
      '$(PODS_TARGET_SRCROOT)/../my_rapidfuzz/include',
      '$(PODS_TARGET_SRCROOT)/..',
      '$(PODS_TARGET_SRCROOT)/../src'
    ].join(' '),
    'GCC_PREPROCESSOR_DEFINITIONS' => 'RAPIDFUZZ_INCLUDE_SIMD=0',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',  # RapidFuzz likely needs C++17
    'CLANG_CXX_LIBRARY' => 'libc++',
    'GCC_PREPROCESSOR_DEFINITIONS' => ['RAPIDFUZZ_INCLUDE_SIMD=0'].join(' ')
  }
  s.swift_version = '5.0'
  s.library = 'c++'
end
