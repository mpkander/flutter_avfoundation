//
//  Camera.swift
//  Runner
//
//  Created by Mark on 17.08.2021.
//

import Foundation
import Flutter
import UIKit
import AVFoundation

class FLTCameraViewFactory: NSObject, FlutterPlatformViewFactory {
    let registrar: FlutterPluginRegistrar
        
    public init(withRegistrar registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLTCameraView(withFrame: frame, withRegistrar: registrar, withId: viewId, params: args)
    }
}

class FLTCameraView: NSObject {
    private let sessionQueue = DispatchQueue(label: "session queue")
    private let captureSession = AVCaptureSession()
    private let capturePhotoOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput!
    
    private let cameraView: CameraView
    private let channel: FlutterMethodChannel

    init(withFrame frame: CGRect, withRegistrar registrar: FlutterPluginRegistrar, withId id: Int64, params: Any?) {
        self.cameraView = CameraView(frame: frame)
        self.channel = FlutterMethodChannel(name: "flutter_platform_camera.cameraView_\(id)", binaryMessenger: registrar.messenger())
        
        super.init()
        
        sessionQueue.async {
            self.configureSession()
            self.captureSession.startRunning()
        }
    }
    
    deinit {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    func configureSession() {
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        
        self.videoDeviceInput = videoDeviceInput
        captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(capturePhotoOutput) else { return }
        captureSession.addOutput(capturePhotoOutput)
    }
}

extension FLTCameraView: FlutterPlatformView {
    func view() -> UIView {
        cameraView.backgroundColor = UIColor.black
        cameraView.session = captureSession
        cameraView.videoPreviewLayer.videoGravity = .resizeAspectFill

        return cameraView
    }
}
