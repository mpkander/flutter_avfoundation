import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    weak var registrar = self.registrar(forPlugin: "flutter_platform_camera.cameraView1")
    
    let factory = FLTCameraViewFactory(withRegistrar: registrar!)
    self.registrar(forPlugin: "flutter_platform_camera.cameraView")!.register(
                factory,
                withId: "flutter_platform_camera.cameraView")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
