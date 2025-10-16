import 'package:dartcv4/dartcv.dart' as cv;
import 'package:dp_basis/dp_basis.dart';
import 'package:opencv/dnn/dnn.dart';
import 'package:opencv/lib.dart';
import 'package:opencv/opencv.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/06/09
///

void main() async {
  print(currentPath);
  print(currentFilePath);
  print(currentFileName);

  final tick1 = cv.getTickCount();
  bgPrint('Hello Opencv:${cv.openCvVersion()} / ${cv.getNumThreads()}');

  //读取图片
  final img = cv.imread("FaceQ.png".inputPath, flags: cv.IMREAD_COLOR);
  //图片颜色空间转换
  final gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY);
  fgPrint("$img width:${img.width}, height:${img.height}");

  //cv.split(m);
  //cv.merge(m);
  //cv.imshow("test", img);

  //保存图片
  //cv.imwrite("test_cvtcolor.png".outputPath, gray);

  //testCanny(img);
  //await testDnn();
  //testDraw();
  //testStitch();
  testPerspective();

  //--
  final tick2 = cv.getTickCount();
  bgPrint("end:${(tick2 - tick1) / cv.getTickFrequency()}");
}

//--

/// 测试在图片上绘制元素
void testDraw() {
  // final mat = cvLoadMat("FaceQ.png".inputPath);
  final mat = cvLoadMat("test2.png".inputPath);
  final bytes = mat.data;
  final type = mat.type;

  /*final bMat = cvThresholdMat(
    cvLoadMat("FaceQ.png".inputPath, flags: cv.IMREAD_GRAYSCALE),
    120,
    maxVal: 200
  );
  cvSaveMat("output_b.png".outputPath, bMat);
  openFile("output_b.png".outputPath);*/

  final testMat = cvFilterMat(mat, 5);
  cvSaveMat("output.png".outputPath, testMat);
  openFile("output.png".outputPath);

  /*debugger();
  mat.forEachPixel((row, col, pixel) {
    debugger(when: pixel.any((num) => num != 0));
  });*/

  final thickness = 1;

  //绘制矩形
  cv.rectangle(
    mat,
    cv.Rect(10, 10, 20, 20),
    cv.Scalar.red,
    thickness: thickness,
  );
  //绘制圆形
  cv.circle(mat, cv.Point(30, 30), 10, cv.Scalar.red, thickness: thickness);
  //绘制文字, 不支持中文 emoji
  cv.putText(
    mat,
    "angcyo 中国人 😌",
    cv.Point(30, 30),
    cv.FONT_HERSHEY_SIMPLEX,
    1,
    cv.Scalar.red,
  );
  cvSaveMat("output_draw.png".outputPath, mat);
  openFile("output_draw.png".outputPath);
}

/// 测试图片拼接
void testStitch() {
  final images = <cv.Mat>[];
  for (final name in assetImgs) {
    images.add(cvLoadMat(name));
    if (images.length >= 6) {
      break;
    }
  }
  //debugger();
  final output = cvStitchMat(images);
  cvSaveMat("output_stitch.png".outputPath, output);
  openFile("output_stitch.png".outputPath);
}

/// 测试透视变换
void testPerspective() {
  final mat = cvPerspectiveTransform2f(
    [
      cv.Point2f(13, 13),
      cv.Point2f(166.5, 18.5),
      cv.Point2f(163, 163.5),
      cv.Point2f(10.5, 160.5),
    ],
    [
      cv.Point2f(20, 20),
      cv.Point2f(160, 20),
      cv.Point2f(160, 160),
      cv.Point2f(20, 160),
    ],
  );
  //[[0.8922067941243021, 0.014188208530941089, 8.176286297216732],
  // [-0.03583605628807173, 0.9391478601047357, 8.216367882118266],
  // [-0.00010755186200365007, -0.000048519939015975823, 1.0]]
  fgPrint("$mat ${mat.toList()}");
  fgPrint("${mat.matrix3}");
}
