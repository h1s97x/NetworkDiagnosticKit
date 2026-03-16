import '../enums/network_type.dart';

/// 网络连接信息
///
/// 包含当前网络连接的详细信息，包括连接状态、网络类型、IP 地址等。
///
/// ## 属性
///
/// - [isConnected]: 是否已连接到网络
/// - [type]: 网络类型（WiFi、移动网络、以太网等）
/// - [ssid]: WiFi 名称（仅 WiFi 连接时有效）
/// - [signalStrength]: 信号强度百分比 (0-100)
/// - [ipAddress]: IPv4 地址
/// - [gateway]: 网关地址
/// - [ipv6Address]: IPv6 地址
/// - [macAddress]: MAC 地址
///
/// ## 示例
///
/// ```dart
/// final connection = await NetworkDiagnostic.checkConnection();
/// if (connection.isConnected) {
///   print('网络类型: ${connection.type.displayName}');
///   print('IP 地址: ${connection.ipAddress}');
///   if (connection.type == NetworkType.wifi) {
///     print('WiFi 名称: ${connection.ssid}');
///     print('信号强度: ${connection.signalStrength}%');
///   }
/// }
/// ```
class NetworkConnectionInfo {
  NetworkConnectionInfo({
    required this.isConnected,
    required this.type,
    this.ssid,
    this.signalStrength,
    this.ipAddress,
    this.gateway,
    this.ipv6Address,
    this.macAddress,
  });

  factory NetworkConnectionInfo.fromJson(Map<String, dynamic> json) {
    return NetworkConnectionInfo(
      isConnected: json['isConnected'] as bool,
      type: NetworkType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NetworkType.unknown,
      ),
      ssid: json['ssid'] as String?,
      signalStrength: json['signalStrength'] as int?,
      ipAddress: json['ipAddress'] as String?,
      gateway: json['gateway'] as String?,
      ipv6Address: json['ipv6Address'] as String?,
      macAddress: json['macAddress'] as String?,
    );
  }

  /// 是否已连接
  final bool isConnected;

  /// 网络类型
  final NetworkType type;

  /// WiFi名称（SSID）
  final String? ssid;

  /// 信号强度 (0-100)
  final int? signalStrength;

  /// IP地址
  final String? ipAddress;

  /// 网关地址
  final String? gateway;

  /// IPv6地址
  final String? ipv6Address;

  /// MAC地址
  final String? macAddress;

  Map<String, dynamic> toJson() {
    return {
      'isConnected': isConnected,
      'type': type.name,
      'ssid': ssid,
      'signalStrength': signalStrength,
      'ipAddress': ipAddress,
      'gateway': gateway,
      'ipv6Address': ipv6Address,
      'macAddress': macAddress,
    };
  }

  @override
  String toString() {
    return 'NetworkConnectionInfo(isConnected: $isConnected, type: $type, '
        'ssid: $ssid, ip: $ipAddress)';
  }
}
