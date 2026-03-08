/// DNS测试结果
class DnsTestResult {
  DnsTestResult({
    required this.domain,
    required this.dnsServer,
    required this.responseTime,
    required this.isSuccess,
    this.resolvedIp,
    this.errorMessage,
  });

  factory DnsTestResult.fromJson(Map<String, dynamic> json) {
    return DnsTestResult(
      domain: json['domain'] as String,
      dnsServer: json['dnsServer'] as String,
      resolvedIp: json['resolvedIp'] as String?,
      responseTime: json['responseTime'] as int,
      isSuccess: json['isSuccess'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  /// 域名
  final String domain;

  /// DNS服务器
  final String dnsServer;

  /// 解析的IP地址
  final String? resolvedIp;

  /// 响应时间 (ms)
  final int responseTime;

  /// 是否成功
  final bool isSuccess;

  /// 错误信息
  final String? errorMessage;

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'dnsServer': dnsServer,
      'resolvedIp': resolvedIp,
      'responseTime': responseTime,
      'isSuccess': isSuccess,
      'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return 'DnsTestResult(domain: $domain, server: $dnsServer, '
        'ip: $resolvedIp, time: $responseTime ms, success: $isSuccess)';
  }
}
