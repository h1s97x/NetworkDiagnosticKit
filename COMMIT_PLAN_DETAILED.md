# network_diagnostic_kit 完整提交计划

**项目**: network_diagnostic_kit  
**GitHub**: https://github.com/h1s97x/NetworkDiagnosticKit  
**日期**: 2026-03-08

---

## 提交策略

本计划包含从项目初始化到 v1.1.0 的所有提交，采用原子化提交方式，每个提交只包含一个逻辑变更。

---

## v1.0.0 基础版本提交

### 阶段 1: 项目初始化

#### 提交 1: 初始化项目结构

```bash
git add .gitignore .metadata pubspec.yaml analysis_options.yaml
git commit -m "chore: initialize Flutter plugin project

- Add .gitignore for Flutter/Dart
- Add .metadata for Flutter tooling
- Add pubspec.yaml with project metadata
- Add analysis_options.yaml with linter rules"
```

#### 提交 2: 添加许可证

```bash
git add LICENSE
git commit -m "chore: add MIT license"
```

#### 提交 3: 添加基础文档

```bash
git add README.md
git commit -m "docs: add initial README

- Add project description
- Add feature list
- Add installation instructions
- Add basic usage examples"
```

---

### 阶段 2: 核心数据模型 (v1.0.0)

#### 提交 4: 添加网络类型枚举

```bash
git add lib/src/enums/network_type.dart
git commit -m "feat(enums): add NetworkType enum

- Define network types (wifi, mobile, ethernet, etc.)
- Add displayName getter for user-friendly names"
```

#### 提交 5: 添加质量等级枚举

```bash
git add lib/src/enums/quality_level.dart
git commit -m "feat(enums): add QualityLevel enum

- Define quality levels (excellent, good, fair, poor, bad)
- Add displayName getter"
```

#### 提交 6: 导出枚举

```bash
git add lib/src/enums/enums.dart
git commit -m "feat(enums): export all enums

- Export NetworkType
- Export QualityLevel"
```

#### 提交 7: 添加网络连接信息模型

```bash
git add lib/src/models/network_connection_info.dart
git commit -m "feat(models): add NetworkConnectionInfo model

- Add connection status fields
- Add network type
- Add IP address, gateway, MAC address
- Add WiFi SSID and signal strength
- Support JSON serialization"
```

#### 提交 8: 添加网速测试结果模型

```bash
git add lib/src/models/speed_test_result.dart
git commit -m "feat(models): add SpeedTestResult model

- Add download/upload speed
- Add ping, jitter, packet loss
- Add timestamp and server info
- Support JSON serialization"
```

#### 提交 9: 添加 Ping 测试结果模型

```bash
git add lib/src/models/ping_result.dart
git commit -m "feat(models): add PingResult model

- Add sent/received/lost packet counts
- Add min/max/average time
- Add packet loss percentage
- Add individual ping times
- Support JSON serialization"
```

#### 提交 10: 添加 DNS 测试结果模型

```bash
git add lib/src/models/dns_test_result.dart
git commit -m "feat(models): add DnsTestResult model

- Add DNS server and domain
- Add success status
- Add response time
- Add resolved IP address
- Add error message
- Support JSON serialization"
```

#### 提交 11: 添加网络质量评分模型

```bash
git add lib/src/models/network_quality_score.dart
git commit -m "feat(models): add NetworkQualityScore model

- Add quality score (0-100)
- Add quality level
- Add detailed metrics
- Add optimization suggestions
- Support JSON serialization"
```

#### 提交 12: 导出所有模型

```bash
git add lib/src/models/models.dart
git commit -m "feat(models): export all data models

- Export NetworkConnectionInfo
- Export SpeedTestResult
- Export PingResult
- Export DnsTestResult
- Export NetworkQualityScore"
```

---

### 阶段 3: 异常处理 (v1.0.0)

#### 提交 13: 添加网络诊断异常

```bash
git add lib/src/exceptions/network_diagnostic_exception.dart
git commit -m "feat(exceptions): add NetworkDiagnosticException

- Add custom exception class
- Include error message, code, and details
- Support exception chaining"
```

---

### 阶段 4: 核心 API (v1.0.0)

#### 提交 14: 添加核心网络诊断类

```bash
git add lib/src/network_diagnostic.dart
git commit -m "feat(api): add NetworkDiagnostic core class

- Add checkConnection method
- Add runSpeedTest method
- Add ping method
- Add testDns method
- Add evaluateQuality method
- Add checkPort method
- Add onConnectivityChanged stream"
```

---

### 阶段 5: 平台接口 (v1.0.0)

#### 提交 15: 添加平台接口定义

```bash
git add lib/network_diagnostic_kit_platform_interface.dart
git commit -m "feat(platform): add platform interface

- Define abstract platform interface
- Use plugin_platform_interface
- Support method channel implementation"
```

#### 提交 16: 添加方法通道实现

```bash
git add lib/network_diagnostic_kit_method_channel.dart
git commit -m "feat(platform): add method channel implementation

- Implement platform interface
- Use MethodChannel for platform communication
- Handle platform method calls"
```

#### 提交 17: 添加主导出文件

```bash
git add lib/network_diagnostic_kit.dart
git commit -m "feat(api): add main library export

- Export NetworkDiagnostic
- Export all models
- Export all enums
- Export exceptions"
```

---

### 阶段 6: Android 平台实现 (v1.0.0)

#### 提交 18: 添加 Android 配置

```bash
git add android/.gitignore android/build.gradle.kts android/settings.gradle android/settings.gradle.kts
git commit -m "feat(android): add Android build configuration

- Add Gradle build files
- Configure Kotlin support
- Set up plugin structure"
```

#### 提交 19: 添加 Android 插件实现

```bash
git add android/src/main/kotlin/com/example/network_diagnostic_kit/NetworkDiagnosticKitPlugin.kt
git commit -m "feat(android): add Android plugin implementation

- Implement NetworkDiagnosticKitPlugin
- Handle method channel calls
- Implement network diagnostic methods"
```

#### 提交 20: 添加 Android 清单文件

```bash
git add android/src/main/AndroidManifest.xml
git commit -m "feat(android): add Android manifest

- Configure plugin package
- Add required permissions"
```

#### 提交 21: 添加 Android 测试

```bash
git add android/src/test/kotlin/com/example/network_diagnostic_kit/NetworkDiagnosticKitPluginTest.kt
git commit -m "test(android): add Android plugin tests

- Add unit tests for plugin
- Test method channel communication"
```

---

### 阶段 7: iOS 平台实现 (v1.0.0)

#### 提交 22: 添加 iOS 配置

```bash
git add ios/network_diagnostic_kit.podspec ios/Classes/
git commit -m "feat(ios): add iOS plugin implementation

- Add podspec configuration
- Implement Swift plugin
- Handle method channel calls"
```

---

### 阶段 8: 测试 (v1.0.0)

#### 提交 23: 添加单元测试

```bash
git add test/network_diagnostic_kit_test.dart
git commit -m "test: add comprehensive unit tests

- Test NetworkDiagnostic methods
- Test data models
- Test JSON serialization
- Test exception handling"
```

#### 提交 24: 添加测试配置

```bash
git add test/test_helper.dart
git commit -m "test: add test helper utilities

- Add mock data generators
- Add test utilities"
```

---

### 阶段 9: 示例应用 (v1.0.0)

#### 提交 25: 初始化示例应用

```bash
git add example/pubspec.yaml example/analysis_options.yaml
git commit -m "feat(example): initialize example app

- Add example app configuration
- Configure dependencies"
```

#### 提交 26: 添加示例应用主界面

```bash
git add example/lib/main.dart
git commit -m "feat(example): add main example app

- Add home page with all features
- Add connection info display
- Add speed test UI
- Add ping test UI
- Add DNS test UI
- Add port check UI"
```

#### 提交 27: 添加 Android 示例配置

```bash
git add example/android/
git commit -m "feat(example): add Android example configuration

- Configure Android app
- Add required permissions
- Set up build files"
```

#### 提交 28: 添加 iOS 示例配置

```bash
git add example/ios/
git commit -m "feat(example): add iOS example configuration

- Configure iOS app
- Add required permissions
- Set up project files"
```

---

### 阶段 10: 文档 (v1.0.0)

#### 提交 29: 添加 API 文档

```bash
git add doc/API.md
git commit -m "docs: add comprehensive API documentation

- Document NetworkDiagnostic class
- Document all data models
- Add usage examples
- Add code snippets"
```

#### 提交 30: 添加架构文档

```bash
git add doc/ARCHITECTURE.md
git commit -m "docs: add architecture documentation

- Document project structure
- Explain design patterns
- Add component diagrams
- Document data flow"
```

#### 提交 31: 添加使用指南

```bash
git add doc/USAGE_GUIDE.md
git commit -m "docs: add usage guide

- Add installation instructions
- Add basic usage examples
- Add advanced features
- Add best practices
- Add troubleshooting"
```

#### 提交 32: 添加代码风格指南

```bash
git add doc/CODE_STYLE.md
git commit -m "docs: add code style guide

- Define naming conventions
- Define formatting rules
- Add code examples
- Add best practices"
```

#### 提交 33: 添加快速参考

```bash
git add doc/QUICK_REFERENCE.md
git commit -m "docs: add quick reference guide

- Add quick API reference
- Add common use cases
- Add code snippets"
```

#### 提交 34: 添加发布检查清单

```bash
git add doc/RELEASE_CHECKLIST.md
git commit -m "docs: add release checklist

- Add pre-release checks
- Add testing requirements
- Add documentation requirements
- Add publishing steps"
```

#### 提交 35: 添加贡献指南

```bash
git add CONTRIBUTING.md
git commit -m "docs: add contribution guide

- Add contribution guidelines
- Add code of conduct
- Add pull request process
- Add development setup"
```

#### 提交 36: 添加变更日志

```bash
git add CHANGELOG.md
git commit -m "docs: add changelog for v1.0.0

- Document initial release
- List all features
- Add installation instructions"
```

---

### 阶段 11: 发布 v1.0.0

#### 提交 37: 准备 v1.0.0 发布

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): prepare v1.0.0 release

- Set version to 1.0.0
- Finalize changelog
- Update documentation"
```

#### 提交 38: 创建 v1.0.0 标签

```bash
git tag -a v1.0.0 -m "Release version 1.0.0

Initial release with core features:
- Network connection diagnostics
- Speed testing
- Ping testing
- DNS testing
- Port checking
- Network quality evaluation"
```

---

## v1.1.0 功能增强版本提交

### 阶段 12: 基准测试核心功能 (v1.1.0)

#### 提交 39: 添加基准测试结果模型

```bash
git add lib/src/models/benchmark_result.dart
git commit -m "feat(models): add BenchmarkResult model

- Add BenchmarkResult class with performance metrics
- Include iterations, duration, standard deviation
- Add operations per second calculation
- Support JSON serialization"
```

#### 提交 40: 添加基准测试套件结果模型

```bash
git add lib/src/models/benchmark_suite_result.dart
git commit -m "feat(models): add BenchmarkSuiteResult model

- Add BenchmarkSuiteResult for test suite results
- Support multiple benchmark results
- Include device info metadata
- Add result lookup by test name"
```

#### 提交 41: 更新模型导出

```bash
git add lib/src/models/models.dart
git commit -m "feat(models): export benchmark models

- Export BenchmarkResult
- Export BenchmarkSuiteResult"
```

---

### 阶段 13: 基准测试运行器 (v1.1.0)

#### 提交 42: 添加 BenchmarkRunner

```bash
git add lib/src/benchmark/benchmark_runner.dart
git commit -m "feat(benchmark): add BenchmarkRunner

- Add generic benchmark runner
- Support warmup iterations
- Calculate detailed statistics (avg, min, max, stddev)
- Support test suites with multiple tests
- Add metadata support"
```

#### 提交 43: 添加 NetworkBenchmark

```bash
git add lib/src/benchmark/network_benchmark.dart
git commit -m "feat(benchmark): add NetworkBenchmark

- Add network diagnostic specific benchmarks
- Support runAll for comprehensive testing
- Add benchmarkConnection for connection tests
- Add benchmarkPing for ping tests
- Add benchmarkDns for DNS tests
- Add benchmarkPortCheck for port tests"
```

#### 提交 44: 更新主导出文件

```bash
git add lib/network_diagnostic_kit.dart
git commit -m "feat(api): export benchmark modules

- Export BenchmarkRunner
- Export NetworkBenchmark
- Make benchmark API publicly available"
```

---

### 阶段 14: 测试 (v1.1.0)

#### 提交 45: 添加基准测试单元测试

```bash
git add test/benchmark_test.dart
git commit -m "test(benchmark): add comprehensive unit tests

- Test BenchmarkRunner basic functionality
- Test statistics calculation accuracy
- Test suite execution
- Test JSON serialization
- Test result formatting"
```

---

### 阶段 15: 示例和文档 (v1.1.0)

#### 提交 46: 添加 Flutter 应用内基准测试示例

```bash
git add example/lib/benchmark_example.dart
git commit -m "feat(example): add benchmark example page

- Add interactive benchmark UI
- Support running all benchmarks
- Support individual benchmark tests
- Display detailed results with metrics
- Show progress indicator"
```

#### 提交 47: 更新示例应用主界面

```bash
git add example/lib/main.dart
git commit -m "feat(example): integrate benchmark example

- Add navigation to benchmark page
- Update main menu"
```

#### 提交 48: 添加独立基准测试脚本

```bash
git add benchmark/network_benchmark_test.dart
git commit -m "feat(benchmark): add standalone benchmark script

- Add command-line benchmark script
- Test all network diagnostic functions
- Print detailed performance results
- Support running independently"
```

---

### 阶段 16: 文档更新 (v1.1.0)

#### 提交 49: 更新 README

```bash
git add README.md
git commit -m "docs(readme): add benchmark documentation

- Add benchmark feature to feature list
- Add benchmark usage examples
- Add benchmark API reference
- Add benchmark data models
- Update project repository URL"
```

#### 提交 50: 更新 CHANGELOG

```bash
git add CHANGELOG.md
git commit -m "docs(changelog): add v1.1.0 release notes

- Document new benchmark system
- List all new features
- Document improvements
- Add migration guide"
```

#### 提交 51: 创建基准测试指南

```bash
git add doc/BENCHMARK_GUIDE.md
git commit -m "docs(guide): add comprehensive benchmark guide

- Add benchmark overview
- Add quick start guide
- Document all benchmark types
- Add custom benchmark examples
- Add result analysis guide
- Add best practices
- Add performance optimization tips"
```

#### 提交 52: 更新 API 文档

```bash
git add doc/API.md
git commit -m "docs(api): update API reference for v1.1.0

- Add NetworkBenchmark API documentation
- Add BenchmarkRunner API documentation
- Add benchmark data models
- Update examples
- Adapt to network_diagnostic_kit project"
```

#### 提交 53: 更新架构文档

```bash
git add doc/ARCHITECTURE.md
git commit -m "docs(architecture): update architecture documentation

- Add benchmark system architecture
- Document benchmark components
- Update project structure
- Add benchmark data flow
- Adapt to network_diagnostic_kit project"
```

#### 提交 54: 更新代码风格指南

```bash
git add doc/CODE_STYLE.md
git commit -m "docs(style): update code style guide

- Update naming conventions
- Update code examples
- Add benchmark code examples
- Adapt to network_diagnostic_kit project"
```

#### 提交 55: 更新快速参考

```bash
git add doc/QUICK_REFERENCE.md
git commit -m "docs(reference): update quick reference

- Add benchmark quick reference
- Add benchmark examples
- Update data models
- Adapt to network_diagnostic_kit project"
```

#### 提交 56: 更新发布检查清单

```bash
git add doc/RELEASE_CHECKLIST.md
git commit -m "docs(release): update release checklist

- Update for network_diagnostic_kit
- Add benchmark testing steps
- Update repository URLs"
```

#### 提交 57: 更新发布总结

```bash
git add doc/RELEASE_SUMMARY.md
git commit -m "docs(release): add v1.1.0 release summary

- Document benchmark system features
- Add technical details
- Add performance data
- Add migration guide
- Update repository URLs"
```

#### 提交 58: 创建使用指南

```bash
git add doc/USAGE_GUIDE.md
git commit -m "docs(guide): update comprehensive usage guide

- Update installation guide
- Add benchmark usage examples
- Update advanced features
- Add benchmark best practices
- Update troubleshooting"
```

#### 提交 59: 创建项目更新总结

```bash
git add doc/PROJECT_UPDATE_SUMMARY.md
git commit -m "docs(summary): add project update summary

- Document all changes in v1.1.0
- List new files
- Document features
- Add usage examples
- Add testing information"
```

---

### 阶段 17: 配置和工具 (v1.1.0)

#### 提交 60: 更新 pubspec.yaml

```bash
git add pubspec.yaml
git commit -m "chore(config): update project metadata

- Update homepage URL to h1s97x/NetworkDiagnosticKit
- Update project description
- Maintain version 1.0.0 (will bump in release)"
```

#### 提交 61: 更新 analysis_options.yaml

```bash
git add analysis_options.yaml
git commit -m "chore(config): exclude benchmark from analysis

- Exclude benchmark/** directory
- Allow print statements in CLI scripts
- Maintain strict checks for main codebase"
```

#### 提交 62: 更新 .pubignore

```bash
git add .pubignore
git commit -m "chore(config): update .pubignore

- Exclude documentation files
- Exclude CI reports
- Exclude commit plans
- Keep package clean"
```

#### 提交 63: 更新贡献指南

```bash
git add CONTRIBUTING.md
git commit -m "docs(contributing): update contribution guide

- Update repository URLs
- Update documentation links
- Adapt to network_diagnostic_kit"
```

#### 提交 64: 添加提交计划

```bash
git add COMMIT_PLAN.md COMMIT_PLAN_DETAILED.md
git commit -m "docs(plan): add commit plans for v1.1.0

- Add comprehensive commit plan
- Add detailed commit strategy
- Document all changes
- Update repository information"
```

---

### 阶段 18: CI 和质量保证 (v1.1.0)

#### 提交 65: 代码格式化

```bash
dart format .
git add -A
git commit -m "style: format code with dart format

- Format all Dart files
- Fix indentation
- Ensure consistent style
- 24 files formatted"
```

#### 提交 66: 修复代码风格问题

```bash
dart fix --apply
git add lib/src/exceptions/network_diagnostic_exception.dart \
        lib/src/models/benchmark_result.dart \
        lib/src/models/benchmark_suite_result.dart \
        lib/src/models/dns_test_result.dart \
        lib/src/models/network_connection_info.dart \
        lib/src/models/network_quality_score.dart \
        lib/src/models/ping_result.dart \
        lib/src/models/speed_test_result.dart
git commit -m "fix(style): fix linter issues

- Fix constructor ordering (sort_constructors_first)
- Fix parameter ordering (always_put_required_named_parameters_first)
- Apply dart fix --apply
- 14 fixes in 8 files"
```

#### 提交 67: 运行测试并生成覆盖率

```bash
flutter test --coverage
git add coverage/lcov.info
git commit -m "test: update test coverage report

- Run all unit tests
- Generate coverage report
- All tests passing"
```

#### 提交 68: 添加 CI 报告

```bash
git add doc/CI_REPORT.md doc/CI_STATUS.md
git commit -m "docs(ci): add CI execution reports

- Add detailed CI report
- Add CI status summary
- Document all checks passed
- Include quality metrics"
```

---

### 阶段 19: 版本发布准备 (v1.1.0)

#### 提交 69: 更新版本号

```bash
# 更新 pubspec.yaml 中的版本号为 1.1.0
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): bump version to 1.1.0

- Update version in pubspec.yaml
- Finalize CHANGELOG.md
- Prepare for release"
```

#### 提交 70: 最终验证

```bash
# 运行所有检查
flutter analyze
flutter test
dart format . --set-exit-if-changed

# 如果一切正常，继续
git status
# 应该显示 "nothing to commit, working tree clean"
```

#### 提交 71: 创建 v1.1.0 标签

```bash
git tag -a v1.1.0 -m "Release version 1.1.0

New Features:
- Performance benchmark system
- BenchmarkRunner for generic benchmarking
- NetworkBenchmark for network diagnostics
- Comprehensive documentation

Improvements:
- Updated all documentation
- Fixed code style issues
- Passed all CI checks
- Added benchmark examples

Compatibility:
- Backward compatible with v1.0.0
- No breaking changes

Testing:
- All unit tests passing
- Code coverage maintained
- Benchmark tests added"
```

---

## 提交执行指南

### 推荐执行方式

根据项目当前状态，选择合适的执行方式：

#### 方式 A: 从头开始（新项目）

如果这是一个全新的项目，按照提交 1-71 的顺序执行。

#### 方式 B: 仅提交 v1.1.0 更改（推荐）

如果 v1.0.0 已经存在，只执行提交 39-71。

```bash
# 从提交 39 开始
git add lib/src/models/benchmark_result.dart
git commit -m "feat(models): add BenchmarkResult model..."

# 继续后续提交...
```

#### 方式 C: 分阶段批量提交

将相关提交合并为阶段性提交：

```bash
# 阶段 12: 基准测试核心
git add lib/src/models/benchmark_result.dart \
        lib/src/models/benchmark_suite_result.dart \
        lib/src/models/models.dart
git commit -m "feat(models): add benchmark result models

- Add BenchmarkResult model
- Add BenchmarkSuiteResult model
- Export benchmark models"

# 阶段 13: 基准测试运行器
git add lib/src/benchmark/
git add lib/network_diagnostic_kit.dart
git commit -m "feat(benchmark): add benchmark system

- Add BenchmarkRunner
- Add NetworkBenchmark
- Export benchmark modules"

# 阶段 14: 测试
git add test/benchmark_test.dart
git commit -m "test(benchmark): add comprehensive unit tests"

# 阶段 15: 示例
git add example/lib/benchmark_example.dart \
        example/lib/main.dart \
        benchmark/network_benchmark_test.dart
git commit -m "feat(example): add benchmark examples

- Add Flutter benchmark example page
- Add standalone benchmark script
- Update main app navigation"

# 阶段 16: 文档
git add README.md CHANGELOG.md doc/
git commit -m "docs: update documentation for v1.1.0

- Update README with benchmark features
- Add CHANGELOG for v1.1.0
- Add BENCHMARK_GUIDE.md
- Update all documentation files"

# 阶段 17: 配置
git add pubspec.yaml analysis_options.yaml .pubignore CONTRIBUTING.md \
        COMMIT_PLAN.md COMMIT_PLAN_DETAILED.md
git commit -m "chore(config): update project configuration

- Update pubspec.yaml metadata
- Update analysis_options.yaml
- Update .pubignore
- Add commit plans"

# 阶段 18: 质量保证
dart format .
git add -A
git commit -m "style: format code with dart format"

dart fix --apply
git add -A
git commit -m "fix(style): fix linter issues"

flutter test --coverage
git add coverage/lcov.info doc/CI_REPORT.md doc/CI_STATUS.md
git commit -m "test: update test coverage and CI reports"

# 阶段 19: 发布
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): bump version to 1.1.0"
```

---

## 发布流程

### 1. 确认所有更改已提交

```bash
git status
# 应该显示 "nothing to commit, working tree clean"
```

### 2. 最终检查

```bash
# 代码分析
flutter analyze
# 应该显示 "No issues found!"

# 运行测试
flutter test
# 应该显示 "All tests passed!"

# 检查格式
dart format . --set-exit-if-changed
# 应该显示 "Formatted 0 files"
```

### 3. 创建版本标签

```bash
git tag -a v1.1.0 -m "Release version 1.1.0

New Features:
- Performance benchmark system
- BenchmarkRunner for generic benchmarking
- NetworkBenchmark for network diagnostics
- Comprehensive documentation

Improvements:
- Updated all documentation
- Fixed code style issues
- Passed all CI checks

Compatibility:
- Backward compatible with v1.0.0
- No breaking changes"
```

### 4. 推送到远程仓库

```bash
# 推送代码
git push origin main

# 推送标签
git push origin v1.1.0
```

### 5. 创建 GitHub Release

1. 访问 <https://github.com/h1s97x/NetworkDiagnosticKit/releases>
2. 点击 "Draft a new release"
3. 选择标签 v1.1.0
4. 填写发布标题: "v1.1.0 - Performance Benchmark System"
5. 复制 CHANGELOG.md 中的 v1.1.0 内容到发布说明
6. 点击 "Publish release"

### 6. 发布到 pub.dev（可选）

```bash
# 验证包
flutter pub publish --dry-run

# 如果验证通过，发布
flutter pub publish
```

---

## 验证清单

在推送之前，确保：

- [ ] 所有文件已添加到 Git
- [ ] 提交信息清晰明确，遵循 Conventional Commits
- [ ] 代码格式正确 (`dart format .`)
- [ ] 无静态分析问题 (`flutter analyze`)
- [ ] 所有测试通过 (`flutter test`)
- [ ] 测试覆盖率报告已生成
- [ ] 文档已更新（README, CHANGELOG, API docs）
- [ ] 版本号已更新（pubspec.yaml）
- [ ] 示例应用可以正常运行
- [ ] 基准测试可以正常执行

---

## 回滚计划

如果发现问题需要回滚：

### 回滚到上一个提交

```bash
git reset --hard HEAD~1
```

### 回滚到特定提交

```bash
git log --oneline  # 查看提交历史
git reset --hard <commit-hash>
```

### 回滚到 v1.0.0

```bash
git reset --hard v1.0.0
```

### 撤销推送（谨慎使用）

```bash
# 仅在必要时使用，会影响其他协作者
git push origin main --force
```

### 删除标签

```bash
# 删除本地标签
git tag -d v1.1.0

# 删除远程标签
git push origin :refs/tags/v1.1.0
```

---

## 提交信息规范

### Conventional Commits 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 类型（type）

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具相关
- `perf`: 性能优化
- `ci`: CI 配置更改

### 范围（scope）

- `models`: 数据模型
- `api`: API 接口
- `benchmark`: 基准测试
- `example`: 示例应用
- `docs`: 文档
- `config`: 配置文件
- `android`: Android 平台
- `ios`: iOS 平台

### 示例

```bash
# 功能提交
git commit -m "feat(benchmark): add NetworkBenchmark class

- Add runAll method for comprehensive testing
- Add individual benchmark methods
- Support custom test parameters"

# 修复提交
git commit -m "fix(models): correct JSON serialization

- Fix null handling in toJson
- Add missing fields
- Update tests"

# 文档提交
git commit -m "docs(api): update API reference

- Add benchmark API documentation
- Update examples
- Fix typos"

# 破坏性更改
git commit -m "feat(api): redesign benchmark API

BREAKING CHANGE: BenchmarkRunner constructor now requires
NetworkDiagnostic instance as parameter"
```

---

## 注意事项

1. **提交前测试**: 每次提交前运行 `flutter test` 确保代码可用
2. **提交信息规范**: 严格遵循 Conventional Commits 规范
3. **原子性**: 每个提交只包含一个逻辑变更
4. **文档同步**: 代码和文档同步更新
5. **版本标签**: 使用语义化版本号（SemVer）
6. **代码审查**: 重要更改应该经过代码审查
7. **备份**: 在执行破坏性操作前创建备份分支

---

## 相关文档

- [COMMIT_PLAN.md](COMMIT_PLAN.md) - 简化版提交计划
- [CHANGELOG.md](CHANGELOG.md) - 版本更新日志
- [CONTRIBUTING.md](CONTRIBUTING.md) - 贡献指南
- [doc/RELEASE_CHECKLIST.md](doc/RELEASE_CHECKLIST.md) - 发布检查清单
- [doc/RELEASE_SUMMARY.md](doc/RELEASE_SUMMARY.md) - 发布总结
- [doc/CI_REPORT.md](doc/CI_REPORT.md) - CI 执行报告

---

## 快速命令参考

```bash
# 查看状态
git status

# 查看差异
git diff

# 查看提交历史
git log --oneline --graph

# 暂存所有更改
git add -A

# 提交
git commit -m "message"

# 推送
git push origin main

# 创建标签
git tag -a v1.1.0 -m "message"

# 推送标签
git push origin v1.1.0

# 运行测试
flutter test

# 代码分析
flutter analyze

# 代码格式化
dart format .

# 自动修复
dart fix --apply

# 生成覆盖率
flutter test --coverage

# 查看覆盖率
genhtml coverage/lcov.info -o coverage/html
```

---

**文档版本**: 1.0  
**更新日期**: 2026-03-08  
**项目**: network_diagnostic_kit  
**GitHub**: <https://github.com/h1s97x/NetworkDiagnosticKit>  
**状态**: 准备发布 ✅
