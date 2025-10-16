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
  //threshold1: 任何梯度值低于 threshold1 的像素被认为是“非边缘”，会被丢弃。
  // 设置较低时，会检测到更多的边缘（可能包括噪声）；设置较高时，部分较弱的边缘会被忽略。
  //threshold2: 任何梯度值高于 threshold2 的像素被认为是“强边缘”。
  // 设置较高时，只能检测到很明显的边缘；设置较低时，边缘检测会更“敏感”，可能导致虚假边缘。
  //两个阈值的比例通常设为 1:2 或 1:3。
  //edges1 = cv.canny(img, 50, 150)   # 常用，边缘较平衡
  //edges2 = cv.canny(img, 100, 200)  # 较高，边缘较少更明显
  //edges3 = cv.canny(img, 10, 80)    # 较低，边缘多但易有噪点
  final cannyMat = cv.canny(binaryMat, 50, 150);
  cvSaveMat("output_canny_canny.png".outputPath, cannyMat);
  openFile("output_canny_canny.png".outputPath);

  //https://blog.csdn.net/qq_36758914/article/details/104007478
  //mode: 轮廓检索模式
  //cv.RETR_EXTERNAL ：只检索最外面的轮廓；
  //cv.RETR_LIST：检索所有的轮廓，并将其保存到一条链表当中；
  //cv.RETR_CCOMP：检索所有的轮廓，并将他们组织为两层：顶层是各部分的外部边界，第二层是空洞的边界;
  //cv.RETR_TREE（最常用）：检索所有的轮廓，并重构嵌套轮廓的整个层次;
  //
  //method: 轮廓逼近方法
  //cv.CHAIN_APPROX_NONE：以Freeman链码的方式输出轮廓，所有其他方法输出多边形（顶点的序列）。
  //cv.CHAIN_APPROX_SIMPLE（最常用）:压缩水平的、垂直的和斜的部分，也就是，函数只保留他们的终点部分。
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
    // 轮廓面积
    final area = cv.contourArea(contour);
    // 轮廓周长
    final perimeter = cv.arcLength(contour, true);

    //旋转矩形
    cv.boxPoints(cv.minAreaRect(contour));
    //cv.circle(cv.minEnclosingCircle(contour));
    //cv.ellipse(cv.fitEllipse(contour));
    // 拟合一条线
    cv.fitLine(contour, cv.DIST_L2, 0, 0.01, 0.01);



    // 凸包
    cv.convexHull(contour);

    //将点拟合和线
    final approx = cv.approxPolyDP(
      contour,
      1 /*0.04 * cv.arcLength(contour, true)*/,
      false,
    );
    approxMat = cv.drawContours(
      approxMat,
      cv.VecVecPoint.fromVecPoint(approx),
      -1 /*-1表示绘制所有轮廓, 0表示绘制第一条轮廓*/,
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
