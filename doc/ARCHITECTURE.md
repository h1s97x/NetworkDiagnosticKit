# network_diagnostic_kit 架构设计

本文档描述 network_diagnostic_kit 项目的架构设计原则和实现方案。

## 目录

- [概述](#概述)
- [架构原则](#架构原则)
- [项目结构](#项目结构)
- [核心组件](#核心组件)
- [平台实现](#平台实现)
- [数据流](#数据流)
- [性能优化](#性能优化)
- [扩展性设计](#扩展性设计)

---

## 概述

network_diagnostic_kit 是一个跨平台的 Flutter 插件，提供全面的网络诊断功能。项目采用分层架构设计，确保代码的可维护性、可测试性和可扩展性。

### 核心功能

- 网络连接检测
- 网速测试（下载/上传/延迟/抖动/丢包）
- Ping 测试
- DNS 解析测试
- 网络质量评估
- 端口扫描
- 实时网络状态监听
- 性能基准测试

---

## 架构原则

### 1. 分层架构

```
┌─────────────────────────────────────┐
│         应用层 (Application)         │
│    Flutter App / Example App        │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│         API 层 (API Layer)          │
│      NetworkDiagnostic Class        │
│      NetworkBenchmark Class         │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│      平台接口层 (Platform Interface) │
│   NetworkDiagnosticPlatform         │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│    平台实现层 (Platform Implementation)│
│   Android / iOS / Windows / etc.    │
└─────────────────────────────────────┘
```

### 2. 设计原则

- **单一职责**: 每个类只负责一个功能
- **开闭原则**: 对扩展开放，对修改关闭
- **依赖倒置**: 依赖抽象而非具体实现
- **接口隔离**: 使用小而专注的接口
- **异步优先**: 所有网络操作都是异步的

---

## 项目结构

```
network_diagnostic_kit/
├── lib/
│   ├── network_diagnostic_kit.dart              # 主导出文件
│   ├── network_diagnostic_kit_method_channel.dart
│   ├── network_diagnostic_kit_platform_interface.dart
│   └── src/
│       ├── network_diagnostic.dart              # 核心 API 实现
│       ├── benchmark/                           # 基准测试
│       │   ├── benchmark_runner.dart
│       │   └── network_benchmark.dart
│       ├── enums/                               # 枚举定义
│       │   ├── enums.dart
│       │   ├── network_type.dart
│       │   └── quality_level.dart
│       ├── models/                              # 数据模型
│       │   ├── models.dart
│       │   ├── network_connection_info.dart
│       │   ├── speed_test_result.dart
│       │   ├── ping_result.dart
│       │   ├── dns_test_result.dart
│       │   ├── network_quality_score.dart
│       │   ├── benchmark_result.dart
│       │   └── benchmark_suite_result.dart
│       ├── exceptions/                          # 异常定义
│       │   └── network_diagnostic_exception.dart
│       └── utils/                               # 工具类
├── android/                                     # Android 平台实现
│   └── src/main/kotlin/
│       └── com/example/network_diagnostic_kit/
│           └── NetworkDiagnosticKitPlugin.kt
├── ios/                                         # iOS 平台实现
│   └── Classes/
│       └── NetworkDiagnosticKitPlugin.swift
├── windows/                                     # Windows 平台实现
│   ├── network_diagnostic_kit_plugin.cpp
│   └── network_diagnostic_kit_plugin.h
├── test/                                        # 单元测试
├── example/                                     # 示例应用
└── benchmark/                                   # 独立基准测试
```

---

## 核心组件

### 1. NetworkDiagnostic

主要的 API 类，提供所有网络诊断功能。

**职责**:
- 提供统一的 API 接口
- 协调各个功能模块
- 处理异常和错误
- 管理异步操作

**关键方法**:
```dart
class NetworkDiagnostic {
  static Future<NetworkConnectionInfo> checkConnection();
  static Future<SpeedTestResult> runSpeedTest({...});
  static Future<PingResult> ping({...});
  static Future<List<DnsTestResult>> testDns({...});
  static Future<NetworkQualityScore> evaluateQuality();
  static Future<bool> checkPort({...});
  static Stream<NetworkConnectionInfo> get onConnectivityChanged;
}
```

### 2. NetworkBenchmark

性能基准测试类。

**职责**:
- 测试各项功能的性能
- 收集性能指标
- 生成基准测试报告

**关键方法**:
```dart
class NetworkBenchmark {
  static Future<BenchmarkSuiteResult> runAll({...});
  static Future<BenchmarkSuiteResult> benchmarkConnection({...});
  static Future<BenchmarkSuiteResult> benchmarkPing({...});
  static Future<BenchmarkSuiteResult> benchmarkDns({...});
  static Future<BenchmarkSuiteResult> benchmarkPortCheck({...});
}
```

### 3. BenchmarkRunner

通用基准测试运行器。

**职责**:
- 执行基准测试
- 计算统计数据
- 管理预热和迭代

**关键方法**:
```dart
class BenchmarkRunner {
  static Future<BenchmarkResult> run({...});
  static Future<BenchmarkSuiteResult> runSuite({...});
}
```

### 4. 平台接口层

定义平台无关的接口。

```dart
abstract class NetworkDiagnosticPlatform extends PlatformInterface {
  Future<Map<String, dynamic>> checkConnection();
  Future<Map<String, dynamic>> runSpeedTest({...});
  Future<Map<String, dynamic>> ping({...});
  // ...
}
```

---

## 平台实现

### Android 实现

**技术栈**:
- Kotlin
- Android ConnectivityManager
- Android NetworkCapabilities
- OkHttp (网络请求)

**关键实现**:
```kotlin
class NetworkDiagnosticKitPlugin : FlutterPlugin, MethodCallHandler {
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "checkConnection" -> checkConnection(result)
      "runSpeedTest" -> runSpeedTest(call, result)
      "ping" -> ping(call, result)
      "testDns" -> testDns(call, result)
      // ...
    }
  }
}
```

### iOS 实现

**技术栈**:
- Swift
- Network.framework
- Reachability
- URLSession

**关键实现**:
```swift
public class NetworkDiagnosticKitPlugin: NSObject, FlutterPlugin {
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkConnection":
      checkConnection(result: result)
    case "runSpeedTest":
      runSpeedTest(call: call, result: result)
    // ...
    }
  }
}
```

### Windows 实现

**技术栈**:
- C++
- Windows API
- WinHTTP

**关键实现**:
```cpp
class NetworkDiagnosticKitPlugin : public flutter::Plugin {
  void HandleMethodCall(
      const flutter::MethodCall<>& method_call,
      std::unique_ptr<flutter::MethodResult<>> result) {
    if (method_call.method_name() == "checkConnection") {
      CheckConnection(result);
    } else if (method_call.method_name() == "runSpeedTest") {
      RunSpeedTest(method_call, result);
    }
    // ...
  }
};
```

---

## 数据流

### 1. 网络连接检测流程

```
用户调用
    ↓
NetworkDiagnostic.checkConnection()
    ↓
Platform Interface
    ↓
Platform Implementation (Android/iOS/Windows)
    ↓
系统 API (ConnectivityManager/Network.framework/Windows API)
    ↓
返回原始数据
    ↓
转换为 NetworkConnectionInfo
    ↓
返回给用户
```

### 2. 网速测试流程

```
用户调用
    ↓
NetworkDiagnostic.runSpeedTest()
    ↓
并行执行:
  ├─ 下载测试
  ├─ 上传测试
  ├─ Ping 测试
  └─ 抖动测试
    ↓
收集所有结果
    ↓
计算综合指标
    ↓
返回 SpeedTestResult
```

### 3. 基准测试流程

```
用户调用
    ↓
NetworkBenchmark.runAll()
    ↓
BenchmarkRunner.runSuite()
    ↓
预热阶段 (warmup iterations)
    ↓
正式测试 (iterations)
    ↓
收集每次迭代的耗时
    ↓
计算统计数据:
  ├─ 平均值
  ├─ 最小值
  ├─ 最大值
  ├─ 标准差
  └─ 每秒操作数
    ↓
返回 BenchmarkSuiteResult
```

---

## 性能优化

### 1. 异步操作

所有网络操作都是异步的，避免阻塞 UI 线程。

```dart
// 使用 async/await
final result = await NetworkDiagnostic.checkConnection();

// 使用 Future.wait 并行执行
final results = await Future.wait([
  NetworkDiagnostic.ping(host: 'www.google.com'),
  NetworkDiagnostic.testDns(domain: 'www.google.com', dnsServers: ['8.8.8.8']),
]);
```

### 2. 缓存策略

对于不经常变化的数据（如网络类型），使用缓存减少系统调用。

```dart
class NetworkDiagnostic {
  static NetworkConnectionInfo? _cachedConnection;
  static DateTime? _cacheTime;
  static const _cacheDuration = Duration(seconds: 5);

  static Future<NetworkConnectionInfo> checkConnection() async {
    if (_cachedConnection != null && 
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      return _cachedConnection!;
    }
    
    final connection = await _fetchConnection();
    _cachedConnection = connection;
    _cacheTime = DateTime.now();
    return connection;
  }
}
```

### 3. 超时控制

所有网络操作都有超时控制，避免长时间等待。

```dart
final result = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  timeout: Duration(seconds: 5),
);
```

### 4. 资源管理

及时释放资源，避免内存泄漏。

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
```

---

## 扩展性设计

### 1. 添加新的网络诊断功能

**步骤 1**: 在 `NetworkDiagnostic` 类中添加新方法

```dart
class NetworkDiagnostic {
  static Future<TraceRouteResult> traceRoute({
    required String host,
    int maxHops = 30,
  }) async {
    // 实现逻辑
  }
}
```

**步骤 2**: 定义数据模型

```dart
class TraceRouteResult {
  final String host;
  final List<TraceRouteHop> hops;
  final int totalHops;
  final DateTime timestamp;
}
```

**步骤 3**: 实现平台代码

Android (Kotlin):
```kotlin
private fun traceRoute(call: MethodCall, result: Result) {
  val host = call.argument<String>("host")
  // 实现逻辑
}
```

iOS (Swift):
```swift
private func traceRoute(call: FlutterMethodCall, result: @escaping FlutterResult) {
  let host = call.arguments["host"] as? String
  // 实现逻辑
}
```

### 2. 添加新的基准测试

```dart
class NetworkBenchmark {
  static Future<BenchmarkSuiteResult> benchmarkTraceRoute({
    int iterations = 20,
    List<String> hosts = const ['www.google.com'],
  }) async {
    final tests = <String, Future<void> Function()>{};
    
    for (var host in hosts) {
      tests['traceRoute_$host'] = () => NetworkDiagnostic.traceRoute(
        host: host,
      );
    }
    
    return BenchmarkRunner.runSuite(
      suiteName: 'TraceRoute Benchmark',
      tests: tests,
      iterations: iterations,
    );
  }
}
```

### 3. 支持新平台

**步骤 1**: 创建平台目录和文件

```
linux/
├── CMakeLists.txt
└── network_diagnostic_kit_plugin.cc
```

**步骤 2**: 实现平台接口

```cpp
class NetworkDiagnosticKitPlugin : public flutter::Plugin {
  // 实现所有必需的方法
};
```

**步骤 3**: 在 `pubspec.yaml` 中注册

```yaml
flutter:
  plugin:
    platforms:
      linux:
        pluginClass: NetworkDiagnosticKitPlugin
```

---

## 测试策略

### 1. 单元测试

测试各个组件的独立功能。

```dart
test('BenchmarkRunner should calculate statistics correctly', () async {
  final result = await BenchmarkRunner.run(
    testName: 'Test',
    test: () async {
      await Future.delayed(Duration(milliseconds: 10));
    },
    iterations: 10,
  );
  
  expect(result.averageDuration, greaterThan(0));
  expect(result.standardDeviation, greaterThanOrEqualTo(0));
});
```

### 2. 集成测试

测试组件之间的交互。

```dart
testWidgets('NetworkDiagnostic integration test', (tester) async {
  final connection = await NetworkDiagnostic.checkConnection();
  expect(connection, isNotNull);
  
  if (connection.isConnected) {
    final ping = await NetworkDiagnostic.ping(host: 'www.google.com');
    expect(ping.averageTime, greaterThan(0));
  }
});
```

### 3. 性能测试

使用基准测试系统测试性能。

```dart
void main() async {
  final results = await NetworkBenchmark.runAll();
  print('Performance Results:');
  for (var result in results.results) {
    print('${result.testName}: ${result.averageDuration}ms');
  }
}
```

---

## 安全考虑

### 1. 权限管理

确保应用有必要的网络权限。

Android:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 2. 数据验证

验证所有输入参数。

```dart
static Future<PingResult> ping({
  required String host,
  int count = 4,
}) async {
  if (host.isEmpty) {
    throw NetworkDiagnosticException(
      message: 'Host cannot be empty',
      code: 'INVALID_HOST',
    );
  }
  
  if (count <= 0) {
    throw NetworkDiagnosticException(
      message: 'Count must be positive',
      code: 'INVALID_COUNT',
    );
  }
  
  // 执行 ping
}
```

### 3. 错误处理

提供清晰的错误信息。

```dart
try {
  final result = await NetworkDiagnostic.runSpeedTest();
} on NetworkDiagnosticException catch (e) {
  print('Network diagnostic error: ${e.message}');
  print('Error code: ${e.code}');
} catch (e) {
  print('Unknown error: $e');
}
```

---

## 总结

network_diagnostic_kit 的架构设计遵循以下原则：

1. **简单易用**: 提供直观的 API 接口
2. **高性能**: 异步操作、缓存策略、超时控制
3. **可扩展**: 易于添加新功能和支持新平台
4. **可测试**: 完善的测试策略
5. **跨平台**: 统一的接口，平台特定的实现

这种架构确保了项目的长期可维护性和可扩展性。

---

## 相关文档

- [API 参考](API.md)
- [快速参考](QUICK_REFERENCE.md)
- [基准测试指南](BENCHMARK_GUIDE.md)
- [代码风格指南](CODE_STYLE.md)

---

**文档版本**: 1.1  
**创建日期**: 2026-03-08  
**项目**: network_diagnostic_kit
