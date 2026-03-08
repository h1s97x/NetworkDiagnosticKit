import 'benchmark_result.dart';

/// Benchmark suite result containing multiple test results
class BenchmarkSuiteResult {
  const BenchmarkSuiteResult({
    required this.suiteName,
    required this.results,
    required this.totalDuration,
    required this.timestamp,
    this.deviceInfo,
  });

  /// Suite name
  final String suiteName;

  /// Individual benchmark results
  final List<BenchmarkResult> results;

  /// Total duration for all tests in milliseconds
  final int totalDuration;

  /// Timestamp when suite was run
  final DateTime timestamp;

  /// Device/platform information
  final Map<String, dynamic>? deviceInfo;

  /// Get result by test name
  BenchmarkResult? getResult(String testName) {
    try {
      return results.firstWhere((r) => r.testName == testName);
    } catch (_) {
      return null;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'suiteName': suiteName,
        'results': results.map((r) => r.toJson()).toList(),
        'totalDuration': totalDuration,
        'timestamp': timestamp.toIso8601String(),
        'deviceInfo': deviceInfo,
      };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Benchmark Suite: $suiteName');
    buffer.writeln('Total Duration: ${totalDuration}ms');
    buffer.writeln('Tests: ${results.length}');
    buffer.writeln('---');
    for (var result in results) {
      buffer.writeln(result);
    }
    return buffer.toString();
  }
}
