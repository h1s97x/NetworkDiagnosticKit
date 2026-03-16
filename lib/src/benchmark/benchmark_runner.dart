import 'dart:async';
import 'dart:math';
import '../models/benchmark_result.dart';
import '../models/benchmark_suite_result.dart';

/// 基准测试运行器
///
/// 通用的基准测试框架，用于测试任何异步操作的性能。
/// 支持预热阶段、多次迭代和详细的统计数据。
///
/// ## 功能
///
/// - [run]: 运行单个基准测试
/// - [runSuite]: 运行基准测试套件
///
/// ## 特性
///
/// - 预热阶段：在正式测试前运行若干次以稳定性能
/// - 详细统计：计算平均值、最小值、最大值、标准差等
/// - 操作速率：计算每秒操作数 (ops/sec)
/// - 元数据支持：可附加自定义元数据
///
/// ## 使用示例
///
/// ```dart
/// // 运行单个测试
/// final result = await BenchmarkRunner.run(
///   testName: 'Connection Check',
///   test: () => NetworkDiagnostic.checkConnection(),
///   iterations: 100,
///   warmupIterations: 10,
/// );
/// print('平均耗时: ${result.averageDuration.toStringAsFixed(2)}ms');
/// print('操作/秒: ${result.operationsPerSecond.toStringAsFixed(2)}');
///
/// // 运行测试套件
/// final suiteResult = await BenchmarkRunner.runSuite(
///   suiteName: 'Network Tests',
///   tests: {
///     'test1': () => NetworkDiagnostic.checkConnection(),
///     'test2': () => NetworkDiagnostic.ping(host: 'www.baidu.com'),
///   },
///   iterations: 50,
/// );
/// ```
class BenchmarkRunner {
  /// 运行单个基准测试
  ///
  /// 执行指定的测试函数多次，并收集性能数据。
  ///
  /// ## 参数
  ///
  /// - [testName]: 测试名称
  /// - [test]: 要测试的异步函数
  /// - [iterations]: 迭代次数，默认 100
  /// - [warmupIterations]: 预热迭代次数，默认 10
  /// - [metadata]: 附加元数据
  ///
  /// ## 返回值
  ///
  /// 返回 [BenchmarkResult] 包含详细的性能数据。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final result = await BenchmarkRunner.run(
  ///   testName: 'My Test',
  ///   test: () async {
  ///     // 测试代码
  ///   },
  ///   iterations: 100,
  /// );
  /// ```
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

  /// 运行基准测试套件
  ///
  /// 执行多个基准测试，并返回汇总结果。
  ///
  /// ## 参数
  ///
  /// - [suiteName]: 测试套件名称
  /// - [tests]: 测试函数映射，键为测试名称，值为测试函数
  /// - [iterations]: 每个测试的迭代次数，默认 100
  /// - [warmupIterations]: 预热迭代次数，默认 10
  /// - [deviceInfo]: 设备信息元数据
  ///
  /// ## 返回值
  ///
  /// 返回 [BenchmarkSuiteResult] 包含所有测试的结果。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final result = await BenchmarkRunner.runSuite(
  ///   suiteName: 'Network Diagnostics',
  ///   tests: {
  ///     'connection': () => NetworkDiagnostic.checkConnection(),
  ///     'ping': () => NetworkDiagnostic.ping(host: 'www.baidu.com'),
  ///   },
  ///   iterations: 50,
  /// );
  /// ```
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

  /// 计算标准差
  ///
  /// 计算给定数值列表的标准差。
  static double _calculateStandardDeviation(List<int> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDifferences = values.map((v) => pow(v - mean, 2));
    final variance = squaredDifferences.reduce((a, b) => a + b) / values.length;

    return sqrt(variance);
  }
}
