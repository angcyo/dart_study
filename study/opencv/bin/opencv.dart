import 'dart:developer';

import 'package:dartcv4/dartcv.dart' as cv;
import 'package:dp_basis/dp_basis.dart';
import 'package:opencv/dnn/dnn.dart';
import 'package:opencv/opencv.dart' as opencv;

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/06/09
///

void main() async {
  print(currentPath);
  print(currentPath2);
  print(currentFileName);

  //print('Hello world: ${opencv.calculate()}!');

  //读取图片
  final img = cv.imread("../../tests/FaceQ.png", flags: cv.IMREAD_COLOR);
  //图片颜色空间转换
  final gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY);
  print("${img.rows}, ${img.cols}");

  //保存图片
  cv.imwrite("../../.output/test_cvtcolor.png", gray);

  //testCanny(img);
  await testDnn();
}

/// 测试图片形状
void testCanny(cv.Mat image) {
  final mat = cv.canny(image, 120, 120);
  cv.imwrite("../../.output/test_output.png", mat);
  final (contours, hierarchy) = cv.findContours(
    mat,
    cv.RETR_EXTERNAL,
    cv.CHAIN_APPROX_SIMPLE,
  );
  for (final contour in contours) {
    final approx = cv.approxPolyDP(
      contour,
      0.04 * cv.arcLength(contour, true),
      true,
    );
    debugger();
  }
  debugger();
}
