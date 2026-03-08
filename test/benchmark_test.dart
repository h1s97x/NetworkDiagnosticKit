import 'package:flutter_test/flutter_test.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

void main() {
  group('BenchmarkRunner Tests', () {
    test('should run a simple benchmark', () async {
      var counter = 0;
      final result = await BenchmarkRunner.run(
        testName: 'Counter Test',
        test: () async {
          counter++;
          await Future.delayed(const Duration(milliseconds: 10));
        },
        iterations: 10,
        warmupIterations: 2,
      );

      expect(result.testName, 'Counter Test');
      expect(result.iterations, 10);
      expect(result.totalDuration, greaterThan(0));
      expect(result.averageDuration, greaterThan(0));
      expect(result.minDuration, greaterThanOrEqualTo(0));
      expect(result.maxDuration, greaterThanOrEqualTo(result.minDuration));
      expect(result.operationsPerSecond, greaterThan(0));
      expect(counter, 12); // 2 warmup + 10 iterations
    });

    test('should calculate statistics correctly', () async {
      final result = await BenchmarkRunner.run(
        testName: 'Stats Test',
        test: () async {
          await Future.delayed(const Duration(milliseconds: 5));
        },
        iterations: 5,
        warmupIterations: 1,
      );

      expect(result.averageDuration, greaterThan(0));
      expect(result.standardDeviation, greaterThanOrEqualTo(0));
      expect(result.minDuration,
          lessThanOrEqualTo(result.averageDuration.toInt()));
      expect(result.maxDuration,
          greaterThanOrEqualTo(result.averageDuration.toInt()));
    });

    test('should run benchmark suite', () async {
      final result = await BenchmarkRunner.runSuite(
        suiteName: 'Test Suite',
        tests: {
          'test1': () async {
            await Future.delayed(const Duration(milliseconds: 5));
          },
          'test2': () async {
            await Future.delayed(const Duration(milliseconds: 10));
          },
        },
        iterations: 5,
        warmupIterations: 1,
      );

      expect(result.suiteName, 'Test Suite');
      expect(result.results.length, 2);
      expect(result.totalDuration, greaterThan(0));
      expect(result.getResult('test1'), isNotNull);
      expect(result.getResult('test2'), isNotNull);
      expect(result.getResult('nonexistent'), isNull);
    });
  });

  group('BenchmarkResult Tests', () {
    test('should convert to JSON correctly', () {
      final result = BenchmarkResult(
        testName: 'Test',
        iterations: 10,
        totalDuration: 100,
        averageDuration: 10.0,
        minDuration: 8,
        maxDuration: 15,
        standardDeviation: 2.5,
        operationsPerSecond: 100.0,
        timestamp: DateTime(2024, 1, 1),
        metadata: {'key': 'value'},
      );

      final json = result.toJson();
      expect(json['testName'], 'Test');
      expect(json['iterations'], 10);
      expect(json['totalDuration'], 100);
      expect(json['averageDuration'], 10.0);
      expect(json['metadata'], {'key': 'value'});
    });

    test('should have correct toString', () {
      final result = BenchmarkResult(
        testName: 'Test',
        iterations: 10,
        totalDuration: 100,
        averageDuration: 10.0,
        minDuration: 8,
        maxDuration: 15,
        standardDeviation: 2.5,
        operationsPerSecond: 100.0,
        timestamp: DateTime.now(),
      );

      final str = result.toString();
      expect(str, contains('Test'));
      expect(str, contains('10'));
      expect(str, contains('10.00'));
      expect(str, contains('100.00'));
    });
  });

  group('BenchmarkSuiteResult Tests', () {
    test('should convert to JSON correctly', () {
      final result = BenchmarkSuiteResult(
        suiteName: 'Suite',
        results: [
          BenchmarkResult(
            testName: 'Test1',
            iterations: 10,
            totalDuration: 100,
            averageDuration: 10.0,
            minDuration: 8,
            maxDuration: 15,
            standardDeviation: 2.5,
            operationsPerSecond: 100.0,
            timestamp: DateTime.now(),
          ),
        ],
        totalDuration: 100,
        timestamp: DateTime(2024, 1, 1),
        deviceInfo: {'platform': 'test'},
      );

      final json = result.toJson();
      expect(json['suiteName'], 'Suite');
      expect(json['results'], isA<List>());
      expect(json['totalDuration'], 100);
      expect(json['deviceInfo'], {'platform': 'test'});
    });

    test('should have correct toString', () {
      final result = BenchmarkSuiteResult(
        suiteName: 'Suite',
        results: [
          BenchmarkResult(
            testName: 'Test1',
            iterations: 10,
            totalDuration: 100,
            averageDuration: 10.0,
            minDuration: 8,
            maxDuration: 15,
            standardDeviation: 2.5,
            operationsPerSecond: 100.0,
            timestamp: DateTime.now(),
          ),
        ],
        totalDuration: 100,
        timestamp: DateTime.now(),
      );

      final str = result.toString();
      expect(str, contains('Suite'));
      expect(str, contains('100ms'));
      expect(str, contains('Test1'));
    });
  });
}
