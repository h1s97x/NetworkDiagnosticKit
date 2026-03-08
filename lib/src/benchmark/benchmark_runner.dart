import 'dart:async';
import 'dart:math';
import '../models/benchmark_result.dart';
import '../models/benchmark_suite_result.dart';

/// Benchmark runner for performance testing
class BenchmarkRunner {
  /// Run a single benchmark test
  static Future<BenchmarkResult> run({
    required String testName,
    required Future<void> Function() test,
    int iterations = 100,
    int warmupIterations = 10,
    Map<String, dynamic>? metadata,
  }) async {
    // Warmup phase
    for (var i = 0; i < warmupIterations; i++) {
      await test();
    }

    // Actual benchmark
    final durations = <int>[];
    final stopwatch = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      final iterationStopwatch = Stopwatch()..start();
      await test();
      iterationStopwatch.stop();
      durations.add(iterationStopwatch.elapsedMilliseconds);
    }

    stopwatch.stop();

    // Calculate statistics
    final totalDuration = stopwatch.elapsedMilliseconds;
    final averageDuration = totalDuration / iterations;
    final minDuration = durations.reduce(min);
    final maxDuration = durations.reduce(max);
    final standardDeviation = _calculateStandardDeviation(durations);
    final operationsPerSecond = 1000 / averageDuration;

    return BenchmarkResult(
      testName: testName,
      iterations: iterations,
      totalDuration: totalDuration,
      averageDuration: averageDuration,
      minDuration: minDuration,
      maxDuration: maxDuration,
      standardDeviation: standardDeviation,
      operationsPerSecond: operationsPerSecond,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Run a suite of benchmark tests
  static Future<BenchmarkSuiteResult> runSuite({
    required String suiteName,
    required Map<String, Future<void> Function()> tests,
    int iterations = 100,
    int warmupIterations = 10,
    Map<String, dynamic>? deviceInfo,
  }) async {
    final results = <BenchmarkResult>[];
    final suiteStopwatch = Stopwatch()..start();

    for (var entry in tests.entries) {
      final result = await run(
        testName: entry.key,
        test: entry.value,
        iterations: iterations,
        warmupIterations: warmupIterations,
      );
      results.add(result);
    }

    suiteStopwatch.stop();

    return BenchmarkSuiteResult(
      suiteName: suiteName,
      results: results,
      totalDuration: suiteStopwatch.elapsedMilliseconds,
      timestamp: DateTime.now(),
      deviceInfo: deviceInfo,
    );
  }

  /// Calculate standard deviation
  static double _calculateStandardDeviation(List<int> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDifferences = values.map((v) => pow(v - mean, 2));
    final variance = squaredDifferences.reduce((a, b) => a + b) / values.length;

    return sqrt(variance);
  }
}
