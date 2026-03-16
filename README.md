# network_diagnostic_kit

一个用于网络诊断的 Flutter 插件，提供网速测试、DNS测试、Ping测试和网络质量评估等功能。

## 功能特性

- 🌐 **网络连接检测** - 检测网络连通性和类型
- 🚀 **网速测试** - 测试下载/上传速度、延迟、抖动和丢包率
- 🔍 **DNS测试** - 测试DNS解析速度和可用性
- 📡 **Ping测试** - 测试网络延迟和稳定性
- 📊 **网络质量评分** - 综合评估网络质量并提供优化建议
- 🔌 **端口扫描** - 检测指定端口是否开放
- 🔄 **实时监听** - 监听网络连接状态变化
- ⚡ **性能基准测试** - 测试各项功能的性能指标

## 支持平台

| 平台 | 支持状态 |
|----------|---------|
| Android  | ✅ 支持 |
| iOS      | ✅ 支持 |
| Windows  | ✅ 支持 |
| Linux    | ✅ 支持 |
| macOS    | ✅ 支持 |
| Web      | ⚠️ 部分支持 |

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: main
```

然后运行：

```bash
flutter pub get
```

## 使用方法

### 1. 检查网络连接

```dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

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
print('下载速度: ${speedTest.downloadSpeed.toStringAsFixed(2)} Mbps');
print('上传速度: ${speedTest.uploadSpeed.toStringAsFixed(2)} Mbps');
print('延迟: ${speedTest.ping} ms');
print('抖动: ${speedTest.jitter.toStringAsFixed(2)} ms');
print('丢包率: ${speedTest.packetLoss.toStringAsFixed(2)}%');
```

### 3. Ping测试

```dart
// Ping测试
final pingResult = await NetworkDiagnostic.ping(
  host: 'www.baidu.com',
  count: 10,
);
print('平均延迟: ${pingResult.averageTime} ms');
print('丢包率: ${pingResult.packetLoss.toStringAsFixed(1)}%');
```

### 4. DNS测试

```dart
// DNS测试
final dnsResults = await NetworkDiagnostic.testDns(
  domain: 'www.sdu.edu.cn',
  dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
);

for (var result in dnsResults) {
  print('DNS ${result.dnsServer}: ${result.responseTime}ms');
  if (result.isSuccess) {
    print('  解析IP: ${result.resolvedIp}');
  } else {
    print('  失败: ${result.errorMessage}');
  }
}
```

### 5. 网络质量评估

```dart
// 评估网络质量
final quality = await NetworkDiagnostic.evaluateQuality();
print('网络评分: ${quality.score}/100');
print('质量等级: ${quality.level.displayName}');
print('优化建议:');
for (var suggestion in quality.suggestions) {
  print('  - $suggestion');
}
```

### 6. 端口扫描

```dart
// 检查端口是否开放
final isOpen = await NetworkDiagnostic.checkPort(
  host: 'www.sdu.edu.cn',
  port: 80,
);
print('端口80是否开放: $isOpen');
```

### 7. 监听网络变化

```dart
// 监听网络连接状态变化
NetworkDiagnostic.onConnectivityChanged.listen((info) {
  print('网络状态变化: ${info.type.displayName}');
  print('是否连接: ${info.isConnected}');
});
```

### 8. 性能基准测试

```dart
// 运行所有基准测试
final benchmarkResults = await NetworkBenchmark.runAll(
  iterations: 50,
  warmupIterations: 5,
);
print('测试套件: ${benchmarkResults.suiteName}');
print('总耗时: ${benchmarkResults.totalDuration}ms');

for (var result in benchmarkResults.results) {
  print('${result.testName}:');
  print('  平均耗时: ${result.averageDuration.toStringAsFixed(2)}ms');
  print('  操作/秒: ${result.operationsPerSecond.toStringAsFixed(2)}');
}

// 单独测试连接检查性能
final connectionBenchmark = await NetworkBenchmark.benchmarkConnection(
  iterations: 100,
);

// 测试Ping性能
final pingBenchmark = await NetworkBenchmark.benchmarkPing(
  iterations: 30,
  hosts: ['www.baidu.com', 'www.google.com'],
);

// 测试DNS解析性能
final dnsBenchmark = await NetworkBenchmark.benchmarkDns(
  iterations: 50,
  domain: 'www.google.com',
  dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
);

// 测试端口检查性能
final portBenchmark = await NetworkBenchmark.benchmarkPortCheck(
  iterations: 50,
  host: 'www.baidu.com',
  ports: [80, 443, 8080],
);
```

## API 参考

### NetworkDiagnostic

主要的网络诊断类。

#### 方法

- `static Future<NetworkConnectionInfo> checkConnection()` - 检查网络连接
- `static Future<SpeedTestResult> runSpeedTest({...})` - 运行网速测试
- `static Future<PingResult> ping({...})` - Ping测试
- `static Future<List<DnsTestResult>> testDns({...})` - DNS测试
- `static Future<NetworkQualityScore> evaluateQuality()` - 评估网络质量
- `static Future<bool> checkPort({...})` - 检查端口
- `static Stream<NetworkConnectionInfo> get onConnectivityChanged` - 监听网络变化

### NetworkBenchmark

性能基准测试类。

#### 方法

- `static Future<BenchmarkSuiteResult> runAll({...})` - 运行所有基准测试
- `static Future<BenchmarkSuiteResult> benchmarkConnection({...})` - 测试连接检查性能
- `static Future<BenchmarkSuiteResult> benchmarkPing({...})` - 测试Ping性能
- `static Future<BenchmarkSuiteResult> benchmarkDns({...})` - 测试DNS解析性能
- `static Future<BenchmarkSuiteResult> benchmarkPortCheck({...})` - 测试端口检查性能

### 数据模型

#### NetworkConnectionInfo - 网络连接信息

```dart
class NetworkConnectionInfo {
  final bool isConnected;        // 是否已连接
  final NetworkType type;        // 网络类型
  final String? ssid;            // WiFi名称
  final int? signalStrength;     // 信号强度 (0-100)
  final String? ipAddress;       // IP地址
  final String? gateway;         // 网关地址
  final String? ipv6Address;     // IPv6地址
  final String? macAddress;      // MAC地址
}
```

#### SpeedTestResult - 网速测试结果

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

#### PingResult - Ping测试结果

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
  final List<int> times;         // 每次ping的结果
}
```

#### NetworkQualityScore - 网络质量评分

```dart
class NetworkQualityScore {
  final int score;               // 评分 (0-100)
  final QualityLevel level;      // 质量等级
  final Map<String, dynamic> metrics;  // 各项指标
  final List<String> suggestions;      // 优化建议
  final DateTime timestamp;      // 评估时间
}
```

#### BenchmarkResult - 基准测试结果

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
}
```

#### BenchmarkSuiteResult - 基准测试套件结果

```dart
class BenchmarkSuiteResult {
  final String suiteName;        // 套件名称
  final List<BenchmarkResult> results; // 测试结果列表
  final int totalDuration;       // 总耗时 (ms)
  final DateTime timestamp;      // 测试时间
}
```

## 示例应用

查看 [example](example) 目录获取完整示例应用。

运行示例：

```bash
cd example
flutter run -d windows  # 或 -d android
```

## 性能说明

- 所有方法都是异步非阻塞的
- 网速测试默认超时30秒
- Ping测试默认发送4个包
- DNS测试支持多个DNS服务器并发测试
- 基准测试包含预热阶段，确保结果准确性

## 基准测试

项目提供了完整的性能基准测试工具，可以评估各项功能的性能表现。

### 运行基准测试

#### 方式1：在Flutter应用中运行

```dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

// 运行所有基准测试
final results = await NetworkBenchmark.runAll();
print(results);
```

#### 方式2：使用独立脚本

```bash
dart benchmark/network_benchmark_test.dart
```

### 基准测试输出示例

```
=== Running All Benchmarks ===
Suite: Network Diagnostic Kit Benchmarks
Total Duration: 15234ms
Tests: 4
---
  checkConnection:
    Iterations: 50
    Average: 45.23ms
    Min: 32ms
    Max: 89ms
    Std Dev: 12.45ms
    Ops/sec: 22.11
  ping_baidu:
    Iterations: 50
    Average: 156.78ms
    Min: 142ms
    Max: 201ms
    Std Dev: 15.67ms
    Ops/sec: 6.38
```

### 自定义基准测试

```dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

// 使用BenchmarkRunner创建自定义测试
final result = await BenchmarkRunner.run(
  testName: 'Custom Test',
  test: () async {
    // 你的测试代码
    await NetworkDiagnostic.checkConnection();
  },
  iterations: 100,
  warmupIterations: 10,
);

print('Average: ${result.averageDuration}ms');
print('Ops/sec: ${result.operationsPerSecond}');
```

## 注意事项

### Android

需要在 `AndroidManifest.xml` 中添加网络权限：

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### iOS

需要在 `Info.plist` 中添加网络权限说明。

### Windows

需要确保防火墙允许应用访问网络。

## 故障排查

### 问题：网速测试失败

**解决**：
1. 检查网络连接
2. 确认防火墙设置
3. 尝试使用自定义测试URL

### 问题：Ping测试超时

**解决**：
1. 增加超时时间
2. 检查目标主机是否可达
3. 确认防火墙允许ICMP

## 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件。

## 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解版本历史。

## 致谢

- [connectivity_plus](https://pub.dev/packages/connectivity_plus) - 网络连接检测
- [http](https://pub.dev/packages/http) - HTTP请求

---

**问题反馈**: [GitHub Issues](https://github.com/h1s97x/NetworkDiagnosticKit/issues)
