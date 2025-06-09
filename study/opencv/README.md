A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

# dartcv4: ^1.1.4

https://pub.dev/packages/dartcv4

# 使用记录

## symbol not found

```shell
Unhandled exception:
Invalid argument(s): Failed to lookup symbol 'cv_Mat_create': dlsym(RTLD_DEFAULT, cv_Mat_create): symbol not found
#0      DynamicLibrary.lookup (dart:ffi-patch/ffi_dynamic_library_patch.dart:33:70)
#1      CvNativeCore._cv_Mat_createPtr (package:dartcv4/src/g/core.g.dart:292:84)
#2      CvNativeCore._cv_Mat_createPtr (package:dartcv4/src/g/core.g.dart)
#3      CvNativeCore._cv_Mat_create (package:dartcv4/src/g/core.g.dart:294:7)
#4      CvNativeCore._cv_Mat_create (package:dartcv4/src/g/core.g.dart)
#5      CvNativeCore.cv_Mat_create (package:dartcv4/src/g/core.g.dart:286:12)
#6      new Mat.empty.<anonymous closure> (package:dartcv4/src/core/mat.dart:135:23)
#7      cvRun (package:dartcv4/src/core/base.dart:83:76)
```

在 `Run/Debug Configurations` 中添加环境变量 

### MacOS

```
`DYLD_LIBRARY_PATH` -> `~/xxx/dart_study/.dartcv/lib`
```