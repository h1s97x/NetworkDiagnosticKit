import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'network_diagnostic_kit_method_channel.dart';

abstract class NetworkDiagnosticKitPlatform extends PlatformInterface {
  /// Constructs a NetworkDiagnosticKitPlatform.
  NetworkDiagnosticKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static NetworkDiagnosticKitPlatform _instance =
      MethodChannelNetworkDiagnosticKit();

  /// The default instance of [NetworkDiagnosticKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelNetworkDiagnosticKit].
  static NetworkDiagnosticKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NetworkDiagnosticKitPlatform] when
  /// they register themselves.
  static set instance(NetworkDiagnosticKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
