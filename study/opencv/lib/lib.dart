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
