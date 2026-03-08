# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-03-08

### Added

- ⚡ 性能基准测试系统
- 📊 BenchmarkRunner - 通用基准测试运行器
- 🧪 NetworkBenchmark - 网络诊断专用基准测试
- 📈 BenchmarkResult - 基准测试结果模型
- 📋 BenchmarkSuiteResult - 基准测试套件结果模型

### Features

- 支持自定义迭代次数和预热阶段
- 提供详细的统计信息（平均值、最小值、最大值、标准差）
- 计算每秒操作数（ops/sec）
- 支持测试套件批量运行
- 独立的基准测试脚本
- Flutter应用内基准测试示例

### Documentation

- 基准测试使用指南
- 性能测试最佳实践
- 基准测试输出示例

## [1.0.0] - 2026-03-08

### Added

- 🌐 网络连接检测功能
- 🚀 网速测试功能（下载/上传/延迟/抖动/丢包）
- 📡 Ping测试功能
- 🔍 DNS测试功能
- 📊 网络质量评分功能
- 🔌 端口扫描功能
- 🔄 实时网络状态监听
- 📱 支持 Android、iOS、Windows、Linux、macOS平台
- 📖 完整的API文档和示例应用

### Features
- NetworkConnectionInfo - 网络连接信息模型
- SpeedTestResult - 网速测试结果模型
- PingResult - Ping测试结果模型
- DnsTestResult - DNS测试结果模型
- NetworkQualityScore - 网络质量评分模型
- NetworkType - 网络类型枚举
- QualityLevel - 质量等级枚举

### Documentation
- README.md - 中文文档
- 完整的API参考
- 使用示例
- 故障排查指南

## [Unreleased]

### Planned
- 路由追踪功能
- 更详细的网速测试（多服务器）
- 网络历史记录
- 导出测试报告
- 更多平台优化
