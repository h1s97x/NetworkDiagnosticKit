/// 网络类型
enum NetworkType {
  /// WiFi
  wifi,

  /// 移动数据
  mobile,

  /// 以太网
  ethernet,

  /// 无网络
  none,

  /// 未知
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
