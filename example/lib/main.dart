import 'package:flutter/material.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Diagnostic Kit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NetworkConnectionInfo? _connectionInfo;
  SpeedTestResult? _speedTestResult;
  PingResult? _pingResult;
  NetworkQualityScore? _qualityScore;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _listenToConnectivityChanges();
  }

  void _listenToConnectivityChanges() {
    NetworkDiagnostic.onConnectivityChanged.listen((info) {
      setState(() => _connectionInfo = info);
      _showSnackBar('网络状态变化: ${info.type.displayName}');
    });
  }

  Future<void> _checkConnection() async {
    try {
      final info = await NetworkDiagnostic.checkConnection();
      setState(() => _connectionInfo = info);
    } catch (e) {
      _showError('检查网络连接失败: $e');
    }
  }

  Future<void> _runSpeedTest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _speedTestResult = null;
    });

    try {
      final result = await NetworkDiagnostic.runSpeedTest();
      setState(() {
        _speedTestResult = result;
        _isLoading = false;
      });
      _showSnackBar('测速完成！');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '网速测试失败: $e';
      });
    }
  }

  Future<void> _runPingTest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pingResult = null;
    });

    try {
      final result = await NetworkDiagnostic.ping(
        host: 'www.baidu.com',
        count: 10,
      );
      setState(() {
        _pingResult = result;
        _isLoading = false;
      });
      _showSnackBar('Ping测试完成！');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ping测试失败: $e';
      });
    }
  }

  Future<void> _evaluateQuality() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _qualityScore = null;
    });

    try {
      final result = await NetworkDiagnostic.evaluateQuality();
      setState(() {
        _qualityScore = result;
        _isLoading = false;
      });
      _showSnackBar('网络质量评估完成！');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '网络质量评估失败: $e';
      });
    }
  }

  void _showError(String message) {
    setState(() => _errorMessage = message);
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Diagnostic Kit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _checkConnection,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 错误信息
            if (_errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ),

            // 网络连接信息
            _buildConnectionCard(),
            const SizedBox(height: 16),

            // 操作按钮
            _buildActionButtons(),
            const SizedBox(height: 16),

            // 加载指示器
            if (_isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            // 网速测试结果
            if (_speedTestResult != null) _buildSpeedTestCard(),
            if (_speedTestResult != null) const SizedBox(height: 16),

            // Ping测试结果
            if (_pingResult != null) _buildPingResultCard(),
            if (_pingResult != null) const SizedBox(height: 16),

            // 网络质量评分
            if (_qualityScore != null) _buildQualityScoreCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _connectionInfo?.isConnected == true
                      ? Icons.wifi
                      : Icons.wifi_off,
                  color: _connectionInfo?.isConnected == true
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text('网络连接', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(),
            if (_connectionInfo != null) ...[
              _buildInfoRow(
                '状态',
                _connectionInfo!.isConnected ? '已连接' : '未连接',
                _connectionInfo!.isConnected ? Colors.green : Colors.red,
              ),
              _buildInfoRow('类型', _connectionInfo!.type.displayName),
              if (_connectionInfo!.ipAddress != null)
                _buildInfoRow('IP地址', _connectionInfo!.ipAddress!),
              if (_connectionInfo!.ssid != null)
                _buildInfoRow('WiFi', _connectionInfo!.ssid!),
            ] else
              const Text('正在检测...'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runSpeedTest,
              icon: const Icon(Icons.speed),
              label: const Text('网速测试'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runPingTest,
              icon: const Icon(Icons.network_ping),
              label: const Text('Ping测试'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _evaluateQuality,
              icon: const Icon(Icons.assessment),
              label: const Text('网络质量评估'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedTestCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.speed, color: Colors.blue),
                const SizedBox(width: 8),
                Text('网速测试结果', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(),
            _buildInfoRow(
              '下载速度',
              '${_speedTestResult!.downloadSpeed.toStringAsFixed(2)} Mbps',
              Colors.green,
            ),
            _buildInfoRow(
              '上传速度',
              '${_speedTestResult!.uploadSpeed.toStringAsFixed(2)} Mbps',
              Colors.orange,
            ),
            _buildInfoRow('延迟', '${_speedTestResult!.ping} ms'),
            _buildInfoRow(
              '抖动',
              '${_speedTestResult!.jitter.toStringAsFixed(2)} ms',
            ),
            _buildInfoRow(
              '丢包率',
              '${_speedTestResult!.packetLoss.toStringAsFixed(2)}%',
            ),
            if (_speedTestResult!.server != null)
              _buildInfoRow('服务器', _speedTestResult!.server!),
          ],
        ),
      ),
    );
  }

  Widget _buildPingResultCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.network_ping, color: Colors.purple),
                const SizedBox(width: 8),
                Text('Ping测试结果', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(),
            _buildInfoRow('目标主机', _pingResult!.host),
            _buildInfoRow('发送', '${_pingResult!.sent} 个包'),
            _buildInfoRow('接收', '${_pingResult!.received} 个包', Colors.green),
            _buildInfoRow(
              '丢失',
              '${_pingResult!.lost} 个包',
              _pingResult!.lost > 0 ? Colors.red : Colors.green,
            ),
            _buildInfoRow(
              '丢包率',
              '${_pingResult!.packetLoss.toStringAsFixed(1)}%',
            ),
            _buildInfoRow('最小延迟', '${_pingResult!.minTime} ms'),
            _buildInfoRow('最大延迟', '${_pingResult!.maxTime} ms'),
            _buildInfoRow(
              '平均延迟',
              '${_pingResult!.averageTime} ms',
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityScoreCard() {
    final score = _qualityScore!;
    Color scoreColor;
    if (score.score >= 80) {
      scoreColor = Colors.green;
    } else if (score.score >= 60) {
      scoreColor = Colors.blue;
    } else if (score.score >= 40) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assessment, color: Colors.teal),
                const SizedBox(width: 8),
                Text('网络质量评估', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(),
            Center(
              child: Column(
                children: [
                  Text(
                    '${score.score}',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                  Text(
                    score.level.displayName,
                    style: TextStyle(fontSize: 24, color: scoreColor),
                  ),
                ],
              ),
            ),
            const Divider(),
            Text('优化建议', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...score.suggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(suggestion)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: valueColor != null ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
