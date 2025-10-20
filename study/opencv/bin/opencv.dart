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
  /*img.saveAndOpen("output_raw.png");*/

  /*cvGetBMat(img).saveAndOpen("output_b.png");
  cvGetGMat(img).saveAndOpen("output_g.png");
  cvGetRMat(img).saveAndOpen("output_r.png");*/

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
  //testPerspective();
  //testSegmentation();
  testCameraCalibration();

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
  testMat.saveAndOpen("output.png");

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
  mat.saveAndOpen("output_draw.png");
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
  output?.saveAndOpen("output_stitch.png");
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
  fgPrint("$mat");
  fgPrint("${mat.toList()}");
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

/// 测试前景/背景分割算法
/// - 效果不如意
void testSegmentation() {
  final img = cvLoadMat("backgroundSubtractor.png".inputPath);
  fgPrint("$img width:${img.width}, height:${img.height}");
  /*final mog = cv.createBackgroundSubtractorMOG2(
    varThreshold: 250,
    detectShadows: true,
  );
  cv.Mat res = mog.apply(img.gray);
  res = cv.morphologyEx(
    res,
    cv.MORPH_OPEN,
    cv.getStructuringElement(cv.MORPH_ELLIPSE, (3, 3)),
  );*/

  final knn = cv.BackgroundSubtractorKNN.create(
    varThreshold: 16,
    detectShadows: true,
  );
  cv.Mat res = knn.apply(img.gray);

  fgPrint("$res width:${res.width}, height:${res.height}");

  res.saveAndOpen("output_mog.png");
}

/// 测试相机标定/相机校准
void testCameraCalibration() {
  //final img = cvLoadMat("calibresult.png".inputPath);
  final img = cvLoadMat("calibresult_90.png".inputPath);

  List<List<cv.Point3f>> objectPoints = [];
  List<List<cv.Point2f>> imagePoints = [];

  //final cameraMatrix = cv.Mat.eye(3, 3, cv.CV_64F);
  //final patternSize = (7, 6); //网格尺寸
  final patternSize = (8, 6); //网格尺寸

  List<cv.Point3f> objectPoints2 = [];
  for (var r = 0; r < patternSize.$2; r++) {
    for (var c = 0; c < patternSize.$1; c++) {
      objectPoints2.add(cv.Point3f(r * 10, c * 10, 0));
      // objectPoints2.add(cv.Point3f(r + 0.0, c + 0.0, 0));
    }
  }
  objectPoints.add(objectPoints2);

  //查找棋盘格角点
  final (bool success, cv.VecPoint2f corners) = cv.findChessboardCorners(
    img.gray,
    patternSize,
  );
  fgPrint(corners.toList(), 90);
  //细化角点位置, 增加准确度
  final corners2 = cv.cornerSubPix(img.gray, corners, (11, 11), (-1, -1));
  fgPrint(corners2.toList(), 91);
  imagePoints.add(corners2.toList());

  final res = cv.drawChessboardCorners(img, patternSize, corners2, true);
  res.saveAndOpen("output_cc.png");

  //获取标定结果
  final (
    double rmsErr,
    cv.Mat cameraMatrix,
    cv.Mat distCoeffs,
    cv.Mat rvecs,
    cv.Mat tvecs,
  ) = cv.calibrateCamera(
    cv.Contours3f.fromList(objectPoints),
    cv.Contours2f.fromList(imagePoints),
    patternSize,
    cv.Mat.empty(),
    cv.Mat.empty(),
  );
  //distCoeffs:Mat(addr=0x6000012e88c0, type=CV_64FC1, rows=1, cols=5, channels=1) [[-0.7881097007309008, 2.8231170733523783, 0.02692497935255397, 0.08256194583654793, -7.601687967063381]]
  //cameraMatrix:Mat(addr=0x6000012e8890, type=CV_64FC1, rows=3, cols=3, channels=1) [[802.4764753450518, 0.0, 12.792931450932988], [0.0, 1934.0012961748434, -14.44565026590872], [0.0, 0.0, 1.0]]
  fgPrint("distCoeffs:$distCoeffs ${distCoeffs.toList()}");
  fgPrint("cameraMatrix:$cameraMatrix ${cameraMatrix.toList()}");

  //去畸变
  final test = cvLoadMat("left12.jpg".inputPath);
  final undistorted = cv.undistort(test, cameraMatrix, distCoeffs);
  undistorted.saveAndOpen("output_test.png");
}
