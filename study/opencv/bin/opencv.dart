import 'package:dartcv4/dartcv.dart' as cv;
import 'package:dp_basis/dp_basis.dart';
import 'package:opencv/canny/canny.dart';
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

  //print('Hello world: ${opencv.calculate()}!');

  //读取图片
  final img = cv.imread("FaceQ.png".inputPath, flags: cv.IMREAD_COLOR);
  //图片颜色空间转换
  final gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY);
  fgPrint("$img width:${img.width}, height:${img.height}");

  //保存图片
  //cv.imwrite("test_cvtcolor.png".outputPath, gray);

  testCanny(img);
  //await testDnn();
  //testDraw();
  //testStitch();
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
