//
//  Images.swift
//  Runner
//
//  Created by Mark on 20.08.2021.
//

import Foundation

class FLTImagesHandler: NSObject {
    private var eventSink: FlutterEventSink? = nil
    private let methodChannel: FlutterMethodChannel
    weak var imageStorage: ImageStorageProtocol?
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: "flutter_platform_camera.image_storage", binaryMessenger: binaryMessenger)
        
        super.init()
            
        methodChannel.setMethodCallHandler(methodCallHandler)
    }
    
    // MARK: - Method handling
    
    private func methodCallHandler(call: FlutterMethodCall, result: FlutterResult) {
        switch call.method {
        case "getAllImages":
            methodCallHandlerGetAllImages(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func methodCallHandlerGetAllImages(result: FlutterResult) {
        guard let images = try? imageStorage?.getAllImages() else {
            return result(FlutterError(code: "get_all_images", message: "Cannot fetch images from storage", details: nil))
        }
        
        result(images.map { $0.toDictionary() })
    }
}

extension FLTImagesHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}

extension FLTImagesHandler: ImageStorageObserverDelegate {
    func didAllImagesUpdated(_ images: [ImageDto]) {
        eventSink?(images.map { $0.toDictionary() })
    }
}
