# network_diagnostic_kit API 参考

本文档提供 network_diagnostic_kit 的完整 API 参考。

## 目录

- [network\_diagnostic\_kit API 参考](#network_diagnostic_kit-api-参考)
  - [目录](#目录)
  - [NetworkDiagnostic](#networkdiagnostic)
    - [checkConnection](#checkconnection)
    - [runSpeedTest](#runspeedtest)
    - [ping](#ping)
    - [testDns](#testdns)
    - [evaluateQuality](#evaluatequality)
    - [checkPort](#checkport)
    - [onConnectivityChanged](#onconnectivitychanged)
  - [NetworkBenchmark](#networkbenchmark)
    - [runAll](#runall)
    - [benchmarkConnection](#benchmarkconnection)
    - [benchmarkPing](#benchmarkping)
    - [benchmarkDns](#benchmarkdns)
    - [benchmarkPortCheck](#benchmarkportcheck)
  - [BenchmarkRunner](#benchmarkrunner)
    - [run](#run)
    - [runSuite](#runsuite)
  - [数据模型](#数据模型)
    - [NetworkConnectionInfo](#networkconnectioninfo)
    - [SpeedTestResult](#speedtestresult)
    - [PingResult](#pingresult)
    - [DnsTestResult](#dnstestresult)
    - [NetworkQualityScore](#networkqualityscore)
    - [BenchmarkResult](#benchmarkresult)
    - [BenchmarkSuiteResult](#benchmarksuiteresult)
  - [枚举类型](#枚举类型)
    - [NetworkType](#networktype)
    - [QualityLevel](#qualitylevel)
  - [异常](#异常)
    - [NetworkDiagnosticException](#networkdiagnosticexception)
  - [完整示例](#完整示例)
  - [相关文档](#相关文档)

---

## NetworkDiagnostic

主要的网络诊断类，提供所有网络诊断功能。

### checkConnection

检查当前网络连接状态。

```dart
static Future<NetworkConnectionInfo> checkConnection()
```

**返回值**: `Future<NetworkConnectionInfo>` - 网络连接信息

**示例**:
```dart
final connection = await NetworkDiagnostic.checkConnection();
print('网络类型: ${connection.type.displayName}');
print('是否连接: ${connection.isConnected}');
print('IP地址: ${connection.ipAddress}');
```

---

### runSpeedTest

运行网速测试，测试下载/上传速度、延迟、抖动和丢包率。

```dart
static Future<SpeedTestResult> runSpeedTest({
  String? downloadUrl,
  String? uploadUrl,
  Duration timeout = const Duration(seconds: 30),
})
```

**参数**:
- `downloadUrl` (可选): 下载测试 URL
- `uploadUrl` (可选): 上传测试 URL
- `timeout` (可选): 超时时间，默认 30 秒

**返回值**: `Future<SpeedTestResult>` - 网速测试结果

**示例**:
```dart
final speedTest = await NetworkDiagnostic.runSpeedTest(
  timeout: Duration(seconds: 30),
);
print('下载速度: ${speedTest.downloadSpeed} Mbps');
print('上传速度: ${speedTest.uploadSpeed} Mbps');
```

---

### ping

执行 Ping 测试，测试网络延迟和稳定性。

```dart
static Future<PingResult> ping({
  required String host,
  int count = 4,
  Duration timeout = const Duration(seconds: 5),
})
```

**参数**:
- `host` (必需): 目标主机地址
- `count` (可选): Ping 次数，默认 4 次
- `timeout` (可选): 超时时间，默认 5 秒

**返回值**: `Future<PingResult>` - Ping 测试结果

**示例**:
```dart
final pingResult = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  count: 10,
);
print('平均延迟: ${pingResult.averageTime} ms');
print('丢包率: ${pingResult.packetLoss}%');
```

---

### testDns

测试 DNS 解析速度和可用性。

```dart
static Future<List<DnsTestResult>> testDns({
  required String domain,
  required List<String> dnsServers,
  Duration timeout = const Duration(seconds: 5),
})
```

**参数**:
- `domain` (必需): 要解析的域名
- `dnsServers` (必需): DNS 服务器列表
- `timeout` (可选): 超时时间，默认 5 秒

**返回值**: `Future<List<DnsTestResult>>` - DNS 测试结果列表

**示例**:
```dart
final dnsResults = await NetworkDiagnostic.testDns(
  domain: 'www.google.com',
  dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
);

for (var result in dnsResults) {
  print('DNS ${result.dnsServer}: ${result.responseTime}ms');
}
```

---

### evaluateQuality

综合评估网络质量并提供优化建议。

```dart
static Future<NetworkQualityScore> evaluateQuality()
```

**返回值**: `Future<NetworkQualityScore>` - 网络质量评分

**示例**:
```dart
final quality = await NetworkDiagnostic.evaluateQuality();
print('网络评分: ${quality.score}/100');
print('质量等级: ${quality.level.displayName}');
for (var suggestion in quality.suggestions) {
  print('建议: $suggestion');
}
```

---

### checkPort

检查指定端口是否开放。

```dart
static Future<bool> checkPort({
  required String host,
  required int port,
  Duration timeout = const Duration(seconds: 5),
})
```

**参数**:
- `host` (必需): 目标主机地址
- `port` (必需): 端口号
- `timeout` (可选): 超时时间，默认 5 秒

**返回值**: `Future<bool>` - 端口是否开放

**示例**:
```dart
final isOpen = await NetworkDiagnostic.checkPort(
  host: 'www.google.com',
  port: 443,
);
print('端口 443 是否开放: $isOpen');
```

---

### onConnectivityChanged

监听网络连接状态变化。

```dart
static Stream<NetworkConnectionInfo> get onConnectivityChanged
```

**返回值**: `Stream<NetworkConnectionInfo>` - 网络连接信息流

**示例**:
```dart
final subscription = NetworkDiagnostic.onConnectivityChanged.listen((info) {
  print('网络状态变化: ${info.type.displayName}');
  print('是否连接: ${info.isConnected}');
});

// 取消监听
subscription.cancel();
```

---

## NetworkBenchmark

网络诊断性能基准测试类。

### runAll

运行所有网络诊断功能的基准测试。

```dart
static Future<BenchmarkSuiteResult> runAll({
  int iterations = 50,
  int warmupIterations = 5,
})
```

**参数**:
- `iterations` (可选): 迭代次数，默认 50
- `warmupIterations` (可选): 预热迭代次数，默认 5

**返回值**: `Future<BenchmarkSuiteResult>` - 基准测试套件结果

**示例**:
```dart
final results = await NetworkBenchmark.runAll(
  iterations: 50,
  warmupIterations: 5,
);
print('总耗时: ${results.totalDuration}ms');
```

---

### benchmarkConnection

测试连接检查功能的性能。

```dart
static Future<BenchmarkSuiteResult> benchmarkConnection({
  int iterations = 100,
})
```

---

### benchmarkPing

测试 Ping 功能的性能。

```dart
static Future<BenchmarkSuiteResult> benchmarkPing({
  int iterations = 30,
  List<String> hosts = const ['www.baidu.com', 'www.google.com'],
})
```

---

### benchmarkDns

测试 DNS 解析功能的性能。

```dart
static Future<BenchmarkSuiteResult> benchmarkDns({
  int iterations = 50,
  String domain = 'www.google.com',
  List<String> dnsServers = const ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
})
```

---

### benchmarkPortCheck

测试端口检查功能的性能。

```dart
static Future<BenchmarkSuiteResult> benchmarkPortCheck({
  int iterations = 50,
  String host = 'www.baidu.com',
  List<int> ports = const [80, 443, 8080],
})
```

---

## BenchmarkRunner

通用基准测试运行器。

### run

运行单个基准测试。

```dart
static Future<BenchmarkResult> run({
  required String testName,
  required Future<void> Function() test,
  int iterations = 100,
  int warmupIterations = 10,
  Map<String, dynamic>? metadata,
})
```

**参数**:
- `testName` (必需): 测试名称
- `test` (必需): 要测试的异步函数
- `iterations` (可选): 迭代次数，默认 100
- `warmupIterations` (可选): 预热迭代次数，默认 10
- `metadata` (可选): 附加元数据

**示例**:
```dart
final result = await BenchmarkRunner.run(
  testName: '自定义测试',
  test: () async {
    await NetworkDiagnostic.checkConnection();
  },
  iterations: 50,
);
print('平均耗时: ${result.averageDuration}ms');
```

---

### runSuite

运行基准测试套件。

```dart
static Future<BenchmarkSuiteResult> runSuite({
  required String suiteName,
  required Map<String, Future<void> Function()> tests,
  int iterations = 100,
  int warmupIterations = 10,
  Map<String, dynamic>? deviceInfo,
})
```

---

## 数据模型

### NetworkConnectionInfo

网络连接信息。

```dart
class NetworkConnectionInfo {
  final bool isConnected;        // 是否已连接
  final NetworkType type;        // 网络类型
  final String? ssid;            // WiFi 名称
  final int? signalStrength;     // 信号强度 (0-100)
  final String? ipAddress;       // IP 地址
  final String? gateway;         // 网关地址
  final String? ipv6Address;     // IPv6 地址
  final String? macAddress;      // MAC 地址
}
```

---

### SpeedTestResult

网速测试结果。

```dart
class SpeedTestResult {
  final double downloadSpeed;    // 下载速度 (Mbps)
  final double uploadSpeed;      // 上传速度 (Mbps)
  final int ping;                // 延迟 (ms)
  final double jitter;           // 抖动 (ms)
  final double packetLoss;       // 丢包率 (%)
  final DateTime timestamp;      // 测试时间
  final String? server;          // 测试服务器
}
```

---

### PingResult

Ping 测试结果。

```dart
class PingResult {
  final String host;             // 目标主机
  final int sent;                // 发送数量
  final int received;            // 接收数量
  final int lost;                // 丢包数量
  final double packetLoss;       // 丢包率 (%)
  final int minTime;             // 最小延迟 (ms)
  final int maxTime;             // 最大延迟 (ms)
  final int averageTime;         // 平均延迟 (ms)
  final List<int> times;         // 每次 ping 的结果
}
```

---

### DnsTestResult

DNS 测试结果。

```dart
class DnsTestResult {
  final String dnsServer;        // DNS 服务器
  final String domain;           // 域名
  final bool isSuccess;          // 是否成功
  final int responseTime;        // 响应时间 (ms)
  final String? resolvedIp;      // 解析的 IP 地址
  final String? errorMessage;    // 错误信息
}
```

---

### NetworkQualityScore

网络质量评分。

```dart
class NetworkQualityScore {
  final int score;               // 评分 (0-100)
  final QualityLevel level;      // 质量等级
  final Map<String, dynamic> metrics;  // 各项指标
  final List<String> suggestions;      // 优化建议
  final DateTime timestamp;      // 评估时间
}
```

---

### BenchmarkResult

基准测试结果。

```dart
class BenchmarkResult {
  final String testName;         // 测试名称
  final int iterations;          // 迭代次数
  final int totalDuration;       // 总耗时 (ms)
  final double averageDuration;  // 平均耗时 (ms)
  final int minDuration;         // 最小耗时 (ms)
  final int maxDuration;         // 最大耗时 (ms)
  final double standardDeviation; // 标准差
  final double operationsPerSecond; // 每秒操作数
  final DateTime timestamp;      // 测试时间
  final Map<String, dynamic>? metadata; // 元数据
}
```

---

### BenchmarkSuiteResult

基准测试套件结果。

```dart
class BenchmarkSuiteResult {
  final String suiteName;        // 套件名称
  final List<BenchmarkResult> results; // 测试结果列表
  final int totalDuration;       // 总耗时 (ms)
  final DateTime timestamp;      // 测试时间
  final Map<String, dynamic>? deviceInfo; // 设备信息
}
```

---

## 枚举类型

### NetworkType

网络类型枚举。

```dart
enum NetworkType {
  none,       // 无网络
  wifi,       // WiFi
  mobile,     // 移动网络
  ethernet,   // 以太网
  bluetooth,  // 蓝牙
  vpn,        // VPN
  other,      // 其他
}
```

---

### QualityLevel

网络质量等级枚举。

```dart
enum QualityLevel {
  excellent,  // 优秀 (90-100)
  good,       // 良好 (70-89)
  fair,       // 一般 (50-69)
  poor,       // 较差 (30-49)
  bad,        // 很差 (0-29)
}
```

---

## 异常

### NetworkDiagnosticException

网络诊断异常。

```dart
class NetworkDiagnosticException implements Exception {
  final String message;          // 错误信息
  final String? code;            // 错误代码
  final dynamic details;         // 详细信息
}
```

**示例**:
```dart
try {
  final result = await NetworkDiagnostic.runSpeedTest();
} on NetworkDiagnosticException catch (e) {
  print('错误: ${e.message}');
  print('代码: ${e.code}');
}
```

---

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

class NetworkDiagnosticPage extends StatefulWidget {
  const NetworkDiagnosticPage({super.key});

  @override
  State<NetworkDiagnosticPage> createState() => _NetworkDiagnosticPageState();
}

class _NetworkDiagnosticPageState extends State<NetworkDiagnosticPage> {
  NetworkConnectionInfo? _connection;
  SpeedTestResult? _speedTest;
  PingResult? _pingResult;
  NetworkQualityScore? _quality;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    try {
      // 检查连接
      final connection = await NetworkDiagnostic.checkConnection();
      setState(() => _connection = connection);

      if (!connection.isConnected) return;

      // Ping 测试
      final ping = await NetworkDiagnostic.ping(
        host: 'www.google.com',
        count: 10,
      );
      setState(() => _pingResult = ping);

      // 网速测试
      final speed = await NetworkDiagnostic.runSpeedTest();
      setState(() => _speedTest = speed);

      // 质量评估
      final quality = await NetworkDiagnostic.evaluateQuality();
      setState(() => _quality = quality);
    } catch (e) {
      print('诊断失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络诊断')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_connection != null) _buildConnectionCard(),
          if (_pingResult != null) _buildPingCard(),
          if (_speedTest != null) _buildSpeedCard(),
          if (_quality != null) _buildQualityCard(),
        ],
      ),
    );
  }

  Widget _buildConnectionCard() {
    return Card(
      child: ListTile(
        title: const Text('网络连接'),
        subtitle: Text(
          '类型: ${_connection!.type.displayName}\n'
          'IP: ${_connection!.ipAddress ?? "未知"}',
        ),
      ),
    );
  }

  Widget _buildPingCard() {
    return Card(
      child: ListTile(
        title: const Text('Ping 测试'),
        subtitle: Text(
          '平均延迟: ${_pingResult!.averageTime}ms\n'
          '丢包率: ${_pingResult!.packetLoss.toStringAsFixed(1)}%',
        ),
      ),
    );
  }

  Widget _buildSpeedCard() {
    return Card(
      child: ListTile(
        title: const Text('网速测试'),
        subtitle: Text(
          '下载: ${_speedTest!.downloadSpeed.toStringAsFixed(2)} Mbps\n'
          '上传: ${_speedTest!.uploadSpeed.toStringAsFixed(2)} Mbps',
        ),
      ),
    );
  }

  Widget _buildQualityCard() {
    return Card(
      child: ListTile(
        title: const Text('网络质量'),
        subtitle: Text(
          '评分: ${_quality!.score}/100\n'
          '等级: ${_quality!.level.displayName}',
        ),
      ),
    );
  }
}
```

---

## 相关文档

- [快速参考](QUICK_REFERENCE.md)
- [架构设计](ARCHITECTURE.md)
- [基准测试指南](BENCHMARK_GUIDE.md)
- [代码风格指南](CODE_STYLE.md)

---

**文档版本**: 1.1  
**更新日期**: 2026-03-08  
**项目**: network_diagnostic_kit
