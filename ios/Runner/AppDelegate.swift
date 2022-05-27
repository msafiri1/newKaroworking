import UIKit
import Flutter
import flutter_downloader
import flutter_uploader
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 12.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      GeneratedPluginRegistrant.register(with: self)
    SwiftFlutterUploaderPlugin.registerPlugins = registerUploaderPlugin
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerDownloaderPlugin)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func registerDownloaderPlugin(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}

func registerUploaderPlugin(registry: FlutterPluginRegistry) {
    GeneratedPluginRegistrant.register(with: registry)
}
