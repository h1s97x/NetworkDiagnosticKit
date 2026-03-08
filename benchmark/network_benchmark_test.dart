import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

/// Standalone benchmark test
/// Run with: dart benchmark/network_benchmark_test.dart
void main() async {
  print('Starting Network Diagnostic Kit Benchmarks...\n');

  // Run all benchmarks
  print('=== Running All Benchmarks ===');
  final allResults = await NetworkBenchmark.runAll(
    iterations: 50,
    warmupIterations: 5,
  );
  _printResults(allResults);

  // Connection benchmark
  print('\n=== Connection Check Benchmark ===');
  final connectionResults = await NetworkBenchmark.benchmarkConnection(
    iterations: 100,
  );
  _printResults(connectionResults);

  // Ping benchmark
  print('\n=== Ping Benchmark ===');
  final pingResults = await NetworkBenchmark.benchmarkPing(
    iterations: 30,
    hosts: ['www.baidu.com', 'www.google.com'],
  );
  _printResults(pingResults);

  // DNS benchmark
  print('\n=== DNS Resolution Benchmark ===');
  final dnsResults = await NetworkBenchmark.benchmarkDns(
    iterations: 50,
    domain: 'www.google.com',
    dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
  );
  _printResults(dnsResults);

  // Port check benchmark
  print('\n=== Port Check Benchmark ===');
  final portResults = await NetworkBenchmark.benchmarkPortCheck(
    iterations: 50,
    host: 'www.baidu.com',
    ports: [80, 443, 8080],
  );
  _printResults(portResults);

  print('\n✅ All benchmarks completed!');
}

void _printResults(BenchmarkSuiteResult result) {
  print('Suite: ${result.suiteName}');
  print('Total Duration: ${result.totalDuration}ms');
  print('Tests: ${result.results.length}');
  print('---');

  for (var testResult in result.results) {
    print('  ${testResult.testName}:');
    print('    Iterations: ${testResult.iterations}');
    print('    Average: ${testResult.averageDuration.toStringAsFixed(2)}ms');
    print('    Min: ${testResult.minDuration}ms');
    print('    Max: ${testResult.maxDuration}ms');
    print('    Std Dev: ${testResult.standardDeviation.toStringAsFixed(2)}ms');
    print('    Ops/sec: ${testResult.operationsPerSecond.toStringAsFixed(2)}');
  }
}
