import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let mapsAPIkey = Bundle.main.infoDictionary?["GoogleMapsAPIKey"] as? String {
      GMSServices.provideAPIKey(mapsApiKey)
             print("Google Maps API Key Loaded: \(mapsApiKey)") // For debugging
         } else {
             print("Error: Google Maps API Key not found in Info.plist")
         }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
