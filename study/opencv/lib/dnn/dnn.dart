import 'dart:io';
import 'dart:math';

import 'package:dartcv4/dartcv.dart' as cv;
import 'package:dp_basis/dp_basis.dart';
import 'package:opencv/opencv.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/10/15
///
/// Opencv Net 人工神经网络
/// https://docs.opencv.org/master/db/d30/classcv_1_1dnn_1_1Net.html
Future testDnn() async {
  final idx = Random().nextInt(assetImgs.length);
  final assetName = assetImgs[idx];
  //final assetName = "../../tests/FaceQ.png";
  fgPrint("assetName->$assetName");
  final mat = cvLoadMat(assetName, flags: cv.IMREAD_GRAYSCALE);
  //debugger();
  //final mat = cvLoadMat("../../test/FaceQ.png" /*assetName*/);
  cvSaveMat("../../.output/output.png", mat);
  final result = await predict(mat);
  fgPrint("result->$result");
}

cv.Net? _model;
final assetImgs = [
  "assets/mnist_0.png",
  "assets/mnist_1.png",
  "assets/mnist_2.png",
  "assets/mnist_4.png",
  "assets/mnist_5.png",
  "assets/mnist_8.png",
  "assets/mnist_9.png",
  /*"assets/mnist_9_1.png",*/
];

Future<void> loadModel() async {
  if (_model == null) {
    final data = await File("assets/mnist-8.onnx").readAsBytes();
    final bytes = data.buffer.asUint8List();
    _model = await cv.NetAsync.fromOnnxBytesAsync(bytes);
  }
}

/// https://docs.opencv.org/4.x/d6/d0f/group__dnn.html#ga29f34df9376379a603acd8df581ac8d7
Future<int> predict(cv.Mat img) async {
  await loadModel();
  assert(!img.isEmpty);
  final blob = await cv.blobFromImageAsync(
    img,
    scalefactor: 1.0,
    size: (28, 28),
    mean: cv.Scalar.all(0),
    crop: false,
  );
  assert(!blob.isEmpty);
  await _model!.setInputAsync(blob);
  final logits = await _model!.forwardAsync();
  print("logits: ${logits.toFmtString()}");
  final (minVal, maxVal, minLoc, maxLoc) = await cv.minMaxLocAsync(logits);
  print("minVal: $minVal, minLoc: $minLoc");
  print("maxVal: $maxVal, maxLoc: $maxLoc");
  return maxLoc.x;
}
