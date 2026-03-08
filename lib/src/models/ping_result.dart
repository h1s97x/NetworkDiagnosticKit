/// Ping测试结果
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
