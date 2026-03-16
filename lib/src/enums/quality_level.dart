/// 网络质量等级
///
/// 表示网络质量的等级，根据评分自动分类。
///
/// ## 等级说明
///
/// - [excellent]: 优秀 (90-100 分)
/// - [good]: 良好 (70-89 分)
/// - [fair]: 一般 (50-69 分)
/// - [poor]: 较差 (0-49 分)
///
/// ## 使用示例
///
/// ```dart
/// final quality = await NetworkDiagnostic.evaluateQuality();
/// switch (quality.level) {
///   case QualityLevel.excellent:
///     print('网络状态优秀');
///     break;
///   case QualityLevel.good:
///     print('网络状态良好');
///     break;
///   case QualityLevel.fair:
///     print('网络状态一般');
///     break;
///   case QualityLevel.poor:
///     print('网络状态较差');
///     break;
/// }
/// ```
enum QualityLevel {
  /// 优秀 (90-100)
  excellent,

  /// 良好 (70-89)
  good,

  /// 一般 (50-69)
  fair,

  /// 较差 (0-49)
  poor,
}

extension QualityLevelExtension on QualityLevel {
  String get displayName {
    switch (this) {
      case QualityLevel.excellent:
        return '优秀';
      case QualityLevel.good:
        return '良好';
      case QualityLevel.fair:
        return '一般';
      case QualityLevel.poor:
        return '差';
    }
  }

  static QualityLevel fromScore(int score) {
    if (score >= 80) return QualityLevel.excellent;
    if (score >= 60) return QualityLevel.good;
    if (score >= 40) return QualityLevel.fair;
    return QualityLevel.poor;
  }
}
