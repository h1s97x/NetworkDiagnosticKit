import '../network_diagnostic.dart';
import '../models/benchmark_suite_result.dart';
import 'benchmark_runner.dart';

/// Network diagnostic benchmark suite
class NetworkBenchmark {
  /// Run all network diagnostic benchmarks
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

  /// Benchmark connection check
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

  /// Benchmark ping operations
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

  /// Benchmark DNS resolution
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

  /// Benchmark port checking
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
