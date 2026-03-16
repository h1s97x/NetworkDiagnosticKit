/// 网络类型
///
/// 表示当前网络连接的类型。
///
/// ## 类型说明
///
/// - [wifi]: WiFi 连接
/// - [mobile]: 移动数据连接（4G/5G/3G 等）
/// - [ethernet]: 以太网连接
/// - [none]: 无网络连接
/// - [unknown]: 未知网络类型
///
/// ## 使用示例
///
/// ```dart
/// final connection = await NetworkDiagnostic.checkConnection();
/// if (connection.type == NetworkType.wifi) {
///   print('已连接到 WiFi: ${connection.ssid}');
/// } else if (connection.type == NetworkType.mobile) {
///   print('已连接到移动数据');
/// } else if (connection.type == NetworkType.none) {
///   print('未连接到网络');
/// }
/// ```
enum NetworkType {
  /// WiFi 连接
  wifi,

  /// 移动数据连接
  mobile,

  /// 以太网连接
  ethernet,

  /// 无网络连接
  none,

  /// 未知网络类型
  unknown,
}

extension NetworkTypeExtension on NetworkType {
  String get displayName {
    switch (this) {
      case NetworkType.wifi:
        return 'WiFi';
      case NetworkType.mobile:
        return '移动数据';
      case NetworkType.ethernet:
        return '以太网';
      case NetworkType.none:
        return '无网络';
      case NetworkType.unknown:
        return '未知';
    }
  }
}
