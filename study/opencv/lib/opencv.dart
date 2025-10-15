import 'dart:typed_data';

import 'package:dartcv4/dartcv.dart' as cv;

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/06/09
///

/// 从路径中读取图片Mat
/// - [filePath] 必须要是绝对路径, 否则会报错
/// - [flags]
///   - [cv.IMREAD_COLOR] 彩色图片
///   - [cv.IMREAD_GRAYSCALE] 灰度图片
cv.Mat cvLoadMat(String filePath, {int flags = cv.IMREAD_COLOR}) {
  return cv.imread(filePath, flags: flags);
}

/// 解码图片
cv.Mat cvImgDecodeMat(Uint8List bytes, {int flags = cv.IMREAD_COLOR}) {
  return cv.imdecode(bytes, flags);
}

/// 存储图片到指定路径
/// http://docs.opencv.org/master/d4/da8/group__imgcodecs.html#gabbc7ef1aa2edfaa87772f1202d67e0ce
bool cvSaveMat(String filePath, cv.InputArray mat) {
  return cv.imwrite(filePath, mat);
}
