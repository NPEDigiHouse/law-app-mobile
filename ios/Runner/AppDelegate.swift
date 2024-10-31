import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  // Create variable textField
  var textField = UITextField()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Call screenshot prevent function
    secureScreen()

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let securityChannel = FlutterMethodChannel(name: "secureScreenshotChannel", binaryMessenger: controller.binaryMessenger)

    securityChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "secureiOS" {
        textField.isSecureTextEntry = true
      } else if call.method == "unSecureiOS" {
        textField.isSecureTextEntry = false
      }
    })

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Create screenshot prevent function
  private func secureScreen() {
    if (!window.subviews.contains(textField)) {
      window.addSubview(textField)
      textField.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
      textField.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
      window.layer.superlayer?.addSublayer(textField.layer)

      if #available(iOS 17.0, *) {
        textField.layer.sublayers?.last?.addSublayer(window.layer)
      } else {
        textField.layer.sublayers?.first?.addSublayer(window.layer)
      }
    }
  }
}
