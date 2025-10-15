import 'package:dartcv4/dartcv.dart' as cv;
import 'package:dp_basis/dp_basis.dart';
import 'package:opencv/lib.dart';
import 'package:opencv/opencv.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/10/15
///
/// 测试从图片中取出形状
///
/// See http:///en.wikipedia.org/wiki/Canny_edge_detector
/// http:///docs.opencv.org/master/dd/d1a/group__imgproc__feature.html#ga04723e007ed888ddf11d9ba04e2232de
void testCanny(cv.Mat image) {
  //1: 灰度化
  final grayMat = cvGrayMat(image);
  cvSaveMat("output_canny_gray.png".outputPath, grayMat);
  openFile("output_canny_gray.png".outputPath);

  //2: 滤波
  final blurMat = cv.gaussianBlur(grayMat, (5, 5), 0);
  cvSaveMat("output_canny_blur.png".outputPath, blurMat);
  openFile("output_canny_blur.png".outputPath);

  //3: 二值化
  final binaryMat = cvThresholdMat(blurMat, threshold: 127);
  cvSaveMat("output_canny_binary.png".outputPath, binaryMat);
  openFile("output_canny_binary.png".outputPath);

  //4: 边缘检测
  final cannyMat = cv.canny(binaryMat, 50, 150);
  cvSaveMat("output_canny_canny.png".outputPath, cannyMat);
  openFile("output_canny_canny.png".outputPath);

  final (contours, hierarchy) = cv.findContours(
    cannyMat,
    cv.RETR_EXTERNAL,
    /*cv.RETR_LIST*/
    /*cv.RETR_TREE*/
    cv.CHAIN_APPROX_SIMPLE,
  );

  /*cv.Mat outputMat = cv.drawContours(
    cvColorMat(grayMat),
    contours,
    0,
    cv.Scalar.red,
    thickness: 3,
    maxLevel: 0xffffffff,
  );
  outputMat = cv.rectangle(outputMat, cv.Rect(10, 10, 20, 20), cv.Scalar.red);
  cvSaveMat("output_canny_output.png".outputPath, outputMat);
  openFile("output_canny_output.png".outputPath);*/

  StringBuffer buffer = StringBuffer();
  int index = 0;
  cv.Mat approxMat = cvColorMat(grayMat);
  for (final contour in contours) {
    //将点拟合和线
    final approx = cv.approxPolyDP(
      contour,
      1 /*0.04 * cv.arcLength(contour, true)*/,
      false,
    );
    approxMat = cv.drawContours(
      approxMat,
      cv.VecVecPoint.fromVecPoint(approx),
      0,
      cv.Scalar.red,
      thickness: 1,
      maxLevel: 0xffffffff,
    );
    //

    bool isFirst = true;
    for (final point in approx) {
      final x = point.x / 10;
      final y = point.y / 10;
      if (isFirst) {
        buffer.write("#-->$index \nG90\nG21\nG0 X$x Y$y\n");
      } else {
        buffer.write("G1 X$x Y$y\n");
      }
      isFirst = false;
    }
  }
  cvSaveMat("output_canny_approx.png".outputPath, approxMat);
  openFile("output_canny_approx.png".outputPath);

  openFile(
    buffer.toString().writeToFile("output_canny_approx.txt".outputPath).path,
  );

  //debugger();
}
