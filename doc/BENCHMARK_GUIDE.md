# network_diagnostic_kit 基准测试指南

本文档提供 network_diagnostic_kit 性能基准测试的完整指南。

## 目录

- [概述](#概述)
- [快速开始](#快速开始)
- [基准测试类型](#基准测试类型)
- [自定义基准测试](#自定义基准测试)
- [结果分析](#结果分析)
- [最佳实践](#最佳实践)
- [性能优化](#性能优化)

---

## 概述

基准测试系统用于测量和分析网络诊断功能的性能。它提供详细的性能指标，帮助开发者：

- 评估功能性能
- 发现性能瓶颈
- 验证性能优化效果
- 比较不同实现方案

### 核心组件

1. **BenchmarkRunner** - 通用基准测试运行器
2. **NetworkBenchmark** - 网络诊断专用基准测试
3. **BenchmarkResult** - 单个测试结果
4. **BenchmarkSuiteResult** - 测试套件结果

---

## 快速开始

### 安装

确保已安装 network_diagnostic_kit：

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: main
```

### 运行基准测试

#### 方式 1: 在 Flutter 应用中

```dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

void main() async {
  final results = await NetworkBenchmark.runAll();
  print(results);
}
```

#### 方式 2: 使用独立脚本

```bash
dart benchmark/network_benchmark_test.dart
```

#### 方式 3: 在示例应用中

```bash
cd example
flutter run
# 导航到 "Benchmark" 页面
```

---

## 基准测试类型

### 1. 全面基准测试

测试所有网络诊断功能的性能。

```dart
final results = await NetworkBenchmark.runAll(
  iterations: 50,        // 迭代次数
  warmupIterations: 5,   // 预热次数
);

print('测试套件: ${results.suiteName}');
print('总耗时: ${results.totalDuration}ms');

for (var result in results.results) {
  print('${result.testName}:');
  print('  平均耗时: ${result.averageDuration.toStringAsFixed(2)}ms');
  print('  最小耗时: ${result.minDuration}ms');
  print('  最大耗时: ${result.maxDuration}ms');
  print('  标准差: ${result.standardDeviation.toStringAsFixed(2)}ms');
  print('  操作/秒: ${result.operationsPerSecond.toStringAsFixed(2)}');
}
```

### 2. 连接检查基准测试

专门测试网络连接检查的性能。

```dart
final results = await NetworkBenchmark.benchmarkConnection(
  iterations: 100,
);

final result = results.results.first;
print('连接检查平均耗时: ${result.averageDuration}ms');
print('每秒可执行: ${result.operationsPerSecond.toStringAsFixed(2)} 次');
```

### 3. Ping 基准测试

测试 Ping 功能的性能，支持多个主机。

```dart
final results = await NetworkBenchmark.benchmarkPing(
  iterations: 30,
  hosts: [
    'www.baidu.com',
    'www.google.com',
    '8.8.8.8',
  ],
);

for (var result in results.results) {
  print('${result.testName}: ${result.averageDuration.toStringAsFixed(2)}ms');
}
```

### 4. DNS 解析基准测试

测试 DNS 解析功能的性能，支持多个 DNS 服务器。

```dart
final results = await NetworkBenchmark.benchmarkDns(
  iterations: 50,
  domain: 'www.google.com',
  dnsServers: [
    '8.8.8.8',          // Google DNS
    '114.114.114.114',  // 114 DNS
    '1.1.1.1',          // Cloudflare DNS
  ],
);

// 找出最快的 DNS 服务器
var fastest = results.results.first;
for (var result in results.results) {
  if (result.averageDuration < fastest.averageDuration) {
    fastest = result;
  }
}
print('最快的 DNS: ${fastest.testName}');
print('平均耗时: ${fastest.averageDuration.toStringAsFixed(2)}ms');
```

### 5. 端口检查基准测试

测试端口检查功能的性能，支持多个端口。

```dart
final results = await NetworkBenchmark.benchmarkPortCheck(
  iterations: 50,
  host: 'www.baidu.com',
  ports: [80, 443, 8080, 3000],
);

for (var result in results.results) {
  print('${result.testName}: ${result.averageDuration.toStringAsFixed(2)}ms');
}
```

---

## 自定义基准测试

### 使用 BenchmarkRunner

BenchmarkRunner 提供了灵活的基准测试能力。

#### 基本用法

```dart
final result = await BenchmarkRunner.run(
  testName: '自定义测试',
  test: () async {
    // 你的测试代码
    await NetworkDiagnostic.checkConnection();
  },
  iterations: 100,
  warmupIterations: 10,
);

print('平均耗时: ${result.averageDuration}ms');
```

#### 带元数据

```dart
final result = await BenchmarkRunner.run(
  testName: '组合测试',
  test: () async {
    await NetworkDiagnostic.checkConnection();
    await NetworkDiagnostic.ping(host: 'www.google.com', count: 1);
  },
  iterations: 50,
  metadata: {
    'description': '连接检查 + Ping',
    'version': '1.1.0',
    'environment': 'production',
  },
);

print('元数据: ${result.metadata}');
```

#### 测试套件

```dart
final results = await BenchmarkRunner.runSuite(
  suiteName: '自定义测试套件',
  tests: {
    '测试1': () async {
      await NetworkDiagnostic.checkConnection();
    },
    '测试2': () async {
      await NetworkDiagnostic.ping(host: 'www.google.com', count: 1);
    },
    '测试3': () async {
      await NetworkDiagnostic.testDns(
        domain: 'www.google.com',
        dnsServers: ['8.8.8.8'],
      );
    },
  },
  iterations: 30,
  warmupIterations: 3,
  deviceInfo: {
    'platform': 'Android',
    'version': '12',
    'device': 'Pixel 6',
  },
);

print('套件名称: ${results.suiteName}');
print('总耗时: ${results.totalDuration}ms');
print('设备信息: ${results.deviceInfo}');
```

---

## 结果分析

### 性能指标说明

#### 1. 迭代次数 (iterations)

测试执行的次数。更多的迭代次数可以提供更准确的结果。

**建议值**:
- 快速测试: 10-20 次
- 标准测试: 50-100 次
- 精确测试: 100-1000 次

#### 2. 平均耗时 (averageDuration)

所有迭代的平均执行时间，单位为毫秒。

**评估标准**:
- 优秀: < 50ms
- 良好: 50-100ms
- 一般: 100-200ms
- 较差: > 200ms

#### 3. 最小/最大耗时 (minDuration/maxDuration)

最快和最慢的单次执行时间。

**用途**:
- 评估性能稳定性
- 发现异常情况
- 识别性能波动

#### 4. 标准差 (standardDeviation)

性能稳定性指标，值越小表示性能越稳定。

**评估标准**:
- 优秀: < 10ms
- 良好: 10-20ms
- 一般: 20-50ms
- 较差: > 50ms

#### 5. 每秒操作数 (operationsPerSecond)

吞吐量指标，表示每秒可以执行多少次操作。

**用途**:
- 评估系统容量
- 比较不同实现
- 性能规划

### 结果导出

#### JSON 格式

```dart
final result = await BenchmarkRunner.run(
  testName: '测试',
  test: () async {
    await NetworkDiagnostic.checkConnection();
  },
  iterations: 50,
);

// 导出为 JSON
final json = result.toJson();
print(json);

// 保存到文件
import 'dart:io';
import 'dart:convert';

final file = File('benchmark_result.json');
await file.writeAsString(jsonEncode(json));
```

#### 文本格式

```dart
final results = await NetworkBenchmark.runAll();

// 使用 toString() 方法
print(results.toString());

// 自定义格式
final buffer = StringBuffer();
buffer.writeln('=== 基准测试报告 ===');
buffer.writeln('套件: ${results.suiteName}');
buffer.writeln('时间: ${results.timestamp}');
buffer.writeln('总耗时: ${results.totalDuration}ms');
buffer.writeln('\n详细结果:');

for (var result in results.results) {
  buffer.writeln('\n${result.testName}:');
  buffer.writeln('  迭代次数: ${result.iterations}');
  buffer.writeln('  平均耗时: ${result.averageDuration.toStringAsFixed(2)}ms');
  buffer.writeln('  最小耗时: ${result.minDuration}ms');
  buffer.writeln('  最大耗时: ${result.maxDuration}ms');
  buffer.writeln('  标准差: ${result.standardDeviation.toStringAsFixed(2)}ms');
  buffer.writeln('  操作/秒: ${result.operationsPerSecond.toStringAsFixed(2)}');
}

print(buffer.toString());
```

---

## 最佳实践

### 1. 预热阶段

始终包含预热阶段，避免冷启动影响结果。

```dart
final result = await BenchmarkRunner.run(
  testName: '测试',
  test: () async {
    await NetworkDiagnostic.checkConnection();
  },
  iterations: 100,
  warmupIterations: 10,  // 预热 10 次
);
```

### 2. 足够的迭代次数

使用足够的迭代次数以获得稳定的结果。

```dart
// ❌ 不好 - 迭代次数太少
final result1 = await BenchmarkRunner.run(
  testName: '测试',
  test: testFunction,
  iterations: 5,
);

// ✅ 好 - 足够的迭代次数
final result2 = await BenchmarkRunner.run(
  testName: '测试',
  test: testFunction,
  iterations: 50,
);
```

### 3. 隔离测试环境

- 关闭其他应用
- 使用稳定的网络环境
- 避免在测试期间进行其他操作

### 4. 多次运行

运行多次基准测试并比较结果。

```dart
final results = <BenchmarkResult>[];

for (var i = 0; i < 3; i++) {
  final result = await BenchmarkRunner.run(
    testName: '测试 ${i + 1}',
    test: testFunction,
    iterations: 50,
  );
  results.add(result);
}

// 计算平均值
final avgDuration = results
    .map((r) => r.averageDuration)
    .reduce((a, b) => a + b) / results.length;

print('三次测试的平均耗时: ${avgDuration.toStringAsFixed(2)}ms');
```

### 5. 记录环境信息

```dart
final results = await BenchmarkRunner.runSuite(
  suiteName: '测试套件',
  tests: tests,
  deviceInfo: {
    'platform': Platform.operatingSystem,
    'version': Platform.operatingSystemVersion,
    'dart_version': Platform.version,
    'timestamp': DateTime.now().toIso8601String(),
  },
);
```

---

## 性能优化

### 识别性能瓶颈

#### 1. 比较不同实现

```dart
// 实现 A
final resultA = await BenchmarkRunner.run(
  testName: '实现 A',
  test: () async {
    await implementationA();
  },
  iterations: 100,
);

// 实现 B
final resultB = await BenchmarkRunner.run(
  testName: '实现 B',
  test: () async {
    await implementationB();
  },
  iterations: 100,
);

// 比较结果
print('实现 A: ${resultA.averageDuration}ms');
print('实现 B: ${resultB.averageDuration}ms');
print('性能提升: ${((resultA.averageDuration - resultB.averageDuration) / resultA.averageDuration * 100).toStringAsFixed(2)}%');
```

#### 2. 分析标准差

高标准差表示性能不稳定，可能存在问题。

```dart
final result = await BenchmarkRunner.run(
  testName: '测试',
  test: testFunction,
  iterations: 100,
);

if (result.standardDeviation > 50) {
  print('警告: 性能不稳定，标准差过高');
  print('标准差: ${result.standardDeviation.toStringAsFixed(2)}ms');
}
```

### 优化建议

#### 1. 减少网络请求

```dart
// ❌ 不好 - 多次请求
for (var i = 0; i < 10; i++) {
  await NetworkDiagnostic.checkConnection();
}

// ✅ 好 - 缓存结果
final connection = await NetworkDiagnostic.checkConnection();
for (var i = 0; i < 10; i++) {
  // 使用缓存的结果
  print(connection.type);
}
```

#### 2. 并行执行

```dart
// ❌ 不好 - 串行执行
final ping = await NetworkDiagnostic.ping(host: 'www.google.com');
final dns = await NetworkDiagnostic.testDns(
  domain: 'www.google.com',
  dnsServers: ['8.8.8.8'],
);

// ✅ 好 - 并行执行
final results = await Future.wait([
  NetworkDiagnostic.ping(host: 'www.google.com'),
  NetworkDiagnostic.testDns(
    domain: 'www.google.com',
    dnsServers: ['8.8.8.8'],
  ),
]);
```

#### 3. 合理的超时设置

```dart
// ❌ 不好 - 超时时间过长
final result = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  timeout: Duration(seconds: 60),
);

// ✅ 好 - 合理的超时时间
final result = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  timeout: Duration(seconds: 5),
);
```

---

## 持续集成

### 在 CI/CD 中运行基准测试

#### GitHub Actions 示例

```yaml
name: Benchmark

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  benchmark:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run benchmarks
      run: dart benchmark/network_benchmark_test.dart
    
    - name: Upload results
      uses: actions/upload-artifact@v2
      with:
        name: benchmark-results
        path: benchmark_results.json
```

---

## 相关文档

- [API 参考](API.md)
- [架构设计](ARCHITECTURE.md)
- [快速参考](QUICK_REFERENCE.md)
- [发布总结](RELEASE_SUMMARY.md)

---

**文档版本**: 1.1  
**创建日期**: 2026-03-08  
**项目**: network_diagnostic_kit
