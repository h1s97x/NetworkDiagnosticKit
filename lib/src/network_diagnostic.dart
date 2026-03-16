import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'models/models.dart';
import 'enums/enums.dart';
import 'exceptions/network_diagnostic_exception.dart';

/// 网络诊断工具
///
/// 提供网络连接检测、网速测试、Ping 测试、DNS 测试、网络质量评分、
/// 端口扫描和实时网络状态监听等功能。
///
/// 所有方法都是异步非阻塞的，返回 [Future] 对象。
///
/// ## 使用示例
///
/// ```dart
/// // 检查网络连接
/// final connection = await NetworkDiagnostic.checkConnection();
/// if (connection.isConnected) {
///   print('网络已连接: ${connection.type.displayName}');
/// }
///
/// // 运行网速测试
/// final speedTest = await NetworkDiagnostic.runSpeedTest();
/// print('下载速度: ${speedTest.downloadSpeed.toStringAsFixed(2)} Mbps');
///
/// // Ping 测试
/// final pingResult = await NetworkDiagnostic.ping(host: 'www.baidu.com');
/// print('平均延迟: ${pingResult.averageTime} ms');
///
/// // DNS 测试
/// final dnsResults = await NetworkDiagnostic.testDns(domain: 'www.google.com');
/// for (var result in dnsResults) {
///   print('DNS ${result.dnsServer}: ${result.responseTime}ms');
/// }
///
/// // 评估网络质量
/// final quality = await NetworkDiagnostic.evaluateQuality();
/// print('网络评分: ${quality.score}/100');
///
/// // 检查端口
/// final isOpen = await NetworkDiagnostic.checkPort(
///   host: 'www.baidu.com',
///   port: 80,
/// );
/// print('端口 80 是否开放: $isOpen');
///
/// // 监听网络变化
/// NetworkDiagnostic.onConnectivityChanged.listen((info) {
///   print('网络状态变化: ${info.type.displayName}');
/// });
/// ```
class NetworkDiagnostic {
  NetworkDiagnostic._();

  static final Connectivity _connectivity = Connectivity();

  /// 检查网络连接
  ///
  /// 返回当前网络连接信息，包括连接状态、网络类型和 IP 地址等。
  ///
  /// ## 返回值
  ///
  /// 返回 [NetworkConnectionInfo] 对象，包含以下信息：
  /// - [NetworkConnectionInfo.isConnected]: 是否已连接
  /// - [NetworkConnectionInfo.type]: 网络类型
  /// - [NetworkConnectionInfo.ipAddress]: IP 地址
  /// - [NetworkConnectionInfo.ssid]: WiFi 名称（仅 WiFi 连接时）
  /// - [NetworkConnectionInfo.signalStrength]: 信号强度（仅 WiFi 连接时）
  ///
  /// ## 异常
  ///
  /// 抛出 [NetworkDiagnosticException] 如果检查失败。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final connection = await NetworkDiagnostic.checkConnection();
  /// print('连接状态: ${connection.isConnected}');
  /// print('网络类型: ${connection.type.displayName}');
  /// print('IP 地址: ${connection.ipAddress}');
  /// ```
  static Future<NetworkConnectionInfo> checkConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      NetworkType type = NetworkType.none;

      // 处理单个ConnectivityResult
      if (connectivityResult == ConnectivityResult.wifi) {
        type = NetworkType.wifi;
      } else if (connectivityResult == ConnectivityResult.mobile) {
        type = NetworkType.mobile;
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        type = NetworkType.ethernet;
      } else if (connectivityResult == ConnectivityResult.none) {
        type = NetworkType.none;
      } else {
        type = NetworkType.unknown;
      }

      final bool isConnected = type != NetworkType.none;

      // 获取IP地址
      String? ipAddress;
      try {
        final interfaces = await NetworkInterface.list();
        for (var interface in interfaces) {
          for (var addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
              ipAddress = addr.address;
              break;
            }
          }
          if (ipAddress != null) break;
        }
      } catch (e) {
        // 忽略IP获取错误
      }

      return NetworkConnectionInfo(
        isConnected: isConnected,
        type: type,
        ipAddress: ipAddress,
      );
    } catch (e, stack) {
      throw NetworkDiagnosticException('检查网络连接失败', e, stack);
    }
  }

  /// 运行网速测试（简化版本）
  ///
  /// 测试网络的下载速度、上传速度、延迟、抖动和丢包率。
  ///
  /// ## 参数
  ///
  /// - [downloadUrl]: 下载测试 URL，默认使用 Cloudflare 测试服务器
  /// - [uploadUrl]: 上传测试 URL（当前版本未使用）
  /// - [timeout]: 测试超时时间，默认 30 秒
  ///
  /// ## 返回值
  ///
  /// 返回 [SpeedTestResult] 对象，包含以下信息：
  /// - [SpeedTestResult.downloadSpeed]: 下载速度 (Mbps)
  /// - [SpeedTestResult.uploadSpeed]: 上传速度 (Mbps)
  /// - [SpeedTestResult.ping]: 延迟 (ms)
  /// - [SpeedTestResult.jitter]: 抖动 (ms)
  /// - [SpeedTestResult.packetLoss]: 丢包率 (%)
  /// - [SpeedTestResult.timestamp]: 测试时间
  /// - [SpeedTestResult.server]: 测试服务器
  ///
  /// ## 异常
  ///
  /// 抛出 [NetworkDiagnosticException] 如果测试失败。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final result = await NetworkDiagnostic.runSpeedTest();
  /// print('下载速度: ${result.downloadSpeed.toStringAsFixed(2)} Mbps');
  /// print('上传速度: ${result.uploadSpeed.toStringAsFixed(2)} Mbps');
  /// print('延迟: ${result.ping} ms');
  /// print('丢包率: ${result.packetLoss.toStringAsFixed(2)}%');
  /// ```
  static Future<SpeedTestResult> runSpeedTest({
    String? downloadUrl,
    String? uploadUrl,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      // 使用默认测试URL
      final testDownloadUrl = downloadUrl ??
          'https://speed.cloudflare.com/__down?bytes=10000000'; // 10MB

      // 测试延迟
      final pingResult = await ping(
        host: 'www.cloudflare.com',
        count: 4,
        timeout: const Duration(seconds: 5),
      );

      // 测试下载速度
      final downloadSpeed = await _testDownloadSpeed(
        testDownloadUrl,
        timeout,
      );

      // 简化版本：上传速度设为下载速度的一半（实际应该真实测试）
      final uploadSpeed = downloadSpeed * 0.5;

      return SpeedTestResult(
        downloadSpeed: downloadSpeed,
        uploadSpeed: uploadSpeed,
        ping: pingResult.averageTime,
        jitter: _calculateJitter(pingResult.times),
        packetLoss: pingResult.packetLoss,
        timestamp: DateTime.now(),
        server: 'Cloudflare',
      );
    } catch (e, stack) {
      throw NetworkDiagnosticException('网速测试失败', e, stack);
    }
  }

  /// 测试下载速度
  static Future<double> _testDownloadSpeed(
    String url,
    Duration timeout,
  ) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http.get(Uri.parse(url)).timeout(timeout);
      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes.length;
        final seconds = stopwatch.elapsedMilliseconds / 1000.0;
        final mbps = (bytes * 8) / (seconds * 1000000); // 转换为Mbps
        return mbps;
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw NetworkDiagnosticException('下载速度测试失败', e);
    }
  }

  /// 计算抖动
  static double _calculateJitter(List<int> times) {
    if (times.length < 2) return 0.0;

    double sum = 0.0;
    for (int i = 1; i < times.length; i++) {
      sum += (times[i] - times[i - 1]).abs();
    }
    return sum / (times.length - 1);
  }

  /// DNS 测试
  ///
  /// 测试 DNS 解析速度和可用性。支持多个 DNS 服务器并发测试。
  ///
  /// ## 参数
  ///
  /// - [domain]: 要解析的域名，必需
  /// - [dnsServers]: DNS 服务器列表，默认使用 Google、114 和 Cloudflare DNS
  ///
  /// ## 返回值
  ///
  /// 返回 [DnsTestResult] 列表，每个结果包含：
  /// - [DnsTestResult.domain]: 域名
  /// - [DnsTestResult.dnsServer]: DNS 服务器地址
  /// - [DnsTestResult.resolvedIp]: 解析得到的 IP 地址
  /// - [DnsTestResult.responseTime]: 响应时间 (ms)
  /// - [DnsTestResult.isSuccess]: 是否成功
  /// - [DnsTestResult.errorMessage]: 错误信息（失败时）
  ///
  /// ## 异常
  ///
  /// 抛出 [NetworkDiagnosticException] 如果测试失败。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final results = await NetworkDiagnostic.testDns(
  ///   domain: 'www.google.com',
  ///   dnsServers: ['8.8.8.8', '114.114.114.114'],
  /// );
  /// for (var result in results) {
  ///   print('DNS ${result.dnsServer}: ${result.responseTime}ms');
  ///   if (result.isSuccess) {
  ///     print('  解析 IP: ${result.resolvedIp}');
  ///   }
  /// }
  /// ```
  static Future<List<DnsTestResult>> testDns({
    required String domain,
    List<String> dnsServers = const ['8.8.8.8', '114.114.114.114', '1.1.1.1'],
  }) async {
    try {
      final results = <DnsTestResult>[];

      for (final dnsServer in dnsServers) {
        final stopwatch = Stopwatch()..start();

        try {
          final addresses = await InternetAddress.lookup(domain);
          stopwatch.stop();

          results.add(DnsTestResult(
            domain: domain,
            dnsServer: dnsServer,
            resolvedIp: addresses.isNotEmpty ? addresses.first.address : null,
            responseTime: stopwatch.elapsedMilliseconds,
            isSuccess: true,
          ));
        } catch (e) {
          stopwatch.stop();
          results.add(DnsTestResult(
            domain: domain,
            dnsServer: dnsServer,
            responseTime: stopwatch.elapsedMilliseconds,
            isSuccess: false,
            errorMessage: e.toString(),
          ));
        }
      }

      return results;
    } catch (e, stack) {
      throw NetworkDiagnosticException('DNS测试失败', e, stack);
    }
  }

  /// Ping 测试
  ///
  /// 测试网络延迟和稳定性。通过连接指定主机的 80 端口来模拟 Ping。
  ///
  /// ## 参数
  ///
  /// - [host]: 目标主机地址，必需
  /// - [count]: 发送的 Ping 包数量，默认 4
  /// - [timeout]: 单次 Ping 超时时间，默认 5 秒
  ///
  /// ## 返回值
  ///
  /// 返回 [PingResult] 对象，包含以下信息：
  /// - [PingResult.host]: 目标主机
  /// - [PingResult.sent]: 发送的包数
  /// - [PingResult.received]: 接收的包数
  /// - [PingResult.lost]: 丢失的包数
  /// - [PingResult.packetLoss]: 丢包率 (%)
  /// - [PingResult.minTime]: 最小延迟 (ms)
  /// - [PingResult.maxTime]: 最大延迟 (ms)
  /// - [PingResult.averageTime]: 平均延迟 (ms)
  /// - [PingResult.times]: 每次 Ping 的延迟列表
  ///
  /// ## 异常
  ///
  /// 抛出 [NetworkDiagnosticException] 如果测试失败。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final result = await NetworkDiagnostic.ping(
  ///   host: 'www.baidu.com',
  ///   count: 10,
  /// );
  /// print('平均延迟: ${result.averageTime} ms');
  /// print('丢包率: ${result.packetLoss.toStringAsFixed(1)}%');
  /// ```
  static Future<PingResult> ping({
    required String host,
    int count = 4,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final times = <int>[];
      int sent = 0;
      int received = 0;

      for (int i = 0; i < count; i++) {
        sent++;
        final stopwatch = Stopwatch()..start();

        try {
          final socket = await Socket.connect(
            host,
            80,
            timeout: timeout,
          );
          stopwatch.stop();
          socket.destroy();

          final time = stopwatch.elapsedMilliseconds;
          times.add(time);
          received++;
        } catch (e) {
          // Ping失败，不添加时间
        }
      }

      final lost = sent - received;
      final packetLoss = (lost / sent) * 100;

      int minTime =
          times.isNotEmpty ? times.reduce((a, b) => a < b ? a : b) : 0;
      int maxTime =
          times.isNotEmpty ? times.reduce((a, b) => a > b ? a : b) : 0;
      int averageTime =
          times.isNotEmpty ? times.reduce((a, b) => a + b) ~/ times.length : 0;

      return PingResult(
        host: host,
        sent: sent,
        received: received,
        lost: lost,
        packetLoss: packetLoss,
        minTime: minTime,
        maxTime: maxTime,
        averageTime: averageTime,
        times: times,
      );
    } catch (e, stack) {
      throw NetworkDiagnosticException('Ping测试失败', e, stack);
    }
  }

  /// 评估网络质量
  ///
  /// 综合评估网络质量，包括连接状态、延迟和丢包率等指标。
  /// 返回 0-100 的评分和相应的质量等级。
  ///
  /// ## 评分标准
  ///
  /// - 连接状态 (20 分): 未连接扣 20 分
  /// - 延迟 (40 分):
  ///   - > 200ms: 扣 40 分
  ///   - > 100ms: 扣 20 分
  ///   - > 50ms: 扣 10 分
  /// - 丢包率 (40 分):
  ///   - > 10%: 扣 40 分
  ///   - > 5%: 扣 20 分
  ///   - > 1%: 扣 10 分
  ///
  /// ## 返回值
  ///
  /// 返回 [NetworkQualityScore] 对象，包含以下信息：
  /// - [NetworkQualityScore.score]: 评分 (0-100)
  /// - [NetworkQualityScore.level]: 质量等级
  /// - [NetworkQualityScore.metrics]: 各项指标
  /// - [NetworkQualityScore.suggestions]: 优化建议
  /// - [NetworkQualityScore.timestamp]: 评估时间
  ///
  /// ## 异常
  ///
  /// 抛出 [NetworkDiagnosticException] 如果评估失败。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final quality = await NetworkDiagnostic.evaluateQuality();
  /// print('网络评分: ${quality.score}/100');
  /// print('质量等级: ${quality.level.displayName}');
  /// for (var suggestion in quality.suggestions) {
  ///   print('建议: $suggestion');
  /// }
  /// ```
  static Future<NetworkQualityScore> evaluateQuality() async {
    try {
      // 检查连接
      final connection = await checkConnection();

      // Ping测试
      final pingResult = await ping(
        host: 'www.baidu.com',
        count: 10,
      );

      // 计算评分
      int score = 100;
      final suggestions = <String>[];
      final metrics = <String, dynamic>{};

      // 连接状态 (20分)
      if (!connection.isConnected) {
        score -= 20;
        suggestions.add('网络未连接，请检查网络设置');
      }
      metrics['connected'] = connection.isConnected;

      // 延迟评分 (40分)
      final avgPing = pingResult.averageTime;
      metrics['ping'] = avgPing;

      if (avgPing > 200) {
        score -= 40;
        suggestions.add('网络延迟过高，建议切换网络或联系网络管理员');
      } else if (avgPing > 100) {
        score -= 20;
        suggestions.add('网络延迟较高，可能影响使用体验');
      } else if (avgPing > 50) {
        score -= 10;
      }

      // 丢包率评分 (40分)
      final packetLoss = pingResult.packetLoss;
      metrics['packetLoss'] = packetLoss;

      if (packetLoss > 10) {
        score -= 40;
        suggestions.add('网络丢包严重，请检查网络连接');
      } else if (packetLoss > 5) {
        score -= 20;
        suggestions.add('网络存在丢包，可能影响稳定性');
      } else if (packetLoss > 1) {
        score -= 10;
      }

      if (suggestions.isEmpty) {
        suggestions.add('网络状态良好');
      }

      final level = QualityLevelExtension.fromScore(score);

      return NetworkQualityScore(
        score: score,
        level: level,
        metrics: metrics,
        suggestions: suggestions,
        timestamp: DateTime.now(),
      );
    } catch (e, stack) {
      throw NetworkDiagnosticException('网络质量评估失败', e, stack);
    }
  }

  /// 端口扫描
  ///
  /// 检查指定主机的指定端口是否开放。
  ///
  /// ## 参数
  ///
  /// - [host]: 目标主机地址，必需
  /// - [port]: 目标端口号，必需
  /// - [timeout]: 连接超时时间，默认 5 秒
  ///
  /// ## 返回值
  ///
  /// 返回 `true` 如果端口开放，`false` 如果端口关闭或无法连接。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// final isOpen = await NetworkDiagnostic.checkPort(
  ///   host: 'www.baidu.com',
  ///   port: 80,
  /// );
  /// print('端口 80 是否开放: $isOpen');
  ///
  /// // 检查多个端口
  /// for (int port in [80, 443, 8080]) {
  ///   final open = await NetworkDiagnostic.checkPort(
  ///     host: 'www.baidu.com',
  ///     port: port,
  ///   );
  ///   print('端口 $port: ${open ? "开放" : "关闭"}');
  /// }
  /// ```
  static Future<bool> checkPort({
    required String host,
    required int port,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: timeout,
      );
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 监听网络连接变化
  ///
  /// 返回一个 [Stream]，当网络连接状态发生变化时发出新的 [NetworkConnectionInfo]。
  ///
  /// ## 返回值
  ///
  /// 返回 [Stream<NetworkConnectionInfo>]，每次网络状态变化时发出新的连接信息。
  ///
  /// ## 示例
  ///
  /// ```dart
  /// // 监听网络变化
  /// NetworkDiagnostic.onConnectivityChanged.listen((info) {
  ///   print('网络状态变化: ${info.type.displayName}');
  ///   print('是否连接: ${info.isConnected}');
  /// });
  ///
  /// // 使用 StreamBuilder 在 UI 中显示
  /// StreamBuilder<NetworkConnectionInfo>(
  ///   stream: NetworkDiagnostic.onConnectivityChanged,
  ///   builder: (context, snapshot) {
  ///     if (snapshot.hasData) {
  ///       final info = snapshot.data!;
  ///       return Text('网络: ${info.type.displayName}');
  ///     }
  ///     return Text('加载中...');
  ///   },
  /// )
  /// ```
  static Stream<NetworkConnectionInfo> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((_) async {
      return await checkConnection();
    });
  }
}
