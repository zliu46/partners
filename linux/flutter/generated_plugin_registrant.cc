//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <desktop_webview_auth/desktop_webview_auth_plugin.h>
#include <flutter_timezone/flutter_timezone_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) desktop_webview_auth_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopWebviewAuthPlugin");
  desktop_webview_auth_plugin_register_with_registrar(desktop_webview_auth_registrar);
  g_autoptr(FlPluginRegistrar) flutter_timezone_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterTimezonePlugin");
  flutter_timezone_plugin_register_with_registrar(flutter_timezone_registrar);
}
