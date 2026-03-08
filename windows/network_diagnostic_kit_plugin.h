#ifndef FLUTTER_PLUGIN_NETWORK_DIAGNOSTIC_KIT_PLUGIN_H_
#define FLUTTER_PLUGIN_NETWORK_DIAGNOSTIC_KIT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace network_diagnostic_kit {

class NetworkDiagnosticKitPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NetworkDiagnosticKitPlugin();

  virtual ~NetworkDiagnosticKitPlugin();

  // Disallow copy and assign.
  NetworkDiagnosticKitPlugin(const NetworkDiagnosticKitPlugin&) = delete;
  NetworkDiagnosticKitPlugin& operator=(const NetworkDiagnosticKitPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace network_diagnostic_kit

#endif  // FLUTTER_PLUGIN_NETWORK_DIAGNOSTIC_KIT_PLUGIN_H_
