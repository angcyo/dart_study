import 'dart:developer';

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dp_basis/dp_basis.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/07/08
///
void main(List<String> arguments) async {
  print('Hello world!');
  await wrapMeasureTime(() {
    print(
      eval('print(testObject.name);', plugins: [TestObjectPlugin()]),
    ); // -> 4
  });
}

/// 注入一个对象
class TestObject {
  final String name;

  String? name2;

  int value1 = 1;
  double value2 = 0.9999;

  TestObject(this.name);
}

/// This is our wrapper class
/// [TestObject]的包装对象
class $TestObject implements $Instance {
  //--

  /// Create a type specification for the dart_eval compiler
  static final $type = BridgeTypeSpec(
    'package:eval/eval.dart',
    'TestObject',
  ).ref;

  /// Again, we map out all the fields and methods for the compiler.
  static final $declaration = BridgeClassDef(
    BridgeClassType($type, isAbstract: true),
    constructors: {
      // Even though this class is abstract, we currently need to define
      // the default constructor anyway.
      '': BridgeFunctionDef(
        returns: $type.annotate,
        params: [
          BridgeParameter(
            'name',
            BridgeTypeAnnotation(
              BridgeTypeRef(CoreTypes.string),
              nullable: false,
            ),
            true,
          ),
        ],
      ).asConstructor,
    },
    bridge: true,
  );

  //--
  /// Create a constructor that wraps the Book class
  $TestObject.wrap(this.$value);

  @override
  final TestObject $value;

  @override
  get $reified => $value;

  //--

  /// Allow runtime type lookup
  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  //--

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    debugger();
    return $Object(this).$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    debugger();
    return $Object(this).$setProperty(runtime, identifier, value);
  }
}

///
class TestObjectPlugin implements EvalPlugin {
  @override
  void configureForCompile(BridgeDeclarationRegistry registry) {
    debugger();
    registry.defineBridgeClass($TestObject.$declaration);
  }

  @override
  void configureForRuntime(Runtime runtime) {
    debugger();
  }

  @override
  String get identifier => "testObject";
}
