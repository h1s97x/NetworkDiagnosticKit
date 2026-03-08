# network_diagnostic_kit 项目提交方案（v1.1.0）

[English Version](COMMIT_PLAN_EN.md)

---

## 项目信息

**准备日期**: 2026-03-08  
**项目**: network_diagnostic_kit  
**版本**: v1.1.0  
**提交方案**: 功能增强版本  
**GitHub**: https://github.com/h1s97x/NetworkDiagnosticKit

---

## 版本概述

v1.1.0 是一个功能增强版本，主要添加了完整的性能基准测试系统。该版本保持向后兼容，无破坏性更改。

### 主要更新

1. ⚡ 添加性能基准测试系统
2. 📊 新增 BenchmarkRunner 和 NetworkBenchmark 类
3. 📈 新增基准测试数据模型
4. 📝 更新所有文档以适配当前项目
5. 🔧 修复代码风格问题
6. ✅ 通过所有 CI 检查

---

## 提交策略

### 原子化提交原则

每个提交应该：
- 只包含一个逻辑变更
- 有清晰的提交信息
- 可以独立编译和测试
- 遵循 Conventional Commits 规范

### 提交类型

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具相关

---

## 详细提交计划

### 阶段 1: 基准测试核心功能

#### 提交 1: 添加基准测试结果模型

```bash
git add lib/src/models/benchmark_result.dart
git commit -m "feat(models): add BenchmarkResult model

- Add BenchmarkResult class with performance metrics
- Include iterations, duration, standard deviation
- Add operations per second calculation
- Support JSON serialization"
```

#### 提交 2: 添加基准测试套件结果模型

```bash
git add lib/src/models/benchmark_suite_result.dart
git commit -m "feat(models): add BenchmarkSuiteResult model

- Add BenchmarkSuiteResult for test suite results
- Support multiple benchmark results
- Include device info metadata
- Add result lookup by test name"
```

#### 提交 3: 更新模型导出

```bash
git add lib/src/models/models.dart
git commit -m "feat(models): export benchmark models

- Export BenchmarkResult
- Export BenchmarkSuiteResult"
```

---

### 阶段 2: 基准测试运行器

#### 提交 4: 添加 BenchmarkRunner

```bash
git add lib/src/benchmark/benchmark_runner.dart
git commit -m "feat(benchmark): add BenchmarkRunner

- Add generic benchmark runner
- Support warmup iterations
- Calculate detailed statistics (avg, min, max, stddev)
- Support test suites with multiple tests
- Add metadata support"
```

#### 提交 5: 添加 NetworkBenchmark

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

#### 提交 6: 更新主导出文件

```bash
git add lib/network_diagnostic_kit.dart
git commit -m "feat(api): export benchmark modules

- Export BenchmarkRunner
- Export NetworkBenchmark
- Make benchmark API publicly available"
```

---

### 阶段 3: 测试

#### 提交 7: 添加基准测试单元测试

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

### 阶段 4: 示例和文档

#### 提交 8: 添加 Flutter 应用内基准测试示例

```bash
git add example/lib/benchmark_example.dart
git commit -m "feat(example): add benchmark example page

- Add interactive benchmark UI
- Support running all benchmarks
- Support individual benchmark tests
- Display detailed results with metrics
- Show progress indicator"
```

#### 提交 9: 添加独立基准测试脚本

```bash
git add benchmark/network_benchmark_test.dart
git commit -m "feat(benchmark): add standalone benchmark script

- Add command-line benchmark script
- Test all network diagnostic functions
- Print detailed performance results
- Support running independently"
```

---

### 阶段 5: 文档更新

#### 提交 10: 更新 README

```bash
git add README.md
git commit -m "docs(readme): add benchmark documentation

- Add benchmark feature to feature list
- Add benchmark usage examples
- Add benchmark API reference
- Add benchmark data models
- Update project repository URL"
```

#### 提交 11: 更新 CHANGELOG

```bash
git add CHANGELOG.md
git commit -m "docs(changelog): add v1.1.0 release notes

- Document new benchmark system
- List all new features
- Document improvements
- Add migration guide"
```

#### 提交 12: 创建基准测试指南

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

#### 提交 13: 更新 API 文档

```bash
git add doc/API.md
git commit -m "docs(api): update API reference for v1.1.0

- Add NetworkBenchmark API documentation
- Add BenchmarkRunner API documentation
- Add benchmark data models
- Update examples
- Adapt to network_diagnostic_kit project"
```

#### 提交 14: 更新架构文档

```bash
git add doc/ARCHITECTURE.md
git commit -m "docs(architecture): update architecture documentation

- Add benchmark system architecture
- Document benchmark components
- Update project structure
- Add benchmark data flow
- Adapt to network_diagnostic_kit project"
```

#### 提交 15: 更新代码风格指南

```bash
git add doc/CODE_STYLE.md
git commit -m "docs(style): update code style guide

- Update naming conventions
- Update code examples
- Add benchmark code examples
- Adapt to network_diagnostic_kit project"
```

#### 提交 16: 更新快速参考

```bash
git add doc/QUICK_REFERENCE.md
git commit -m "docs(reference): update quick reference

- Add benchmark quick reference
- Add benchmark examples
- Update data models
- Adapt to network_diagnostic_kit project"
```

#### 提交 17: 更新发布检查清单

```bash
git add doc/RELEASE_CHECKLIST.md
git commit -m "docs(release): update release checklist

- Update for network_diagnostic_kit
- Add benchmark testing steps
- Update repository URLs"
```

#### 提交 18: 更新发布总结

```bash
git add doc/RELEASE_SUMMARY.md
git commit -m "docs(release): add v1.1.0 release summary

- Document benchmark system features
- Add technical details
- Add performance data
- Add migration guide
- Update repository URLs"
```

#### 提交 19: 创建使用指南

```bash
git add USAGE_GUIDE_NETWORK.md
git commit -m "docs(guide): add comprehensive usage guide

- Add installation guide
- Add basic usage examples
- Add advanced features
- Add benchmark guide
- Add best practices
- Add troubleshooting"
```

#### 提交 20: 创建项目更新总结

```bash
git add PROJECT_UPDATE_SUMMARY.md
git commit -m "docs(summary): add project update summary

- Document all changes in v1.1.0
- List new files
- Document features
- Add usage examples
- Add testing information"
```

---

### 阶段 6: 配置和工具

#### 提交 21: 更新 pubspec.yaml

```bash
git add pubspec.yaml
git commit -m "chore(config): update project metadata

- Update homepage URL to h1s97x/NetworkDiagnosticKit
- Update project description
- Maintain version 1.0.0 (will bump in release)"
```

#### 提交 22: 更新 analysis_options.yaml

```bash
git add analysis_options.yaml
git commit -m "chore(config): exclude benchmark from analysis

- Exclude benchmark/** directory
- Allow print statements in CLI scripts
- Maintain strict checks for main codebase"
```

#### 提交 23: 更新贡献指南

```bash
git add CONTRIBUTING.md
git commit -m "docs(contributing): update contribution guide

- Update repository URLs
- Update documentation links
- Adapt to network_diagnostic_kit"
```

#### 提交 24: 更新提交计划

```bash
git add COMMIT_PLAN.md
git commit -m "docs(plan): update commit plan for v1.1.0

- Document v1.1.0 changes
- Update repository information
- Add detailed commit strategy"
```

---

### 阶段 7: CI 和质量保证

#### 提交 25: 代码格式化

```bash
git add -A
git commit -m "style: format code with dart format

- Format 24 files
- Fix indentation
- Ensure consistent style"
```

#### 提交 26: 修复代码风格问题

```bash
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

#### 提交 27: 添加 CI 报告

```bash
git add CI_REPORT.md CI_STATUS.md
git commit -m "docs(ci): add CI execution reports

- Add detailed CI report
- Add CI status summary
- Document all checks passed
- Include quality metrics"
```

---

### 阶段 8: 版本发布准备

#### 提交 28: 更新版本号

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): bump version to 1.1.0

- Update version in pubspec.yaml
- Finalize CHANGELOG.md
- Prepare for release"
```

#### 提交 29: 最终检查

```bash
# 确保所有文件都已提交
git status

# 运行最终测试
flutter test

# 运行代码分析
flutter analyze
```

---

## 提交执行流程

### 方式 1: 逐个提交（推荐）

按照上述顺序逐个执行提交，确保每个提交都是原子性的。

```bash
# 示例：提交第一个
git add lib/src/models/benchmark_result.dart
git commit -m "feat(models): add BenchmarkResult model

- Add BenchmarkResult class with performance metrics
- Include iterations, duration, standard deviation
- Add operations per second calculation
- Support JSON serialization"

# 继续下一个...
```

### 方式 2: 分阶段提交

将相关的提交合并为阶段性提交。

```bash
# 阶段 1: 基准测试核心
git add lib/src/models/benchmark_result.dart \
        lib/src/models/benchmark_suite_result.dart \
        lib/src/models/models.dart
git commit -m "feat(models): add benchmark result models

- Add BenchmarkResult model
- Add BenchmarkSuiteResult model
- Export benchmark models"

# 阶段 2: 基准测试运行器
git add lib/src/benchmark/
git commit -m "feat(benchmark): add benchmark system

- Add BenchmarkRunner
- Add NetworkBenchmark
- Support comprehensive performance testing"

# 继续其他阶段...
```

### 方式 3: 单次提交（不推荐）

如果时间紧迫，可以使用单次提交，但会失去提交历史的清晰度。

```bash
git add .
git commit -m "feat: add benchmark system and update documentation for v1.1.0

Major changes:
- Add complete benchmark testing system
- Add BenchmarkRunner and NetworkBenchmark
- Add benchmark data models
- Update all documentation
- Fix code style issues
- Pass all CI checks

BREAKING CHANGE: None (backward compatible)"
```

---

## 发布流程

### 1. 确认所有更改已提交

```bash
git status
# 应该显示 "nothing to commit, working tree clean"
```

### 2. 创建版本标签

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

### 3. 推送到远程仓库

```bash
# 推送代码
git push origin main

# 推送标签
git push origin v1.1.0
```

### 4. 创建 GitHub Release

1. 访问 https://github.com/h1s97x/NetworkDiagnosticKit/releases
2. 点击 "Draft a new release"
3. 选择标签 v1.1.0
4. 填写发布说明（参考 CHANGELOG.md）
5. 上传构建产物（如需要）
6. 发布

---

## 提交信息模板

### 功能提交

```
feat(scope): brief description

- Detailed change 1
- Detailed change 2
- Detailed change 3

Closes #issue_number
```

### 修复提交

```
fix(scope): brief description

- What was broken
- How it was fixed
- Impact of the fix

Fixes #issue_number
```

### 文档提交

```
docs(scope): brief description

- What documentation was updated
- Why it was updated
- What was added/changed
```

### 样式提交

```
style(scope): brief description

- Formatting changes
- Code style fixes
- No functional changes
```

---

## 验证清单

在推送之前，确保：

- [ ] 所有文件已添加到 Git
- [ ] 提交信息清晰明确
- [ ] 代码格式正确 (`dart format .`)
- [ ] 无静态分析问题 (`flutter analyze`)
- [ ] 所有测试通过 (`flutter test`)
- [ ] 文档已更新
- [ ] CHANGELOG.md 已更新
- [ ] 版本号已更新

---

## 回滚计划

如果发现问题需要回滚：

### 回滚到上一个提交

```bash
git reset --hard HEAD~1
```

### 回滚到特定提交

```bash
git reset --hard <commit-hash>
```

### 撤销推送（谨慎使用）

```bash
git push origin main --force
```

---

## 注意事项

1. **提交前测试**: 每次提交前运行测试确保代码可用
2. **提交信息规范**: 遵循 Conventional Commits 规范
3. **原子性**: 每个提交只包含一个逻辑变更
4. **文档同步**: 代码和文档同步更新
5. **版本标签**: 使用语义化版本号

---

## 相关文档

- [CHANGELOG.md](CHANGELOG.md) - 版本更新日志
- [CONTRIBUTING.md](CONTRIBUTING.md) - 贡献指南
- [doc/RELEASE_CHECKLIST.md](doc/RELEASE_CHECKLIST.md) - 发布检查清单
- [doc/RELEASE_SUMMARY.md](doc/RELEASE_SUMMARY.md) - 发布总结

---

**文档版本**: 1.1  
**更新日期**: 2026-03-08  
**项目**: network_diagnostic_kit  
**状态**: 准备发布 ✅
