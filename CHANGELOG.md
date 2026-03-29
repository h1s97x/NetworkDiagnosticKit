# Changelog | 更新日志

## Table of Contents | 目录

- [English](#english)
- [中文](#中文)

---

## English

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [1.0.5] - 2026-03-29

#### Fixed

- Fixed Android plugin loading error caused by incorrect package name configuration
- Updated Android package from `com.example.network_diagnostic_kit` to `dev.fluttercommunity.network_diagnostic_kit`
- Implemented complete Android native plugin with full network diagnostic support
- Fixed missing Android plugin class implementation
- Updated test files to match new package structure

### [1.0.4] - 2026-03-16

#### Added

- Complete dartdoc documentation for all public APIs
- Comprehensive documentation for all diagnostic features
- Usage examples in API documentation
- Pub.dev release checklist and summary documents

#### Improved

- Enhanced library-level documentation with quick start guide
- Better organized API documentation
- Improved code examples in documentation

### [1.0.0] - 2026-03-08

#### Added

- Initial release of network_diagnostic_kit
- Network speed test functionality
- DNS lookup functionality
- Ping test functionality
- Trace route functionality
- Network quality evaluation
- Cross-platform support (Android, Windows)

#### Core Features

- **NetworkDiagnostic**: Main network diagnostics class
- **SpeedTestResult**: Speed test result model
- **PingResult**: Ping test result model
- **DnsLookupResult**: DNS lookup result model
- **TraceRouteResult**: Trace route result model
- **NetworkInfo**: Network information model
- **NetworkQuality**: Network quality assessment model

#### Diagnostic Features

- **Speed Test**: Download and upload speed measurement
- **DNS Lookup**: Resolve domain names to IP addresses
- **Ping Test**: Measure network latency and packet loss
- **Trace Route**: Display network path to destination
- **Network Quality**: Overall network quality assessment

#### Platform Support

- ✅ Android (API 21+)
- ✅ Windows (Windows 10+)

#### Documentation

- Complete README with usage examples
- Quick start guide
- API documentation
- Example app with polished UI
- English language support

#### Technical Features

- Asynchronous API, non-blocking main thread
- Comprehensive error handling
- Real-time network monitoring
- Cross-platform support
- Singleton pattern design

---

## 中文

本项目的所有重要变更都将记录在此文件中。

日志格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
项目版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

### [1.0.5] - 2026-03-29

#### 修复

- 修复了由错误的包名配置导致的 Android 插件加载错误
- 将 Android 包名从 `com.example.network_diagnostic_kit` 更新为 `dev.fluttercommunity.network_diagnostic_kit`
- 实现了完整的 Android 原生插件，支持全面的网络诊断功能
- 修复了缺失的 Android 插件类实现
- 更新了测试文件以匹配新的包结构

### [1.0.4] - 2026-03-16

#### 新增功能

- 为所有公共 API 添加了完整的 DartDoc 文档
- 为所有诊断功能添加了全面的文档
- 在 API 文档中添加了使用示例
- Pub.dev 发布检查清单和总结文档

#### 改进

- 增强了库级文档，添加快速入门指南
- 更好地组织了 API 文档
- 改进了文档中的代码示例

### [1.0.0] - 2026-03-08

#### 新增功能

- network_diagnostic_kit 首次发布
- 网络测速功能
- DNS 查询功能
- Ping 测试功能
- 路由跟踪功能
- 网络质量评估
- 跨平台支持（Android、Windows）

#### 核心功能

- **NetworkDiagnostic**: 主要的网络诊断类
- **SpeedTestResult**: 网速测试结果模型
- **PingResult**: Ping 测试结果模型
- **DnsLookupResult**: DNS 查询结果模型
- **TraceRouteResult**: 路由跟踪结果模型
- **NetworkInfo**: 网络信息模型
- **NetworkQuality**: 网络质量评估模型

#### 诊断功能

- **网络测速**: 下载和上传速度测量
- **DNS 查询**: 将域名解析为 IP 地址
- **Ping 测试**: 测量网络延迟和丢包率
- **路由跟踪**: 显示到目的地的网络路径
- **网络质量**: 整体网络质量评估

#### 平台支持

- ✅ Android (API 21+)
- ✅ Windows (Windows 10+)

#### 文档

- 包含使用示例的完整 README
- 快速入门指南
- API 文档
- 带有精美 UI 的示例应用
- 中文语言支持

#### 技术特性

- 异步 API，不阻塞主线程
- 完善的错误处理机制
- 实时网络监控
- 跨平台支持
- 单例模式设计

---

## 版本说明

- **主版本号**: 不兼容的 API 变更
- **次版本号**: 向下兼容的功能新增
- **修订号**: 向下兼容的问题修正

## 反馈与支持

如有问题或建议，请访问：

- GitHub Issues: [https://github.com/h1s97x/NetworkDiagnosticKit/issues](https://github.com/h1s97x/NetworkDiagnosticKit/issues)
- GitHub 仓库: [https://github.com/h1s97x/NetworkDiagnosticKit](https://github.com/h1s97x/NetworkDiagnosticKit)

## 许可证

本项目采用 MIT 许可证，详见 LICENSE 文件。
