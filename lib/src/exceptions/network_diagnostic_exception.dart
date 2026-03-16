/// 网络诊断异常
///
/// 网络诊断操作失败时抛出的异常。包含错误信息、原始错误和堆栈跟踪。
///
/// ## 属性
///
/// - [message]: 错误描述信息
/// - [originalError]: 原始错误对象
/// - [stackTrace]: 堆栈跟踪信息
///
/// ## 使用示例
///
/// ```dart
/// try {
///   final result = await NetworkDiagnostic.checkConnection();
/// } on NetworkDiagnosticException catch (e) {
///   print('错误: ${e.message}');
///   if (e.originalError != null) {
///     print('原始错误: ${e.originalError}');
///   }
/// }
/// ```
class NetworkDiagnosticException implements Exception {
  /// 创建网络诊断异常
  ///
  /// ## 参数
  ///
  /// - [message]: 错误信息，必需
  /// - [originalError]: 原始错误对象，可选
  /// - [stackTrace]: 堆栈跟踪，可选
  NetworkDiagnosticException(
    this.message, [
    this.originalError,
    this.stackTrace,
  ]);

  /// 错误信息
  final String message;

  /// 原始错误对象
  final dynamic originalError;

  /// 堆栈跟踪
  final StackTrace? stackTrace;

  @override
  String toString() {
    if (originalError != null) {
      return 'NetworkDiagnosticException: $message\nOriginal error: $originalError';
    }
    return 'NetworkDiagnosticException: $message';
  }
}
