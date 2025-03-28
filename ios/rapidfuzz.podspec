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
  s.source_files = 'Classes/**/*', '../src/**/*.{h,hpp,c,cpp,cc,mm}'
  
  # Exclude unnecessary files
  s.exclude_files = '../src/rapidfuzz/test/**/*', 
                    '../src/rapidfuzz/examples/**/*',
                    '../src/rapidfuzz/benchmarks/**/*'


                  
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'HEADER_SEARCH_PATHS' => [
      '$(PODS_TARGET_SRCROOT)/../src',
      '$(PODS_TARGET_SRCROOT)/../src/rapidfuzz',
      '$(PODS_TARGET_SRCROOT)/../src/rapidfuzz/rapidfuzz'
    ].join(' '),
    'GCC_PREPROCESSOR_DEFINITIONS' => 'RAPIDFUZZ_INCLUDE_SIMD=0',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++',
    'GCC_PREPROCESSOR_DEFINITIONS' => ['RAPIDFUZZ_INCLUDE_SIMD=0'].join(' ')
  }
  s.swift_version = '5.0'
  s.library = 'c++'
end
