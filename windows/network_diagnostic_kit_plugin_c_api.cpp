#include "include/network_diagnostic_kit/network_diagnostic_kit_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "network_diagnostic_kit_plugin.h"

void NetworkDiagnosticKitPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  network_diagnostic_kit::NetworkDiagnosticKitPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
