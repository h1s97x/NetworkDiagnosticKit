/// Ping 测试结果
///
/// 包含 Ping 测试的详细结果，包括发送/接收包数、延迟统计等。
///
/// ## 属性
///
/// - [host]: 目标主机地址
/// - [sent]: 发送的 Ping 包数量
/// - [received]: 成功接收的包数量
/// - [lost]: 丢失的包数量
/// - [packetLoss]: 丢包率百分比 (0-100)
/// - [minTime]: 最小延迟 (毫秒)
/// - [maxTime]: 最大延迟 (毫秒)
/// - [averageTime]: 平均延迟 (毫秒)
/// - [times]: 每次 Ping 的延迟列表 (毫秒)
///
/// ## 示例
///
/// ```dart
/// final result = await NetworkDiagnostic.ping(
///   host: 'www.baidu.com',
///   count: 10,
/// );
/// print('目标: ${result.host}');
/// print('发送: ${result.sent}, 接收: ${result.received}, 丢失: ${result.lost}');
/// print('延迟: 最小=${result.minTime}ms, 最大=${result.maxTime}ms, 平均=${result.averageTime}ms');
/// print('丢包率: ${result.packetLoss.toStringAsFixed(1)}%');
/// ```
class PingResult {
  PingResult({
    required this.host,
    required this.sent,
    required this.received,
    required this.lost,
    required this.packetLoss,
    required this.minTime,
    required this.maxTime,
    required this.averageTime,
    required this.times,
  });

  factory PingResult.fromJson(Map<String, dynamic> json) {
    return PingResult(
      host: json['host'] as String,
      sent: json['sent'] as int,
      received: json['received'] as int,
      lost: json['lost'] as int,
      packetLoss: (json['packetLoss'] as num).toDouble(),
      minTime: json['minTime'] as int,
      maxTime: json['maxTime'] as int,
      averageTime: json['averageTime'] as int,
      times: (json['times'] as List).cast<int>(),
    );
  }

  /// 目标主机
  final String host;

  /// 发送数量
  final int sent;

  /// 接收数量
  final int received;

  /// 丢包数量
  final int lost;

  /// 丢包率 (%)
  final double packetLoss;

  /// 最小延迟 (ms)
  final int minTime;

  /// 最大延迟 (ms)
  final int maxTime;

  /// 平均延迟 (ms)
  final int averageTime;

  /// 每次ping的结果
  final List<int> times;

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'sent': sent,
      'received': received,
      'lost': lost,
      'packetLoss': packetLoss,
      'minTime': minTime,
      'maxTime': maxTime,
      'averageTime': averageTime,
      'times': times,
    };
  }

  @override
  String toString() {
    return 'PingResult(host: $host, sent: $sent, received: $received, '
        'avg: $averageTime ms, loss: ${packetLoss.toStringAsFixed(1)}%)';
  }
}
