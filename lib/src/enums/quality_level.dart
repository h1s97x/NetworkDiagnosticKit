/// 网络质量等级
enum QualityLevel {
  /// 优秀 (80-100)
  excellent,

  /// 良好 (60-79)
  good,

  /// 一般 (40-59)
  fair,

  /// 差 (0-39)
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
