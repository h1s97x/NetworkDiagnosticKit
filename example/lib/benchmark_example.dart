import 'package:flutter/material.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

class BenchmarkExample extends StatefulWidget {
  const BenchmarkExample({super.key});

  @override
  State<BenchmarkExample> createState() => _BenchmarkExampleState();
}

class _BenchmarkExampleState extends State<BenchmarkExample> {
  BenchmarkSuiteResult? _result;
  bool _isRunning = false;
  String _currentTest = '';

  Future<void> _runAllBenchmarks() async {
    setState(() {
      _isRunning = true;
      _currentTest = 'Running all benchmarks...';
    });

    try {
      final result = await NetworkBenchmark.runAll(
        iterations: 50,
        warmupIterations: 5,
      );

      setState(() {
        _result = result;
        _isRunning = false;
        _currentTest = '';
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _currentTest = 'Error: $e';
      });
    }
  }

  Future<void> _runConnectionBenchmark() async {
    setState(() {
      _isRunning = true;
      _currentTest = 'Benchmarking connection check...';
    });

    try {
      final result = await NetworkBenchmark.benchmarkConnection(
        iterations: 100,
      );

      setState(() {
        _result = result;
        _isRunning = false;
        _currentTest = '';
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _currentTest = 'Error: $e';
      });
    }
  }

  Future<void> _runPingBenchmark() async {
    setState(() {
      _isRunning = true;
      _currentTest = 'Benchmarking ping...';
    });

    try {
      final result = await NetworkBenchmark.benchmarkPing(
        iterations: 30,
        hosts: ['www.baidu.com', 'www.google.com'],
      );

      setState(() {
        _result = result;
        _isRunning = false;
        _currentTest = '';
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _currentTest = 'Error: $e';
      });
    }
  }

  Future<void> _runDnsBenchmark() async {
    setState(() {
      _isRunning = true;
      _currentTest = 'Benchmarking DNS...';
    });

    try {
      final result = await NetworkBenchmark.benchmarkDns(
        iterations: 50,
        domain: 'www.google.com',
        dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
      );

      setState(() {
        _result = result;
        _isRunning = false;
        _currentTest = '';
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _currentTest = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Benchmark')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isRunning)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(_currentTest),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isRunning ? null : _runAllBenchmarks,
              child: const Text('Run All Benchmarks'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isRunning ? null : _runConnectionBenchmark,
              child: const Text('Benchmark Connection Check'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isRunning ? null : _runPingBenchmark,
              child: const Text('Benchmark Ping'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isRunning ? null : _runDnsBenchmark,
              child: const Text('Benchmark DNS'),
            ),
            const SizedBox(height: 24),
            if (_result != null) _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _result!.suiteName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Total Duration: ${_result!.totalDuration}ms',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Tests: ${_result!.results.length}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(height: 24),
            ..._result!.results.map((result) => _buildResultItem(result)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(BenchmarkResult result) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(result.testName, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          _buildMetric('Iterations', '${result.iterations}'),
          _buildMetric(
            'Average',
            '${result.averageDuration.toStringAsFixed(2)}ms',
          ),
          _buildMetric('Min', '${result.minDuration}ms'),
          _buildMetric('Max', '${result.maxDuration}ms'),
          _buildMetric(
            'Std Dev',
            '${result.standardDeviation.toStringAsFixed(2)}ms',
          ),
          _buildMetric(
            'Ops/sec',
            result.operationsPerSecond.toStringAsFixed(2),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: const TextStyle(color: Colors.grey)),
          ),
          Text(value),
        ],
      ),
    );
  }
}
