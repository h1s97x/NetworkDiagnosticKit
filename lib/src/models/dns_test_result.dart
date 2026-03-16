/// DNS 测试结果
///
/// 包含 DNS 解析测试的详细结果，包括解析成功/失败、响应时间和解析的 IP 地址。
///
/// ## 属性
///
/// - [domain]: 被解析的域名
/// - [dnsServer]: 使用的 DNS 服务器地址
/// - [resolvedIp]: 解析得到的 IP 地址（成功时）
/// - [responseTime]: DNS 响应时间 (毫秒)
/// - [isSuccess]: 解析是否成功
/// - [errorMessage]: 错误信息（失败时）
///
/// ## 示例
///
/// ```dart
/// final results = await NetworkDiagnostic.testDns(
///   domain: 'www.google.com',
///   dnsServers: ['8.8.8.8', '114.114.114.114'],
/// );
/// for (var result in results) {
///   print('DNS ${result.dnsServer}:');
///   print('  响应时间: ${result.responseTime}ms');
///   if (result.isSuccess) {
///     print('  解析 IP: ${result.resolvedIp}');
///   } else {
///     print('  错误: ${result.errorMessage}');
///   }
/// }
/// ```
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
