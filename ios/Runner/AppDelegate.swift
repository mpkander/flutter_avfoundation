import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let imagesHandler = ImagesHandler()
    let imageStorage = ImageStorage(observerDelegate: imagesHandler)
    
    weak var registrar = self.registrar(forPlugin: "flutter_platform_camera.cameraView")
    let factory = FLTCameraViewFactory(withRegistrar: registrar!, imageStorage: imageStorage)
    registrar!.register(factory, withId: "flutter_platform_camera.cameraView")
    
    let controller = window.rootViewController as! FlutterViewController
    FlutterEventChannel(name: "flutter_platform_camera.image_storage_observer", binaryMessenger: controller.binaryMessenger)
                .setStreamHandler(imagesHandler)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
