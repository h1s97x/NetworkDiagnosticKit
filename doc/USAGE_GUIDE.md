# network_diagnostic_kit 使用指南

本文档提供 network_diagnostic_kit 的详细使用指南和最佳实践。

## 目录

- [安装](#安装)
- [基础使用](#基础使用)
- [高级功能](#高级功能)
- [性能基准测试](#性能基准测试)
- [最佳实践](#最佳实践)
- [故障排查](#故障排查)

## 安装

### 添加依赖

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: main
```

### 导入包

```dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';
```

## 基础使用

### 1. 网络连接检测

```dart
// 检查当前网络连接状态
final connection = await NetworkDiagnostic.checkConnection();

print('网络类型: ${connection.type.displayName}');
print('是否连接: ${connection.isConnected}');
print('IP地址: ${connection.ipAddress}');
print('信号强度: ${connection.signalStrength}');
```

### 2. 网速测试

```dart
// 运行完整的网速测试
final speedTest = await NetworkDiagnostic.runSpeedTest(
  downloadUrl: 'https://example.com/test-file',
  uploadUrl: 'https://example.com/upload',
  timeout: Duration(seconds: 30),
);

print('下载速度: ${speedTest.downloadSpeed.toStringAsFixed(2)} Mbps');
print('上传速度: ${speedTest.uploadSpeed.toStringAsFixed(2)} Mbps');
print('延迟: ${speedTest.ping} ms');
print('抖动: ${speedTest.jitter.toStringAsFixed(2)} ms');
print('丢包率: ${speedTest.packetLoss.toStringAsFixed(2)}%');
```

### 3. Ping 测试

```dart
// 测试网络延迟
final pingResult = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  count: 10,
  timeout: Duration(seconds: 5),
);

print('发送: ${pingResult.sent}');
print('接收: ${pingResult.received}');
print('丢包: ${pingResult.lost}');
print('平均延迟: ${pingResult.averageTime} ms');
print('最小延迟: ${pingResult.minTime} ms');
print('最大延迟: ${pingResult.maxTime} ms');
```

### 4. DNS 测试

```dart
// 测试 DNS 解析速度
final dnsResults = await NetworkDiagnostic.testDns(
  domain: 'www.google.com',
  dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
  timeout: Duration(seconds: 5),
);

for (var result in dnsResults) {
  if (result.isSuccess) {
    print('DNS ${result.dnsServer}: ${result.responseTime}ms');
    print('  解析IP: ${result.resolvedIp}');
  } else {
    print('DNS ${result.dnsServer}: 失败 - ${result.errorMessage}');
  }
}
```

### 5. 网络质量评估

```dart
// 综合评估网络质量
final quality = await NetworkDiagnostic.evaluateQuality();

print('网络评分: ${quality.score}/100');
print('质量等级: ${quality.level.displayName}');
print('各项指标:');
quality.metrics.forEach((key, value) {
  print('  $key: $value');
});
print('优化建议:');
for (var suggestion in quality.suggestions) {
  print('  - $suggestion');
}
```

### 6. 端口检查

```dart
// 检查端口是否开放
final isOpen = await NetworkDiagnostic.checkPort(
  host: 'www.google.com',
  port: 443,
  timeout: Duration(seconds: 5),
);

print('端口 443 是否开放: $isOpen');
```

### 7. 监听网络变化

```dart
// 监听网络连接状态变化
final subscription = NetworkDiagnostic.onConnectivityChanged.listen((info) {
  print('网络状态变化:');
  print('  类型: ${info.type.displayName}');
  print('  是否连接: ${info.isConnected}');
  print('  IP地址: ${info.ipAddress}');
});

// 取消监听
subscription.cancel();
```

## 高级功能

### 完整的网络诊断示例

```dart
import 'package:flutter/material.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

class NetworkDiagnosticPage extends StatefulWidget {
  const NetworkDiagnosticPage({super.key});

  @override
  State<NetworkDiagnosticPage> createState() => _NetworkDiagnosticPageState();
}

class _NetworkDiagnosticPageState extends State<NetworkDiagnosticPage> {
  bool _isRunning = false;
  String _status = '准备就绪';
  Map<String, dynamic> _results = {};

  Future<void> _runFullDiagnostic() async {
    setState(() {
      _isRunning = true;
      _status = '正在检测...';
      _results = {};
    });

    try {
      // 1. 检查连接
      setState(() => _status = '检查网络连接...');
      final connection = await NetworkDiagnostic.checkConnection();
      _results['connection'] = connection;

      if (!connection.isConnected) {
        setState(() => _status = '网络未连接');
        return;
      }

      // 2. Ping 测试
      setState(() => _status = '测试网络延迟...');
      final ping = await NetworkDiagnostic.ping(
        host: 'www.google.com',
        count: 10,
      );
      _results['ping'] = ping;

      // 3. DNS 测试
      setState(() => _status = '测试 DNS 解析...');
      final dns = await NetworkDiagnostic.testDns(
        domain: 'www.google.com',
        dnsServers: ['8.8.8.8', '114.114.114.114'],
      );
      _results['dns'] = dns;

      // 4. 网速测试
      setState(() => _status = '测试网速...');
      final speed = await NetworkDiagnostic.runSpeedTest();
      _results['speed'] = speed;

      // 5. 质量评估
      setState(() => _status = '评估网络质量...');
      final quality = await NetworkDiagnostic.evaluateQuality();
      _results['quality'] = quality;

      setState(() => _status = '诊断完成');
    } catch (e) {
      setState(() => _status = '诊断失败: $e');
    } finally {
      setState(() => _isRunning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络诊断')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : _runFullDiagnostic,
              child: Text(_isRunning ? '诊断中...' : '开始诊断'),
            ),
            const SizedBox(height: 16),
            Text('状态: $_status'),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: _buildResults(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return const Center(child: Text('暂无结果'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _results.entries.map((entry) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(entry.value.toString()),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
```

## 性能基准测试

### 运行所有基准测试

```dart
// 运行完整的基准测试套件
final results = await NetworkBenchmark.runAll(
  iterations: 50,
  warmupIterations: 5,
);

print('测试套件: ${results.suiteName}');
print('总耗时: ${results.totalDuration}ms');
print('测试数量: ${results.results.length}');

for (var result in results.results) {
  print('\n${result.testName}:');
  print('  迭代次数: ${result.iterations}');
  print('  平均耗时: ${result.averageDuration.toStringAsFixed(2)}ms');
  print('  最小耗时: ${result.minDuration}ms');
  print('  最大耗时: ${result.maxDuration}ms');
  print('  标准差: ${result.standardDeviation.toStringAsFixed(2)}ms');
  print('  操作/秒: ${result.operationsPerSecond.toStringAsFixed(2)}');
}
```

### 单独测试各项功能

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
  dnsServers: ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
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
// 使用 BenchmarkRunner 创建自定义测试
final customResult = await BenchmarkRunner.run(
  testName: '自定义网络测试',
  test: () async {
    // 你的测试代码
    await NetworkDiagnostic.checkConnection();
    await NetworkDiagnostic.ping(host: 'www.google.com', count: 1);
  },
  iterations: 20,
  warmupIterations: 3,
  metadata: {
    'description': '组合测试',
    'version': '1.0',
  },
);

print('测试名称: ${customResult.testName}');
print('平均耗时: ${customResult.averageDuration.toStringAsFixed(2)}ms');
print('每秒操作数: ${customResult.operationsPerSecond.toStringAsFixed(2)}');
```

## 最佳实践

### 1. 错误处理

```dart
try {
  final result = await NetworkDiagnostic.runSpeedTest();
  print('网速测试成功: ${result.downloadSpeed} Mbps');
} on NetworkDiagnosticException catch (e) {
  print('网络诊断错误: ${e.message}');
  print('错误代码: ${e.code}');
} catch (e) {
  print('未知错误: $e');
}
```

### 2. 超时设置

```dart
// 为长时间操作设置合理的超时
final speedTest = await NetworkDiagnostic.runSpeedTest(
  timeout: Duration(seconds: 30),
);

final ping = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  count: 10,
  timeout: Duration(seconds: 10),
);
```

### 3. 资源管理

```dart
// 记得取消监听以避免内存泄漏
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

### 4. 批量测试

```dart
// 并发执行多个独立测试
final results = await Future.wait([
  NetworkDiagnostic.ping(host: 'www.google.com', count: 5),
  NetworkDiagnostic.testDns(
    domain: 'www.google.com',
    dnsServers: ['8.8.8.8'],
  ),
  NetworkDiagnostic.checkPort(host: 'www.google.com', port: 443),
]);

final pingResult = results[0] as PingResult;
final dnsResults = results[1] as List<DnsTestResult>;
final portOpen = results[2] as bool;
```

## 故障排查

### 问题 1: 网速测试失败

**症状**: `runSpeedTest()` 抛出异常或返回异常值

**解决方案**:
1. 检查网络连接是否正常
2. 确认测试 URL 可访问
3. 增加超时时间
4. 检查防火墙设置

```dart
try {
  final result = await NetworkDiagnostic.runSpeedTest(
    timeout: Duration(seconds: 60), // 增加超时
  );
} catch (e) {
  print('测试失败: $e');
}
```

### 问题 2: Ping 测试超时

**症状**: Ping 测试总是超时

**解决方案**:
1. 检查目标主机是否可达
2. 确认防火墙允许 ICMP
3. 尝试其他主机
4. 减少 ping 次数

```dart
final result = await NetworkDiagnostic.ping(
  host: 'www.baidu.com', // 尝试其他主机
  count: 4, // 减少次数
  timeout: Duration(seconds: 10),
);
```

### 问题 3: DNS 解析失败

**症状**: DNS 测试返回失败

**解决方案**:
1. 检查 DNS 服务器是否可用
2. 尝试其他 DNS 服务器
3. 检查域名是否正确

```dart
final results = await NetworkDiagnostic.testDns(
  domain: 'www.google.com',
  dnsServers: [
    '8.8.8.8',      // Google DNS
    '1.1.1.1',      // Cloudflare DNS
    '114.114.114.114', // 114 DNS
  ],
);
```

### 问题 4: 权限问题

**Android**: 确保在 `AndroidManifest.xml` 中添加了必要权限：

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
```

**iOS**: 确保在 `Info.plist` 中添加了网络权限说明。

## 更多资源

- [API 文档](doc/API.md) - 完整 API 参考
- [GitHub 仓库](https://github.com/h1s97x/NetworkDiagnosticKit)
- [问题追踪](https://github.com/h1s97x/NetworkDiagnosticKit/issues)
- [示例应用](https://github.com/h1s97x/NetworkDiagnosticKit/tree/main/example)

---

**文档版本**: 1.1  
**更新日期**: 2026-03-08  
**项目**: network_diagnostic_kit
