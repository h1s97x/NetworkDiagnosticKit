/// 网络诊断工具包
///
/// 一个功能完整的 Flutter 网络诊断插件，提供以下功能：
///
/// - **网络连接检测**: 检测网络连通性、类型和连接信息
/// - **网速测试**: 测试下载/上传速度、延迟、抖动和丢包率
/// - **Ping 测试**: 测试网络延迟和稳定性
/// - **DNS 测试**: 测试 DNS 解析速度和可用性
/// - **网络质量评分**: 综合评估网络质量并提供优化建议
/// - **端口扫描**: 检测指定端口是否开放
/// - **实时监听**: 监听网络连接状态变化
/// - **性能基准测试**: 测试各项功能的性能指标
///
/// ## 快速开始
///
/// ```dart
/// import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';
///
/// // 检查网络连接
/// final connection = await NetworkDiagnostic.checkConnection();
/// print('网络类型: ${connection.type.displayName}');
///
/// // 运行网速测试
/// final speedTest = await NetworkDiagnostic.runSpeedTest();
/// print('下载速度: ${speedTest.downloadSpeed} Mbps');
///
/// // 评估网络质量
/// final quality = await NetworkDiagnostic.evaluateQuality();
/// print('网络评分: ${quality.score}/100');
/// ```
///
/// ## 支持平台
///
/// - Android
/// - iOS
/// - Windows
/// - Linux
/// - macOS
///
/// ## 主要类
///
/// - [NetworkDiagnostic]: 主要的网络诊断 API 类
/// - [NetworkBenchmark]: 性能基准测试类
/// - [BenchmarkRunner]: 通用基准测试运行器
///
/// ## 数据模型
///
/// - [NetworkConnectionInfo]: 网络连接信息
/// - [SpeedTestResult]: 网速测试结果
/// - [PingResult]: Ping 测试结果
/// - [DnsTestResult]: DNS 测试结果
/// - [NetworkQualityScore]: 网络质量评分
/// - [BenchmarkResult]: 基准测试结果
/// - [BenchmarkSuiteResult]: 基准测试套件结果
///
/// ## 枚举
///
/// - [NetworkType]: 网络类型
/// - [QualityLevel]: 网络质量等级
///
/// ## 异常
///
/// - [NetworkDiagnosticException]: 网络诊断异常
///
// ignore: unnecessary_library_name
library network_diagnostic_kit;

export 'src/network_diagnostic.dart';
export 'src/models/models.dart';
export 'src/enums/enums.dart';
export 'src/exceptions/network_diagnostic_exception.dart';
export 'src/benchmark/benchmark_runner.dart';
export 'src/benchmark/network_benchmark.dart';
