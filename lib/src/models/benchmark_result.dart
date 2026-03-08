/// Benchmark result model
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

  /// Test name
  final String testName;

  /// Number of iterations
  final int iterations;

  /// Total duration in milliseconds
  final int totalDuration;

  /// Average duration per iteration in milliseconds
  final double averageDuration;

  /// Minimum duration in milliseconds
  final int minDuration;

  /// Maximum duration in milliseconds
  final int maxDuration;

  /// Standard deviation
  final double standardDeviation;

  /// Operations per second
  final double operationsPerSecond;

  /// Timestamp when benchmark was run
  final DateTime timestamp;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Convert to JSON
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
