import '../enums/quality_level.dart';

/// 网络质量评分
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
