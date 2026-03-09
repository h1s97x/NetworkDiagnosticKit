# 贡献指南

感谢您对 network_diagnostic_kit 项目的关注！本指南将帮助您扩展插件功能。

## 架构概览

```text
network_diagnostic_kit/
├── lib/
│   ├── network_diagnostic_kit.dart     # 主导出文件
│   └── src/
│       ├── network_diagnostic.dart     # 主 API 类
│       ├── models/                      # 数据模型
│       │   ├── network_connection_info.dart
│       │   ├── speed_test_result.dart
│       │   ├── ping_result.dart
│       │   ├── dns_test_result.dart
│       │   ├── network_quality_score.dart
│       │   ├── benchmark_result.dart
│       │   └── benchmark_suite_result.dart
│       ├── enums/                       # 枚举
│       │   ├── network_type.dart
│       │   └── quality_level.dart
│       ├── exceptions/                  # 异常
│       │   └── network_diagnostic_exception.dart
│       └── benchmark/                   # 基准测试
│           ├── benchmark_runner.dart
│           └── network_benchmark.dart
│
├── android/                             # Android 平台代码（Kotlin）
│   └── src/main/kotlin/
│       └── NetworkDiagnosticKitPlugin.kt
│
├── ios/                                 # iOS 平台代码（Swift）
│   └── Classes/
│       └── NetworkDiagnosticKitPlugin.swift
│
├── example/                             # 示例应用
│   └── lib/
│       ├── main.dart
│       └── benchmark_example.dart
│
├── benchmark/                           # 独立基准测试脚本
│   └── network_benchmark_test.dart
│
└── doc/                                 # 文档
    ├── API.md
    ├── ARCHITECTURE.md
    ├── USAGE_GUIDE.md
    ├── BENCHMARK_GUIDE.md
    └── ...
```

## 添加新的网络诊断功能

### 步骤 1：定义数据模型

在 `lib/src/models/` 创建新模型：

```dart
// lib/src/models/new_diagnostic_result.dart
class NewDiagnosticResult {
  final String? property1;
  final int? property2;
  final DateTime timestamp;

  NewDiagnosticResult({
    this.property1,
    this.property2,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory NewDiagnosticResult.fromJson(Map<String, dynamic> json) {
    return NewDiagnosticResult(
      property1: json['property1'] as String?,
      property2: json['property2'] as int?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property1': property1,
      'property2': property2,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
```

### 步骤 2：导出模型

更新 `lib/src/models/models.dart`：

```dart
export 'new_diagnostic_result.dart';
```

### 步骤 3：添加 API 方法

在 `lib/src/network_diagnostic.dart` 中添加新方法：

```dart
Future<NewDiagnosticResult> runNewDiagnostic() async {
  // 实现诊断逻辑
}
```

### 步骤 4：实现 Android 平台代码

在 `android/src/main/kotlin/.../NetworkDiagnosticKitPlugin.kt` 中实现。

### 步骤 5：实现 iOS 平台代码

在 `ios/Classes/NetworkDiagnosticKitPlugin.swift` 中实现。

### 步骤 6：添加测试

创建相应的测试文件：

```dart
// test/new_diagnostic_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

void main() {
  group('NewDiagnostic', () {
    test('should return valid result', () async {
      // 测试逻辑
    });
  });
}
```

### 步骤 7：更新文档

更新 README.md、doc/API.md、doc/USAGE_GUIDE.md 等文档。

## 代码风格指南

### Dart 代码

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 指南
- 使用 `dart format` 格式化代码
- 运行 `flutter analyze` 检查问题
- 为公共 API 添加文档注释
- 参考 [doc/CODE_STYLE.md](doc/CODE_STYLE.md) 了解详细规范

### Kotlin 代码（Android）

- 遵循 Kotlin 编码规范
- 使用空安全
- 为公共方法添加 KDoc 注释
- 适当处理异常

### Swift 代码（iOS）

- 遵循 Swift 编码规范
- 使用可选类型处理空值
- 为公共方法添加文档注释
- 适当处理错误

## 测试

### 单元测试

```bash
flutter test
```

### 生成测试覆盖率

```bash
flutter test --coverage
```

### 运行基准测试

```bash
# 在 Flutter 应用中运行
cd example
flutter run

# 运行独立基准测试脚本
dart benchmark/network_benchmark_test.dart
```

## Pull Request 流程

1. Fork 仓库
2. 创建功能分支：`git checkout -b feature/new-diagnostic-feature`
3. 进行修改
4. 为新功能添加测试
5. 确保所有测试通过：`flutter test`
6. 确保代码分析通过：`flutter analyze`
7. 格式化代码：`dart format .`
8. 提交并附上描述性消息：`git commit -m "feat: 添加新诊断功能"`
9. 推送到您的 fork：`git push origin feature/new-diagnostic-feature`
10. 创建 Pull Request

### 提交消息格式

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```text
<类型>(<范围>): <主题>

<正文>

<页脚>
```

类型：

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `style`: 代码格式变更
- `refactor`: 代码重构
- `test`: 添加或更新测试
- `chore`: 维护任务
- `perf`: 性能优化

范围示例：

- `models`: 数据模型
- `api`: API 接口
- `benchmark`: 基准测试
- `android`: Android 平台
- `ios`: iOS 平台
- `example`: 示例应用
- `docs`: 文档

示例：

```text
feat(benchmark): 添加网络延迟基准测试
fix(android): 修正 Android 12+ 上的权限问题
docs(api): 更新 API 参考文档
test(models): 添加 PingResult 模型测试
```

## 获取帮助

- 查看现有 [issues](https://github.com/h1s97x/NetworkDiagnosticKit/issues)
- 阅读 [文档](doc/)
- 在 [discussions](https://github.com/h1s97x/NetworkDiagnosticKit/discussions) 提问

## 文档

项目文档位于 `doc/` 目录：

- [API.md](doc/API.md) - API 参考文档
- [ARCHITECTURE.md](doc/ARCHITECTURE.md) - 架构设计文档
- [USAGE_GUIDE.md](doc/USAGE_GUIDE.md) - 使用指南
- [BENCHMARK_GUIDE.md](doc/BENCHMARK_GUIDE.md) - 基准测试指南
- [CODE_STYLE.md](doc/CODE_STYLE.md) - 代码风格指南

## 行为准则

- 尊重和包容
- 提供建设性反馈
- 关注对社区最有利的事情
- 对其他社区成员表现出同理心

## 许可证

通过贡献，您同意您的贡献将在 MIT 许可证下授权。

## 致谢

贡献者将在以下位置获得认可：

- 发布说明
- 项目 README

感谢您为 network_diagnostic_kit 做出贡献！

