# network_diagnostic_kit 快速参考

本文档提供 network_diagnostic_kit 的快速参考指南。

## 快速开始

### 安装

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: main
```

### 导入

```dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';
```

---

## 核心功能

### 1. 网络连接检测

```dart
// 检查当前网络连接
final connection = await NetworkDiagnostic.checkConnection();
print('网络类型: ${connection.type.displayName}');
print('是否连接: ${connection.isConnected}');
print('IP地址: ${connection.ipAddress}');
```

### 2. 网速测试

```dart
// 运行网速测试
final speedTest = await NetworkDiagnostic.runSpeedTest();
print('下载速度: ${speedTest.downloadSpeed} Mbps');
print('上传速度: ${speedTest.uploadSpeed} Mbps');
print('延迟: ${speedTest.ping} ms');
```

### 3. Ping 测试

```dart
// Ping 测试
final pingResult = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  count: 10,
);
print('平均延迟: ${pingResult.averageTime} ms');
print('丢包率: ${pingResult.packetLoss}%');
```

### 4. DNS 测试

```dart
// DNS 解析测试
final dnsResults = await NetworkDiagnostic.testDns(
  domain: 'www.google.com',
  dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
);

for (var result in dnsResults) {
  print('DNS ${result.dnsServer}: ${result.responseTime}ms');
}
```

### 5. 网络质量评估

```dart
// 评估网络质量
final quality = await NetworkDiagnostic.evaluateQuality();
print('网络评分: ${quality.score}/100');
print('质量等级: ${quality.level.displayName}');
```

### 6. 端口检查

```dart
// 检查端口是否开放
final isOpen = await NetworkDiagnostic.checkPort(
  host: 'www.google.com',
  port: 443,
);
print('端口 443 是否开放: $isOpen');
```

### 7. 监听网络变化

```dart
// 监听网络状态变化
final subscription = NetworkDiagnostic.onConnectivityChanged.listen((info) {
  print('网络状态变化: ${info.type.displayName}');
});

// 取消监听
subscription.cancel();
```

---

## 性能基准测试

### 运行所有基准测试

```dart
final results = await NetworkBenchmark.runAll(
  iterations: 50,
  warmupIterations: 5,
);

print('测试套件: ${results.suiteName}');
print('总耗时: ${results.totalDuration}ms');

for (var result in results.results) {
  print('${result.testName}: ${result.averageDuration.toStringAsFixed(2)}ms');
}
```

### 单项基准测试

```dart
// 测试连接检查性能
final connectionBench = await NetworkBenchmark.benchmarkConnection(
  iterations: 100,
);

// 测试 Ping 性能
final pingBench = await NetworkBenchmark.benchmarkPing(
  iterations: 30,
  hosts: ['www.baidu.com', 'www.google.com'],
);

// 测试 DNS 性能
final dnsBench = await NetworkBenchmark.benchmarkDns(
  iterations: 50,
  domain: 'www.google.com',
  dnsServers: ['8.8.8.8', '114.114.114.114'],
);

// 测试端口检查性能
final portBench = await NetworkBenchmark.benchmarkPortCheck(
  iterations: 50,
  host: 'www.baidu.com',
  ports: [80, 443, 8080],
);
```

### 自定义基准测试

```dart
final result = await BenchmarkRunner.run(
  testName: '自定义测试',
  test: () async {
    await NetworkDiagnostic.checkConnection();
  },
  iterations: 100,
  warmupIterations: 10,
);

print('平均耗时: ${result.averageDuration.toStringAsFixed(2)}ms');
print('每秒操作数: ${result.operationsPerSecond.toStringAsFixed(2)}');
```

---

## 数据模型

### NetworkConnectionInfo

```dart
class NetworkConnectionInfo {
  bool isConnected;        // 是否已连接
  NetworkType type;        // 网络类型
  String? ssid;            // WiFi 名称
  int? signalStrength;     // 信号强度 (0-100)
  String? ipAddress;       // IP 地址
  String? gateway;         // 网关地址
  String? ipv6Address;     // IPv6 地址
  String? macAddress;      // MAC 地址
}
```

### SpeedTestResult

```dart
class SpeedTestResult {
  double downloadSpeed;    // 下载速度 (Mbps)
  double uploadSpeed;      // 上传速度 (Mbps)
  int ping;                // 延迟 (ms)
  double jitter;           // 抖动 (ms)
  double packetLoss;       // 丢包率 (%)
  DateTime timestamp;      // 测试时间
  String? server;          // 测试服务器
}
```

### PingResult

```dart
class PingResult {
  String host;             // 目标主机
  int sent;                // 发送数量
  int received;            // 接收数量
  int lost;                // 丢包数量
  double packetLoss;       // 丢包率 (%)
  int minTime;             // 最小延迟 (ms)
  int maxTime;             // 最大延迟 (ms)
  int averageTime;         // 平均延迟 (ms)
  List<int> times;         // 每次 ping 的结果
}
```

### DnsTestResult

```dart
class DnsTestResult {
  String dnsServer;        // DNS 服务器
  String domain;           // 域名
  bool isSuccess;          // 是否成功
  int responseTime;        // 响应时间 (ms)
  String? resolvedIp;      // 解析的 IP 地址
  String? errorMessage;    // 错误信息
}
```

### NetworkQualityScore

```dart
class NetworkQualityScore {
  int score;               // 评分 (0-100)
  QualityLevel level;      // 质量等级
  Map<String, dynamic> metrics;  // 各项指标
  List<String> suggestions;      // 优化建议
  DateTime timestamp;      // 评估时间
}
```

### BenchmarkResult

```dart
class BenchmarkResult {
  String testName;         // 测试名称
  int iterations;          // 迭代次数
  int totalDuration;       // 总耗时 (ms)
  double averageDuration;  // 平均耗时 (ms)
  int minDuration;         // 最小耗时 (ms)
  int maxDuration;         // 最大耗时 (ms)
  double standardDeviation; // 标准差
  double operationsPerSecond; // 每秒操作数
  DateTime timestamp;      // 测试时间
}
```

---

## 枚举类型

### NetworkType

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

### QualityLevel

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

## 异常处理

```dart
try {
  final result = await NetworkDiagnostic.runSpeedTest();
  print('测试成功: ${result.downloadSpeed} Mbps');
} on NetworkDiagnosticException catch (e) {
  print('网络诊断错误: ${e.message}');
  print('错误代码: ${e.code}');
} catch (e) {
  print('未知错误: $e');
}
```

---

## 常用参数

### 超时设置

```dart
// 网速测试超时
final speedTest = await NetworkDiagnostic.runSpeedTest(
  timeout: Duration(seconds: 30),
);

// Ping 测试超时
final ping = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  timeout: Duration(seconds: 5),
);

// DNS 测试超时
final dns = await NetworkDiagnostic.testDns(
  domain: 'www.google.com',
  dnsServers: ['8.8.8.8'],
  timeout: Duration(seconds: 5),
);
```

### Ping 次数

```dart
// 默认 4 次
final ping1 = await NetworkDiagnostic.ping(host: 'www.google.com');

// 自定义次数
final ping2 = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  count: 10,
);
```

### DNS 服务器

```dart
// 常用 DNS 服务器
final dnsResults = await NetworkDiagnostic.testDns(
  domain: 'www.google.com',
  dnsServers: [
    '8.8.8.8',          // Google DNS
    '8.8.4.4',          // Google DNS 备用
    '1.1.1.1',          // Cloudflare DNS
    '1.0.0.1',          // Cloudflare DNS 备用
    '114.114.114.114',  // 114 DNS
    '223.5.5.5',        // 阿里 DNS
  ],
);
```

---

## 最佳实践

### 1. 错误处理

```dart
try {
  final result = await NetworkDiagnostic.checkConnection();
  if (result.isConnected) {
    // 执行网络操作
  } else {
    // 处理未连接情况
  }
} catch (e) {
  // 处理错误
}
```

### 2. 资源管理

```dart
StreamSubscription? _subscription;

void startListening() {
  _subscription = NetworkDiagnostic.onConnectivityChanged.listen((info) {
    // 处理网络变化
  });
}

void stopListening() {
  _subscription?.cancel();
  _subscription = null;
}

@override
void dispose() {
  stopListening();
  super.dispose();
}
```

### 3. 并发执行

```dart
// 并行执行多个测试
final results = await Future.wait([
  NetworkDiagnostic.ping(host: 'www.google.com', count: 5),
  NetworkDiagnostic.testDns(
    domain: 'www.google.com',
    dnsServers: ['8.8.8.8'],
  ),
  NetworkDiagnostic.checkPort(host: 'www.google.com', port: 443),
]);
```

### 4. 超时控制

```dart
// 为长时间操作设置超时
try {
  final result = await NetworkDiagnostic.runSpeedTest(
    timeout: Duration(seconds: 30),
  ).timeout(
    Duration(seconds: 35),
    onTimeout: () {
      throw TimeoutException('Speed test timeout');
    },
  );
} on TimeoutException {
  print('测试超时');
}
```

---

## 平台权限

### Android

在 `AndroidManifest.xml` 中添加：

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
```

### iOS

在 `Info.plist` 中添加网络权限说明。

### Windows

确保防火墙允许应用访问网络。

---

## 常见问题

### Q: 网速测试失败？

A: 检查网络连接、防火墙设置，增加超时时间。

### Q: Ping 测试超时？

A: 检查目标主机是否可达，确认防火墙允许 ICMP。

### Q: DNS 解析失败？

A: 尝试其他 DNS 服务器，检查域名是否正确。

---

## 相关资源

- [完整 API 文档](API.md)
- [架构设计](ARCHITECTURE.md)
- [代码风格指南](CODE_STYLE.md)
- [基准测试指南](BENCHMARK_GUIDE.md)
- [贡献指南](../CONTRIBUTING.md)
- [GitHub 仓库](https://github.com/h1s97x/NetworkDiagnosticKit)

---

**文档版本**: 1.1  
**创建日期**: 2026-03-08  
**项目**: network_diagnostic_kit
