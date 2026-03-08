/// 网速测试结果
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
