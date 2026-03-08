/// 网络诊断异常
class NetworkDiagnosticException implements Exception {
  NetworkDiagnosticException(
    this.message, [
    this.originalError,
    this.stackTrace,
  ]);
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  @override
  String toString() {
    if (originalError != null) {
      return 'NetworkDiagnosticException: $message\nOriginal error: $originalError';
    }
    return 'NetworkDiagnosticException: $message';
  }
}
