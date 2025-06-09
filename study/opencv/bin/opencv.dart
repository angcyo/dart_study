import 'package:dp_basis/dp_basis.dart';
import 'package:opencv/opencv.dart' as opencv;
import 'package:dartcv4/dartcv.dart' as cv;

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/06/09
///

void main() {
  print(currentPath);
  print(currentPath2);
  print(currentFileName);

  print('Hello world: ${opencv.calculate()}!');

  //读取图片
  final img = cv.imread("../../tests/FaceQ.png", flags: cv.IMREAD_COLOR);
  //图片颜色空间转换
  final gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY);
  print("${img.rows}, ${img.cols}");

  //保存图片
  cv.imwrite("../../.output/test_cvtcolor.png", gray);
}
