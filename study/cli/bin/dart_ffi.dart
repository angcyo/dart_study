import 'dart:ffi';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/06/06
///

void main(List<String> arguments) {
  //print('Hello world: ${dart_rust_test.calculate()}!');
  //使用ffi调用动态库librust_image_handle.dylib中的test方法

  final dylib = DynamicLibrary.open("lib/librust_image_handle.dylib");
  final test = dylib.lookupFunction<Void Function(), void Function()>("test");
  test();
  //DynamicLibrary.open("librust_image_handle.dylib").lookupFunction<>("test");
}
