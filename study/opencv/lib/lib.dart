import 'package:dartcv4/dartcv.dart' as cv;
import 'package:dp_basis/dp_basis.dart';

import 'opencv.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/10/15
///
extension TestStringEx on String {
  /// 当前文件名的输入路径
  String get inputPath => "../../tests/$this";

  /// 当前文件名的输出路径
  String get outputPath => "../../.output/$this";
}

extension LibMatEx on cv.Mat {
  /// 保存图片和打开图片
  void saveAndOpen(String name, {bool open = true}) {
    final path = name.outputPath;
    cvSaveMat(path, this);
    if (open) {
      openFile(path);
    }
  }
}
