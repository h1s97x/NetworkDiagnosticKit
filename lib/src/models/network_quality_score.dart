import '../enums/quality_level.dart';

/// 网络质量评分
///
/// 包含网络质量的综合评估结果，包括评分、质量等级、各项指标和优化建议。
///
/// ## 属性
///
/// - [score]: 网络评分 (0-100)
/// - [level]: 网络质量等级
/// - [metrics]: 各项指标的详细数据
/// - [suggestions]: 网络优化建议列表
/// - [timestamp]: 评估执行时间
///
/// ## 评分等级
///
/// - 90-100: 优秀 (Excellent)
/// - 70-89: 良好 (Good)
/// - 50-69: 一般 (Fair)
/// - 30-49: 较差 (Poor)
/// - 0-29: 很差 (Bad)
///
/// ## 示例
///
/// ```dart
/// final quality = await NetworkDiagnostic.evaluateQuality();
/// print('网络评分: ${quality.score}/100');
/// print('质量等级: ${quality.level.displayName}');
/// print('各项指标:');
/// quality.metrics.forEach((key, value) {
///   print('  $key: $value');
/// });
/// print('优化建议:');
/// for (var suggestion in quality.suggestions) {
///   print('  - $suggestion');
/// }
/// ```
class NetworkQualityScore {
  NetworkQualityScore({
    required this.score,
    required this.level,
    required this.metrics,
    required this.suggestions,
    required this.timestamp,
  });

  factory NetworkQualityScore.fromJson(Map<String, dynamic> json) {
    return NetworkQualityScore(
      score: json['score'] as int,
      level: QualityLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => QualityLevel.poor,
      ),
      metrics: json['metrics'] as Map<String, dynamic>,
      suggestions: (json['suggestions'] as List).cast<String>(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// 评分 (0-100)
  final int score;

  /// 质量等级
  final QualityLevel level;

  /// 各项指标
  final Map<String, dynamic> metrics;

  /// 优化建议
  final List<String> suggestions;

  /// 评估时间
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'level': level.name,
      'metrics': metrics,
      'suggestions': suggestions,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'NetworkQualityScore(score: $score, level: ${level.displayName})';
  }
}
