import 'dart:typed_data';

import 'package:dartcv4/dartcv.dart' as cv;
import 'package:dp_basis/dp_basis.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/06/09
///
/// Opencv 默认的颜色通道排序是 BGR
/// - [cv.MatType.CV_8UC3] BGR
/// - [cv.MatType.CV_8UC4] BGRA

/// 从路径中读取图片Mat
/// - [filePath] 必须要是绝对路径, 否则会报错
/// - [flags]
///   - [cv.IMREAD_COLOR] 彩色图片, 透明图片也是3通道 BGR
///   - [cv.IMREAD_UNCHANGED] 支持透明图片 4通道 BGRA
///   - [cv.IMREAD_GRAYSCALE] 灰度图片
cv.Mat cvLoadMat(String filePath, {int flags = cv.IMREAD_COLOR}) {
  return cv.imread(filePath, flags: flags);
}

/// 解码图片
cv.Mat cvImgDecodeMat(Uint8List bytes, {int flags = cv.IMREAD_COLOR}) {
  return cv.imdecode(bytes, flags);
}

/// 编码Mat成成图片字节数组
Uint8List? cvImgEncodeMat(cv.InputArray img, {String ext = ".png"}) {
  final (success, bytes) = cv.imencode(ext, img);
  return success ? bytes : null;
}

/// 颜色空间转换
/// - [code]
///   - [cv.COLOR_BGR2RGBA] 转成RGBA
///   - [cv.COLOR_BGR2GRAY] 转成灰度
///   - [cv.COLOR_BGR2HSV] 转成HSV
///   - [cv.COLOR_BGR2HLS] 转成HLS
cv.Mat cvCvtColorMat(cv.InputArray src, int code, {cv.OutputArray? dst}) {
  return cv.cvtColor(src, code, dst: dst);
}

/// 灰度化
///
/// - [cvCvtColorMat]
cv.Mat cvGrayMat(
  cv.InputArray src, {
  int code = cv.COLOR_BGR2GRAY,
  cv.OutputArray? dst,
}) {
  return cv.cvtColor(src, code, dst: dst);
}

/// 灰色化的图片转成彩色空间
cv.Mat cvColorMat(
  cv.InputArray src, {
  int code = cv.COLOR_GRAY2BGR,
  cv.OutputArray? dst,
}) {
  return cv.cvtColor(src, code, dst: dst);
}

/// 二值化图片
/// - [src] 源图片, 建议已经灰度化了. 否则二值化的输出结果可能有问题
/// - [threshold] 阈值,
///   - [cv.THRESH_BINARY] <=这个值的像素值变成0, 其它像素变成[maxVal]
///   - [cv.THRESH_BINARY_INV] 与[cv.THRESH_BINARY] 相反
/// - [maxVal] 限制数值的最大值
/// https:///docs.opencv.org/3.3.0/d7/d1b/group__imgproc__misc.html#gae8a4a146d1ca78c626a53577199e9c57
cv.Mat cvThresholdMat(
  cv.InputArray src, {
  double threshold = 127,
  double maxVal = 255,
  int type = cv.THRESH_BINARY,
}) {
  //cv.THRESH_BINARY + cv.THRESH_OTSU
  final (_, dst) = cv.threshold(src, threshold, maxVal, type);
  //debugger();
  return dst;
}

/// 滤波处理, 降噪. 可以消除噪点.  但是会模糊边缘.
/// - [cv.blur] 平均滤波/均值滤波. 均值滤波是一种通过替换每个像素值为邻域像素的平均值来减少图像中噪声的方法。
/// - [cv.gaussianBlur] 高斯滤波. 高斯滤波通过使用高斯函数加权邻域像素值，可以更有效地减少噪声。
/// - [cv.medianBlur] 中值滤波. 中值滤波替换每个像素值为邻域像素的中位数，适用于去除椒盐噪声。
/// - [cv.bilateralFilter] 双边滤波. 双边滤波是同时考虑空间距离和强度差异的滤波器，可以更好地保留边缘。
/// - [cv.filter2D] 自定义滤波器
///
/// - [cv.boxFilter] 方框滤波. 方框滤波使用均匀权重的邻域像素值来计算每个像素的新值，通常用于平滑图像。
/// - [cv.laplacian] 拉普拉斯滤波. 拉普拉斯滤波用于边缘检测，能够增强图像的细节。
/// - [cv.sobel] Sobel算子. Sobel算子用于计算图像的梯度，并计算每个像素的梯度方向和强度。
/// - [cv.scharr] Scharr算子. Scharr算子用于计算图像的梯度，并计算每个像素的梯度方向和强度。
/// - [cv.dft] 快速傅里叶变换. 快速傅里叶变换是一种用于处理图像的快速变换算法，可以计算图像的频谱。
/// - [cv.idft] 快速傅里叶逆变换. 快速傅里叶逆变换是一种用于处理图像的快速变换算法，可以计算图像的时域信号。
/// - [cv.morphologyEx] 形态学处理. 形态学处理是一种用于处理图像的滤波算法，可以进行图像的开、闭、腐蚀、膨胀、形态学梯度、顶帽和黑帽等操作。
///
/// ## Depth combinations
/// https://docs.opencv.org/4.x/d4/d86/group__imgproc__filter.html#filter_depths
///
/// Input depth (src.depth()) | Output depth (ddepth)
/// |-------------------------|----------------------|
/// CV_8U                     |-1/CV_16S/CV_32F/CV_64F
/// CV_16U/CV_16S             |-1/CV_32F/CV_64F
/// CV_32F                    |-1/CV_32F
/// CV_64F                    |-1/CV_64F
///
/// https:///docs.opencv.org/master/d4/d86/group__imgproc__filter.html#ga27c049795ce870216ddfb366086b5a04
cv.Mat cvFilterMat(cv.InputArray src, int size) {
  final (int, int) ksize = (size, size); //窗口大小
  //return cv.blur(src, ksize);

  final sigma = 0.0;
  //return cv.gaussianBlur(src, ksize, sigma, sigmaY: sigma);

  return cv.medianBlur(src, size);

  //效果不明显
  //return cv.bilateralFilter(src, size, 75, 75);

  //锐化滤波器。
  /*final kernel = cv.Mat.from2DList([
    [0, -1, 0],
    [-1, 5, -1],
    [0, -1, 0],
    */ /*[-1, 1, 1],
    [1, -1, 1],
    [1, 1, -1],*/ /*
  ], cv.MatType.CV_8UC1);
  return cv.filter2D(src, -1, kernel);*/
}

/// 存储图片到指定路径
/// http://docs.opencv.org/master/d4/da8/group__imgcodecs.html#gabbc7ef1aa2edfaa87772f1202d67e0ce
bool cvSaveMat(String filePath, cv.InputArray? mat) {
  if (mat == null) {
    return false;
  }
  return cv.imwrite(filePath, mat);
}

/// 获取图片RGBA像素数组
Uint8List cvGetMatPixels(cv.InputArray mat) {
  //return mat.reshape(cn);
  /*mat.forEachPixel((row, col, pixel) {
    //debugger(when: pixel.any((num) => num != 0));
  });*/
  //mat.reshape(cn);
  return mat.data; //这个是图片的字节数组, 就是散装的RGB数据
}

/// 获取图片的宽高
(int width, int height) cvGetMatSize(cv.InputArray mat) {
  return (mat.width, mat.height);
}

/// 调整图片的大小
/// - [interpolation] 插值方式
///   - [cv.INTER_NEAREST] 就近插值
///   - [cv.INTER_LINEAR] 线性插值
/// https:///docs.opencv.org/master/da/d54/group__imgproc__transform.html#ga47a974309e9102f5f08231edc7e7529d
cv.Mat cvResizeMat(
  cv.InputArray src, {
  int? width,
  int? height,
  int interpolation = cv.INTER_LINEAR,
}) {
  if (width == null && height == null) {
    return src;
  }
  final (oldWidth, oldHeight) = cvGetMatSize(src);
  return cv.resize(src, (width ?? oldWidth, height ?? oldHeight));
}

/// 旋转图片, 只能是90°的倍数
/// - [rotateCode]
///   - [cv.ROTATE_180]
///   - [cv.ROTATE_90_CLOCKWISE]
///   - [cv.ROTATE_90_COUNTERCLOCKWISE]
/// https://docs.opencv.org/master/d2/de8/group__core__array.html#ga4ad01c0978b0ce64baa246811deeac24
cv.Mat cvRotateMat(cv.InputArray src, int rotateCode) {
  return cv.rotate(src, rotateCode);
}

/// 图像拼接, 将边缘内容差不多的图片拼接在一起
cv.Mat? cvStitchMat(List<cv.InputArray> images) {
  final stitcher = cv.Stitcher.create(mode: cv.StitcherMode.PANORAMA);
  final (status, dst) = stitcher.stitch(images.cvd);
  if (status == cv.StitcherStatus.ERR_NEED_MORE_IMGS) {
    fgPrint("需要更多图片", 196);
  }
  return status == cv.StitcherStatus.OK ? dst : null;
}
