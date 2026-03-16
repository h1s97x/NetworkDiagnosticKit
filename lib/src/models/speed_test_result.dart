/// 网速测试结果
///
/// 包含网速测试的详细结果，包括下载/上传速度、延迟、抖动和丢包率。
///
/// ## 属性
///
/// - [downloadSpeed]: 下载速度 (Mbps)
/// - [uploadSpeed]: 上传速度 (Mbps)
/// - [ping]: 网络延迟 (毫秒)
/// - [jitter]: 抖动 (毫秒)，表示延迟的波动程度
/// - [packetLoss]: 丢包率百分比 (0-100)
/// - [timestamp]: 测试执行的时间
/// - [server]: 测试所使用的服务器地址
///
/// ## 示例
///
/// ```dart
/// final result = await NetworkDiagnostic.runSpeedTest();
/// print('下载速度: ${result.downloadSpeed.toStringAsFixed(2)} Mbps');
/// print('上传速度: ${result.uploadSpeed.toStringAsFixed(2)} Mbps');
/// print('延迟: ${result.ping} ms');
/// print('抖动: ${result.jitter.toStringAsFixed(2)} ms');
/// print('丢包率: ${result.packetLoss.toStringAsFixed(2)}%');
/// print('测试服务器: ${result.server}');
/// ```
class SpeedTestResult {
  SpeedTestResult({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
    required this.jitter,
    required this.packetLoss,
    required this.timestamp,
    this.server,
  });

  factory SpeedTestResult.fromJson(Map<String, dynamic> json) {
    return SpeedTestResult(
      downloadSpeed: (json['downloadSpeed'] as num).toDouble(),
      uploadSpeed: (json['uploadSpeed'] as num).toDouble(),
      ping: json['ping'] as int,
      jitter: (json['jitter'] as num).toDouble(),
      packetLoss: (json['packetLoss'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      server: json['server'] as String?,
    );
  }

  /// 下载速度 (Mbps)
  final double downloadSpeed;

  /// 上传速度 (Mbps)
  final double uploadSpeed;

  /// 延迟 (ms)
  final int ping;

  /// 抖动 (ms)
  final double jitter;

  /// 丢包率 (%)
  final double packetLoss;

  /// 测试时间
  final DateTime timestamp;

  /// 测试服务器
  final String? server;

  Map<String, dynamic> toJson() {
    return {
      'downloadSpeed': downloadSpeed,
      'uploadSpeed': uploadSpeed,
      'ping': ping,
      'jitter': jitter,
      'packetLoss': packetLoss,
      'timestamp': timestamp.toIso8601String(),
      'server': server,
    };
  }

  @override
  String toString() {
    return 'SpeedTestResult(download: ${downloadSpeed.toStringAsFixed(2)} Mbps, '
        'upload: ${uploadSpeed.toStringAsFixed(2)} Mbps, ping: $ping ms)';
  }
}
