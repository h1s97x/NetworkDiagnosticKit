# network_diagnostic_kit 代码风格指南

本文档定义了 network_diagnostic_kit 项目的代码风格规范。

## 基本原则

1. **一致性**: 保持代码风格一致
2. **可读性**: 代码应该易于理解
3. **简洁性**: 避免不必要的复杂性
4. **文档化**: 为公共 API 提供文档注释

---

## Dart 代码风格

### 1. 命名规范

#### 类名 - UpperCamelCase

```dart
✅ 好的示例
class NetworkDiagnostic {}
class SpeedTestResult {}
class BenchmarkRunner {}

❌ 不好的示例
class network_diagnostic {}
class speedTestResult {}
class benchmark_runner {}
```

#### 变量和方法名 - lowerCamelCase

```dart
✅ 好的示例
String ipAddress;
int averageTime;
Future<void> checkConnection();

❌ 不好的示例
String ip_address;
int average_time;
Future<void> check_connection();
```

#### 常量 - lowerCamelCase

```dart
✅ 好的示例
const defaultTimeout = Duration(seconds: 30);
const maxRetries = 3;

❌ 不好的示例
const DEFAULT_TIMEOUT = Duration(seconds: 30);
const MAX_RETRIES = 3;
```

#### 私有成员 - 以下划线开头

```dart
✅ 好的示例
String _privateField;
void _privateMethod() {}

❌ 不好的示例
String privateField;
void privateMethod() {}
```

#### 文件名 - snake_case

```dart
✅ 好的示例
network_diagnostic.dart
speed_test_result.dart
benchmark_runner.dart

❌ 不好的示例
NetworkDiagnostic.dart
speedTestResult.dart
BenchmarkRunner.dart
```

### 2. 代码格式

#### 缩进 - 2 个空格

```dart
✅ 好的示例
class NetworkDiagnostic {
  static Future<NetworkConnectionInfo> checkConnection() async {
    final result = await _platform.checkConnection();
    return NetworkConnectionInfo.fromMap(result);
  }
}

❌ 不好的示例
class NetworkDiagnostic {
    static Future<NetworkConnectionInfo> checkConnection() async {
        final result = await _platform.checkConnection();
        return NetworkConnectionInfo.fromMap(result);
    }
}
```

#### 行长度 - 最多 80 字符

```dart
✅ 好的示例
final result = await NetworkDiagnostic.ping(
  host: 'www.google.com',
  count: 10,
);

❌ 不好的示例
final result = await NetworkDiagnostic.ping(host: 'www.google.com', count: 10, timeout: Duration(seconds: 5));
```

#### 导入顺序

1. Dart SDK 导入
2. Flutter 导入
3. 第三方包导入
4. 项目内部导入

```dart
✅ 好的示例
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'models/network_connection_info.dart';
import 'enums/network_type.dart';

❌ 不好的示例
import 'models/network_connection_info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';
```

### 3. 文档注释

#### 公共 API - 使用 /// 注释

```dart
✅ 好的示例
/// 检查当前网络连接状态。
///
/// 返回包含网络类型、IP 地址等信息的 [NetworkConnectionInfo] 对象。
///
/// 示例:
/// ```dart
/// final connection = await NetworkDiagnostic.checkConnection();
/// print('网络类型: ${connection.type.displayName}');
/// ```
static Future<NetworkConnectionInfo> checkConnection() async {
  // 实现
}

❌ 不好的示例
// 检查网络连接
static Future<NetworkConnectionInfo> checkConnection() async {
  // 实现
}
```

#### 参数文档

```dart
✅ 好的示例
/// 执行 Ping 测试。
///
/// [host] 目标主机地址。
/// [count] Ping 次数，默认 4 次。
/// [timeout] 超时时间，默认 5 秒。
///
/// 返回包含延迟、丢包率等信息的 [PingResult] 对象。
static Future<PingResult> ping({
  required String host,
  int count = 4,
  Duration timeout = const Duration(seconds: 5),
}) async {
  // 实现
}
```

### 4. 类型注解

#### 始终指定类型

```dart
✅ 好的示例
final String ipAddress = '192.168.1.1';
final int port = 80;
final List<String> dnsServers = ['8.8.8.8', '1.1.1.1'];

❌ 不好的示例
final ipAddress = '192.168.1.1';
final port = 80;
final dnsServers = ['8.8.8.8', '1.1.1.1'];
```

#### 方法返回类型

```dart
✅ 好的示例
Future<NetworkConnectionInfo> checkConnection() async {
  // 实现
}

int calculateAverage(List<int> values) {
  // 实现
}

❌ 不好的示例
checkConnection() async {
  // 实现
}

calculateAverage(values) {
  // 实现
}
```

### 5. 异步编程

#### 使用 async/await

```dart
✅ 好的示例
Future<PingResult> ping({required String host}) async {
  final result = await _platform.ping(host);
  return PingResult.fromMap(result);
}

❌ 不好的示例
Future<PingResult> ping({required String host}) {
  return _platform.ping(host).then((result) {
    return PingResult.fromMap(result);
  });
}
```

#### 错误处理

```dart
✅ 好的示例
try {
  final result = await NetworkDiagnostic.runSpeedTest();
  return result;
} on NetworkDiagnosticException catch (e) {
  print('Network diagnostic error: ${e.message}');
  rethrow;
} catch (e) {
  throw NetworkDiagnosticException(
    message: 'Unknown error: $e',
    code: 'UNKNOWN_ERROR',
  );
}

❌ 不好的示例
try {
  final result = await NetworkDiagnostic.runSpeedTest();
  return result;
} catch (e) {
  print('Error: $e');
  return null;
}
```

### 6. 空安全

#### 使用空安全特性

```dart
✅ 好的示例
String? ipAddress;  // 可空类型
String gateway = '';  // 非空类型

if (ipAddress != null) {
  print(ipAddress.length);  // 安全访问
}

print(ipAddress?.length ?? 0);  // 空安全操作符

❌ 不好的示例
String ipAddress;  // 未初始化

if (ipAddress != null) {
  print(ipAddress.length);
}
```

### 7. 常量和枚举

#### 使用 const 构造函数

```dart
✅ 好的示例
const defaultTimeout = Duration(seconds: 30);
const emptyList = <String>[];

❌ 不好的示例
final defaultTimeout = Duration(seconds: 30);
final emptyList = <String>[];
```

#### 枚举命名

```dart
✅ 好的示例
enum NetworkType {
  none,
  wifi,
  mobile,
  ethernet,
}

enum QualityLevel {
  excellent,
  good,
  fair,
  poor,
  bad,
}

❌ 不好的示例
enum NetworkType {
  NONE,
  WIFI,
  MOBILE,
  ETHERNET,
}
```

---

## Kotlin 代码风格 (Android)

### 1. 命名规范

```kotlin
✅ 好的示例
class NetworkDiagnosticKitPlugin : FlutterPlugin {
  private val methodChannel: MethodChannel
  
  fun checkConnection(result: Result) {
    // 实现
  }
}

❌ 不好的示例
class network_diagnostic_kit_plugin : FlutterPlugin {
  private val method_channel: MethodChannel
  
  fun check_connection(result: Result) {
    // 实现
  }
}
```

### 2. 空安全

```kotlin
✅ 好的示例
val ipAddress: String? = null
val port: Int = 80

ipAddress?.let {
  println(it.length)
}

❌ 不好的示例
val ipAddress: String? = null
println(ipAddress!!.length)  // 避免使用 !!
```

### 3. 协程

```kotlin
✅ 好的示例
private fun runSpeedTest(call: MethodCall, result: Result) {
  CoroutineScope(Dispatchers.IO).launch {
    try {
      val speedResult = performSpeedTest()
      withContext(Dispatchers.Main) {
        result.success(speedResult)
      }
    } catch (e: Exception) {
      withContext(Dispatchers.Main) {
        result.error("SPEED_TEST_ERROR", e.message, null)
      }
    }
  }
}
```

---

## Swift 代码风格 (iOS)

### 1. 命名规范

```swift
✅ 好的示例
class NetworkDiagnosticKitPlugin: NSObject, FlutterPlugin {
  private var methodChannel: FlutterMethodChannel?
  
  func checkConnection(result: @escaping FlutterResult) {
    // 实现
  }
}

❌ 不好的示例
class network_diagnostic_kit_plugin: NSObject, FlutterPlugin {
  private var method_channel: FlutterMethodChannel?
  
  func check_connection(result: @escaping FlutterResult) {
    // 实现
  }
}
```

### 2. 可选类型

```swift
✅ 好的示例
var ipAddress: String?
let port: Int = 80

if let ip = ipAddress {
  print(ip.count)
}

❌ 不好的示例
var ipAddress: String?
print(ipAddress!.count)  // 避免强制解包
```

### 3. 异步操作

```swift
✅ 好的示例
func runSpeedTest(call: FlutterMethodCall, result: @escaping FlutterResult) {
  DispatchQueue.global(qos: .userInitiated).async {
    do {
      let speedResult = try self.performSpeedTest()
      DispatchQueue.main.async {
        result(speedResult)
      }
    } catch {
      DispatchQueue.main.async {
        result(FlutterError(code: "SPEED_TEST_ERROR",
                           message: error.localizedDescription,
                           details: nil))
      }
    }
  }
}
```

---

## C++ 代码风格 (Windows)

### 1. 命名规范

```cpp
✅ 好的示例
class NetworkDiagnosticKitPlugin : public flutter::Plugin {
 private:
  std::unique_ptr<flutter::MethodChannel<>> method_channel_;
  
  void CheckConnection(std::unique_ptr<flutter::MethodResult<>> result);
};

❌ 不好的示例
class network_diagnostic_kit_plugin : public flutter::Plugin {
 private:
  std::unique_ptr<flutter::MethodChannel<>> methodChannel;
  
  void check_connection(std::unique_ptr<flutter::MethodResult<>> result);
};
```

### 2. 智能指针

```cpp
✅ 好的示例
std::unique_ptr<NetworkInfo> info = std::make_unique<NetworkInfo>();
std::shared_ptr<Connection> conn = std::make_shared<Connection>();

❌ 不好的示例
NetworkInfo* info = new NetworkInfo();
// 忘记 delete
```

### 3. 错误处理

```cpp
✅ 好的示例
try {
  auto result = PerformSpeedTest();
  method_result->Success(result);
} catch (const std::exception& e) {
  method_result->Error("SPEED_TEST_ERROR", e.what());
}
```

---

## 测试代码风格

### 1. 测试命名

```dart
✅ 好的示例
test('should return network connection info', () async {
  final connection = await NetworkDiagnostic.checkConnection();
  expect(connection, isNotNull);
});

test('should calculate average correctly', () {
  final values = [10, 20, 30];
  final average = calculateAverage(values);
  expect(average, equals(20));
});

❌ 不好的示例
test('test1', () async {
  // 测试代码
});

test('connection', () async {
  // 测试代码
});
```

### 2. 测试结构

```dart
✅ 好的示例
group('NetworkDiagnostic', () {
  group('checkConnection', () {
    test('should return connection info when connected', () async {
      // Arrange
      // Act
      final connection = await NetworkDiagnostic.checkConnection();
      // Assert
      expect(connection.isConnected, isTrue);
    });
    
    test('should return correct network type', () async {
      // 测试代码
    });
  });
  
  group('ping', () {
    test('should return ping result', () async {
      // 测试代码
    });
  });
});
```

---

## 代码审查清单

### 提交前检查

- [ ] 代码符合命名规范
- [ ] 添加了必要的文档注释
- [ ] 所有公共 API 都有文档
- [ ] 代码格式正确（运行 `dart format`）
- [ ] 没有编译警告
- [ ] 通过所有测试
- [ ] 添加了新功能的测试
- [ ] 更新了相关文档

### 代码审查要点

- [ ] 代码逻辑清晰
- [ ] 错误处理完善
- [ ] 没有内存泄漏
- [ ] 性能考虑合理
- [ ] 安全性考虑充分
- [ ] 可测试性良好

---

## 工具配置

### analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_final_locals
    - sort_constructors_first
    - sort_unnamed_constructors_first
    - unawaited_futures
```

### 格式化命令

```bash
# 格式化所有 Dart 代码
dart format .

# 检查代码风格
dart analyze

# 运行测试
flutter test
```

---

## 相关文档

- [API 参考](API.md)
- [架构设计](ARCHITECTURE.md)
- [快速参考](QUICK_REFERENCE.md)

---

**文档版本**: 1.1  
**创建日期**: 2026-03-08  
**项目**: network_diagnostic_kit
