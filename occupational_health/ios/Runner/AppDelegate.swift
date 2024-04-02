import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // YOUR GOOGLE MAP API KEY
    GMSServices.provideAPIKey("YOUR API KEY")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
