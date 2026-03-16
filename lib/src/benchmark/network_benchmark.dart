import '../network_diagnostic.dart';
import '../models/benchmark_suite_result.dart';
import 'benchmark_runner.dart';

/// 网络诊断基准测试套件
///
/// 提供预定义的网络诊断功能基准测试，用于评估各项功能的性能表现。
///
/// ## 功能
///
/// - [runAll]: 运行所有基准测试
/// - [benchmarkConnection]: 测试连接检查性能
/// - [benchmarkPing]: 测试 Ping 性能
/// - [benchmarkDns]: 测试 DNS 解析性能
/// - [benchmarkPortCheck]: 测试端口检查性能
///
/// ## 使用示例
///
/// ```dart
/// // 运行所有基准测试
/// final results = await NetworkBenchmark.runAll(
///   iterations: 50,
///   warmupIterations: 5,
/// );
/// print('总耗时: ${results.totalDuration}ms');
/// for (var result in results.results) {
///   print('${result.testName}: ${result.averageDuration.toStringAsFixed(2)}ms');
/// }
///
/// // 单独测试连接检查性能
/// final connResult = await NetworkBenchmark.benchmarkConnection(
///   iterations: 100,
/// );
///
/// // 测试 Ping 性能
/// final pingResult = await NetworkBenchmark.benchmarkPing(
///   iterations: 30,
///   hosts: ['www.baidu.com', 'www.google.com'],
/// );
/// ```
class NetworkBenchmark {
  /// 运行所有网络诊断基准测试
  ///
  /// 执行连接检查、Ping、DNS 和端口检查的基准测试。
  ///
  /// ## 参数
  ///
  /// - [iterations]: 每个测试的迭代次数，默认 50
  /// - [warmupIterations]: 预热迭代次数，默认 5
  ///
  /// ## 返回值
  ///
  /// 返回 [BenchmarkSuiteResult] 包含所有测试结果。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final results = await NetworkBenchmark.runAll();
  /// print('测试套件: ${results.suiteName}');
  /// print('总耗时: ${results.totalDuration}ms');
  /// ```
  static Future<BenchmarkSuiteResult> runAll({
    int iterations = 50,
    int warmupIterations = 5,
  }) async {
    return BenchmarkRunner.runSuite(
      suiteName: 'Network Diagnostic Kit Benchmarks',
      tests: {
        'checkConnection': () => NetworkDiagnostic.checkConnection(),
        'ping_baidu': () => NetworkDiagnostic.ping(
              host: 'www.baidu.com',
              count: 4,
            ),
        'testDns_single': () => NetworkDiagnostic.testDns(
              domain: 'www.google.com',
              dnsServers: ['8.8.8.8'],
            ),
        'checkPort_80': () => NetworkDiagnostic.checkPort(
              host: 'www.baidu.com',
              port: 80,
            ),
      },
      iterations: iterations,
      warmupIterations: warmupIterations,
    );
  }

  /// 测试连接检查性能
  ///
  /// 基准测试 [NetworkDiagnostic.checkConnection] 方法的性能。
  ///
  /// ## 参数
  ///
  /// - [iterations]: 迭代次数，默认 100
  ///
  /// ## 返回值
  ///
  /// 返回 [BenchmarkSuiteResult] 包含连接检查的性能数据。
  static Future<BenchmarkSuiteResult> benchmarkConnection({
    int iterations = 100,
  }) async {
    return BenchmarkRunner.runSuite(
      suiteName: 'Connection Check Benchmark',
      tests: {
        'checkConnection': () => NetworkDiagnostic.checkConnection(),
      },
      iterations: iterations,
    );
  }

  /// 测试 Ping 性能
  ///
  /// 基准测试 [NetworkDiagnostic.ping] 方法的性能。
  ///
  /// ## 参数
  ///
  /// - [iterations]: 迭代次数，默认 30
  /// - [hosts]: 要 Ping 的主机列表，默认包括百度和谷歌
  ///
  /// ## 返回值
  ///
  /// 返回 [BenchmarkSuiteResult] 包含每个主机的 Ping 性能数据。
  static Future<BenchmarkSuiteResult> benchmarkPing({
    int iterations = 30,
    List<String> hosts = const ['www.baidu.com', 'www.google.com'],
  }) async {
    final tests = <String, Future<void> Function()>{};

    for (var host in hosts) {
      tests['ping_$host'] = () => NetworkDiagnostic.ping(
            host: host,
            count: 4,
          );
    }

    return BenchmarkRunner.runSuite(
      suiteName: 'Ping Benchmark',
      tests: tests,
      iterations: iterations,
    );
  }

  /// 测试 DNS 解析性能
  ///
  /// 基准测试 [NetworkDiagnostic.testDns] 方法的性能。
  ///
  /// ## 参数
  ///
  /// - [iterations]: 迭代次数，默认 50
  /// - [domain]: 要解析的域名，默认 www.google.com
  /// - [dnsServers]: DNS 服务器列表，默认包括 Google、114 和 Cloudflare DNS
  ///
  /// ## 返回值
  ///
  /// 返回 [BenchmarkSuiteResult] 包含每个 DNS 服务器的性能数据。
  static Future<BenchmarkSuiteResult> benchmarkDns({
    int iterations = 50,
    String domain = 'www.google.com',
    List<String> dnsServers = const ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
  }) async {
    final tests = <String, Future<void> Function()>{};

    for (var server in dnsServers) {
      tests['dns_$server'] = () => NetworkDiagnostic.testDns(
            domain: domain,
            dnsServers: [server],
          );
    }

    return BenchmarkRunner.runSuite(
      suiteName: 'DNS Resolution Benchmark',
      tests: tests,
      iterations: iterations,
    );
  }

  /// 测试端口检查性能
  ///
  /// 基准测试 [NetworkDiagnostic.checkPort] 方法的性能。
  ///
  /// ## 参数
  ///
  /// - [iterations]: 迭代次数，默认 50
  /// - [host]: 目标主机，默认 www.baidu.com
  /// - [ports]: 要检查的端口列表，默认 80、443、8080
  ///
  /// ## 返回值
  ///
  /// 返回 [BenchmarkSuiteResult] 包含每个端口的检查性能数据。
  static Future<BenchmarkSuiteResult> benchmarkPortCheck({
    int iterations = 50,
    String host = 'www.baidu.com',
    List<int> ports = const [80, 443, 8080],
  }) async {
    final tests = <String, Future<void> Function()>{};

    for (var port in ports) {
      tests['port_$port'] = () => NetworkDiagnostic.checkPort(
            host: host,
            port: port,
          );
    }

    return BenchmarkRunner.runSuite(
      suiteName: 'Port Check Benchmark',
      tests: tests,
      iterations: iterations,
    );
  }
}
