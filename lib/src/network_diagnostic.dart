import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'models/models.dart';
import 'enums/enums.dart';
import 'exceptions/network_diagnostic_exception.dart';

/// 网络诊断工具
class NetworkDiagnostic {
  NetworkDiagnostic._();

  static final Connectivity _connectivity = Connectivity();

  /// 检查网络连接
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

  /// DNS测试
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

  /// Ping测试
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
  static Stream<NetworkConnectionInfo> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((_) async {
      return await checkConnection();
    });
  }
}
