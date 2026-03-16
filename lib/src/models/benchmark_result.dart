/// 基准测试结果
///
/// 包含单个基准测试的详细性能数据，包括迭代次数、耗时统计和每秒操作数。
///
/// ## 属性
///
/// - [testName]: 测试名称
/// - [iterations]: 迭代次数
/// - [totalDuration]: 总耗时 (毫秒)
/// - [averageDuration]: 平均耗时 (毫秒)
/// - [minDuration]: 最小耗时 (毫秒)
/// - [maxDuration]: 最大耗时 (毫秒)
/// - [standardDeviation]: 标准差
/// - [operationsPerSecond]: 每秒操作数 (ops/sec)
/// - [timestamp]: 测试执行时间
/// - [metadata]: 附加元数据
///
/// ## 示例
///
/// ```dart
/// final result = await BenchmarkRunner.run(
///   testName: 'Connection Check',
///   test: () => NetworkDiagnostic.checkConnection(),
///   iterations: 100,
/// );
/// print('测试: ${result.testName}');
/// print('迭代: ${result.iterations}');
/// print('平均耗时: ${result.averageDuration.toStringAsFixed(2)}ms');
/// print('操作/秒: ${result.operationsPerSecond.toStringAsFixed(2)}');
/// ```
class BenchmarkResult {
  /// Constructor
  const BenchmarkResult({
    required this.testName,
    required this.iterations,
    required this.totalDuration,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.standardDeviation,
    required this.operationsPerSecond,
    required this.timestamp,
    this.metadata,
  });

  /// 测试名称
  final String testName;

  /// 迭代次数
  final int iterations;

  /// 总耗时 (毫秒)
  final int totalDuration;

  /// 平均耗时 (毫秒)
  final double averageDuration;

  /// 最小耗时 (毫秒)
  final int minDuration;

  /// 最大耗时 (毫秒)
  final int maxDuration;

  /// 标准差
  final double standardDeviation;

  /// 每秒操作数
  final double operationsPerSecond;

  /// 测试执行时间
  final DateTime timestamp;

  /// 附加元数据
  final Map<String, dynamic>? metadata;

  /// 转换为 JSON
  Map<String, dynamic> toJson() => {
        'testName': testName,
        'iterations': iterations,
        'totalDuration': totalDuration,
        'averageDuration': averageDuration,
        'minDuration': minDuration,
        'maxDuration': maxDuration,
        'standardDeviation': standardDeviation,
        'operationsPerSecond': operationsPerSecond,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
      };

  @override
  String toString() {
    return 'BenchmarkResult('
        'testName: $testName, '
        'iterations: $iterations, '
        'avg: ${averageDuration.toStringAsFixed(2)}ms, '
        'ops/sec: ${operationsPerSecond.toStringAsFixed(2)}'
        ')';
  }
}
