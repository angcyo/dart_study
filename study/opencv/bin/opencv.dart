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
  bgPrint(
    'Hello Opencv:${cv.openCvVersion()} / ${cv.getNumThreads()} / ${cv.getTickCount()}',
  );

  //读取图片
  final img = cv.imread("FaceQ.png".inputPath, flags: cv.IMREAD_COLOR);
  cvSaveMat("output_raw.png".outputPath, img);
  openFile("output_raw.png".outputPath);

  cvSaveMat("output_b.png".outputPath, cvGetBMat(img));
  openFile("output_b.png".outputPath);
  cvSaveMat("output_g.png".outputPath, cvGetGMat(img));
  openFile("output_g.png".outputPath);
  cvSaveMat("output_r.png".outputPath, cvGetRMat(img));
  openFile("output_r.png".outputPath);

  //图片颜色空间转换
  final gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY);
  fgPrint("$img width:${img.width}, height:${img.height}");

  //分离图片通道
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
  //cv.normalize(mat);
  //[[0.8922067941243021, 0.014188208530941089, 8.176286297216732],
  // [-0.03583605628807173, 0.9391478601047357, 8.216367882118266],
  // [-0.00010755186200365007, -0.000048519939015975823, 1.0]]
  fgPrint("$mat ${mat.toList()}");
  fgPrint("${mat.matrix3}");
}

/// 测试模板匹配
/// All the 6 methods for comparison in a list
/// - [cv.TM_CCOEFF]
/// - [cv.TM_CCORR]
/// - [cv.TM_CCOEFF_NORMED] .
/// - [cv.TM_SQDIFF]        .
/// - [cv.TM_SQDIFF_NORMED]
///
/// https://opencv-python-tutorials.readthedocs.io/zh/latest/4.%20OpenCV%E4%B8%AD%E7%9A%84%E5%9B%BE%E5%83%8F%E5%A4%84%E7%90%86/4.12.%20%E6%A8%A1%E6%9D%BF%E5%8C%B9%E9%85%8D/
void testTemplate(cv.Mat img, cv.Mat templ, {int method = cv.TM_SQDIFF}) {
  final res = cv.matchTemplate(img, templ, method);
  final (minVal, maxVal, minLoc, maxLoc) = cv.minMaxLoc(res);
  print("minVal: $minVal, minLoc: $minLoc");
  print("maxVal: $maxVal, maxLoc: $maxLoc");
  final left = minLoc.x;
  final top = minLoc.y;
  final width = templ.width;
  final height = templ.height;
  cv.rectangle(
    img,
    cv.Rect(left, top, width, height),
    cv.Scalar.red,
    thickness: 2,
  );
  //cv.cornerSubPix(image, corners, winSize, zeroZone)
  //cv.dilate(image, corners, winSize, zeroZone) //膨胀
  //cv.erode(image, corners, winSize, zeroZone) //腐蚀
}
