# network_diagnostic_kit 发布检查清单

本文档提供发布新版本前的完整检查清单。

## 版本发布流程

### 1. 准备阶段

#### 代码完成

- [ ] 所有计划功能已实现
- [ ] 所有已知 bug 已修复
- [ ] 代码审查已完成
- [ ] 所有 TODO 已处理或移至下一版本

#### 测试

- [ ] 所有单元测试通过
- [ ] 所有集成测试通过
- [ ] 手动测试所有平台
  - [ ] Android
  - [ ] iOS
  - [ ] Windows
  - [ ] Linux
  - [ ] macOS
  - [ ] Web (如适用)
- [ ] 性能基准测试通过
- [ ] 内存泄漏检查通过

#### 文档

- [ ] API 文档已更新
- [ ] README.md 已更新
- [ ] CHANGELOG.md 已更新
- [ ] 示例代码已更新
- [ ] 迁移指南已准备 (如有破坏性更改)

---

### 2. 版本号更新

#### 语义化版本

遵循 [Semantic Versioning](https://semver.org/)：

- **主版本号 (MAJOR)**: 不兼容的 API 更改
- **次版本号 (MINOR)**: 向后兼容的功能新增
- **修订号 (PATCH)**: 向后兼容的问题修正

#### 更新文件

- [ ] `pubspec.yaml` 中的 version
- [ ] `CHANGELOG.md` 中添加新版本
- [ ] 示例应用的依赖版本

```yaml
# pubspec.yaml
version: 1.1.0
```

---

### 3. 文档更新

#### CHANGELOG.md

```markdown
## [1.1.0] - 2026-03-08

### Added
- 性能基准测试系统
- BenchmarkRunner 类
- NetworkBenchmark 类

### Changed
- 优化网络连接检测性能

### Fixed
- 修复 DNS 测试超时问题

### Deprecated
- 旧的 API 方法 (将在 2.0.0 移除)
```

#### README.md

- [ ] 更新功能列表
- [ ] 更新安装说明
- [ ] 更新使用示例
- [ ] 更新 API 参考链接

#### API 文档

- [ ] 更新所有公共 API 文档
- [ ] 添加新功能的示例
- [ ] 更新参数说明
- [ ] 更新返回值说明

---

### 4. 代码质量检查

#### 静态分析

```bash
# 运行 Dart 分析
dart analyze

# 检查代码格式
dart format --set-exit-if-changed .

# 运行 linter
flutter analyze
```

- [ ] 无编译错误
- [ ] 无编译警告
- [ ] 无 linter 错误
- [ ] 代码格式正确

#### 测试覆盖率

```bash
# 运行测试并生成覆盖率报告
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

- [ ] 测试覆盖率 > 80%
- [ ] 核心功能覆盖率 > 90%
- [ ] 所有公共 API 都有测试

---

### 5. 平台特定检查

#### Android

- [ ] 最低 SDK 版本正确
- [ ] 目标 SDK 版本正确
- [ ] 权限声明完整
- [ ] ProGuard 规则正确 (如使用)
- [ ] 在多个 Android 版本测试

#### iOS

- [ ] 最低部署目标正确
- [ ] Info.plist 配置正确
- [ ] 权限说明完整
- [ ] 在多个 iOS 版本测试

#### Windows

- [ ] CMakeLists.txt 配置正确
- [ ] 依赖库正确链接
- [ ] 在 Windows 10/11 测试

#### Linux

- [ ] CMakeLists.txt 配置正确
- [ ] 依赖包正确声明
- [ ] 在主流发行版测试

#### macOS

- [ ] 最低部署目标正确
- [ ] 权限配置正确
- [ ] 在多个 macOS 版本测试

---

### 6. 性能检查

#### 基准测试

```bash
# 运行基准测试
dart benchmark/network_benchmark_test.dart
```

- [ ] 性能无明显退化
- [ ] 关键操作性能达标
- [ ] 内存使用合理

#### 性能指标

- [ ] 连接检查 < 100ms
- [ ] Ping 测试 < 200ms (取决于网络)
- [ ] DNS 解析 < 100ms (取决于网络)
- [ ] 内存占用 < 50MB

---

### 7. 安全检查

- [ ] 无硬编码敏感信息
- [ ] 输入验证完整
- [ ] 错误信息不泄露敏感数据
- [ ] 依赖包无已知漏洞

```bash
# 检查依赖包安全性
flutter pub outdated
```

---

### 8. 示例应用

- [ ] 示例应用可正常运行
- [ ] 所有功能都有示例
- [ ] 示例代码清晰易懂
- [ ] 示例应用文档完整

---

### 9. Git 操作

#### 提交代码

```bash
# 提交所有更改
git add .
git commit -m "chore: prepare for v1.1.0 release"
```

#### 创建标签

```bash
# 创建版本标签
git tag -a v1.1.0 -m "Release version 1.1.0"
```

#### 推送到远程

```bash
# 推送代码和标签
git push origin main
git push origin v1.1.0
```

- [ ] 代码已提交
- [ ] 标签已创建
- [ ] 已推送到远程仓库

---

### 10. 发布

#### GitHub Release

- [ ] 创建 GitHub Release
- [ ] 添加版本说明
- [ ] 上传构建产物 (如适用)
- [ ] 标记为 Latest Release

#### pub.dev (如发布到 pub.dev)

```bash
# 发布到 pub.dev
flutter pub publish --dry-run  # 先测试
flutter pub publish            # 正式发布
```

- [ ] 包信息正确
- [ ] 依赖版本正确
- [ ] 发布成功

---

### 11. 发布后

#### 验证

- [ ] 从 pub.dev 安装测试 (如适用)
- [ ] 从 GitHub 安装测试
- [ ] 文档链接正确
- [ ] 示例可正常运行

#### 通知

- [ ] 更新项目主页
- [ ] 发布公告 (如适用)
- [ ] 通知用户 (如适用)
- [ ] 更新相关文档

#### 监控

- [ ] 监控问题反馈
- [ ] 监控性能指标
- [ ] 准备热修复 (如需要)

---

## 版本类型检查清单

### 主版本 (Major Release)

- [ ] 破坏性更改已充分文档化
- [ ] 提供迁移指南
- [ ] 更新所有示例
- [ ] 提前通知用户

### 次版本 (Minor Release)

- [ ] 新功能已充分测试
- [ ] 向后兼容性已验证
- [ ] 文档已更新

### 修订版 (Patch Release)

- [ ] Bug 修复已验证
- [ ] 无新功能添加
- [ ] 快速发布流程

---

## 紧急修复流程

### 热修复 (Hotfix)

1. 从主分支创建热修复分支
2. 修复问题
3. 测试修复
4. 更新版本号 (修订号 +1)
5. 更新 CHANGELOG
6. 合并到主分支
7. 创建标签
8. 发布

```bash
# 创建热修复分支
git checkout -b hotfix/v1.1.1 main

# 修复并提交
git commit -m "fix: critical bug fix"

# 合并回主分支
git checkout main
git merge hotfix/v1.1.1

# 创建标签
git tag -a v1.1.1 -m "Hotfix release 1.1.1"

# 推送
git push origin main
git push origin v1.1.1
```

---

## 回滚流程

如果发现严重问题需要回滚：

1. 在 GitHub 上标记问题版本
2. 发布回滚公告
3. 指导用户降级
4. 准备修复版本

---

## 检查清单模板

```markdown
## 发布检查清单 - v1.1.0

### 准备阶段
- [x] 代码完成
- [x] 测试通过
- [x] 文档更新

### 版本更新
- [x] pubspec.yaml
- [x] CHANGELOG.md

### 质量检查
- [x] 静态分析通过
- [x] 测试覆盖率达标
- [x] 性能测试通过

### 平台测试
- [x] Android
- [x] iOS
- [x] Windows
- [ ] Linux
- [ ] macOS

### Git 操作
- [x] 代码提交
- [x] 标签创建
- [x] 推送远程

### 发布
- [ ] GitHub Release
- [ ] pub.dev 发布

### 发布后
- [ ] 验证安装
- [ ] 监控反馈
```

---

## 相关文档

- [CHANGELOG.md](../CHANGELOG.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [发布总结](RELEASE_SUMMARY.md)

---

**文档版本**: 1.1  
**创建日期**: 2026-03-08  
**项目**: network_diagnostic_kit
