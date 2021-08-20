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
        
    init(withRegistrar registrar: FlutterPluginRegistrar) {
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
    /// Need to hold strong reference
    private var inProgressCaptureDelegates: [Int64: PhotoCaptureDelegate] = [:]
    
    private let cameraView: CameraView
    private let channel: FlutterMethodChannel

    init(withFrame frame: CGRect, withRegistrar registrar: FlutterPluginRegistrar, withId id: Int64, params: Any?) {
        self.cameraView = CameraView(frame: frame)
        self.channel = FlutterMethodChannel(name: "flutter_platform_camera.cameraView_\(id)", binaryMessenger: registrar.messenger())
        
        super.init()
        
        methodHandler()
        
        self.configureSession()
        self.captureSession.startRunning()
    }
    
    deinit {
        self.captureSession.stopRunning()
    }
    
    // MARK: - Session configuration
    private func configureSession() {
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

// MARK: - Method handler
extension FLTCameraView {
    private func methodHandler() {
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "capturePhoto":
                self.capturePhoto(result)
            case "flipCamera":
                self.flipCamera(result)
            default:
                return result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: Photo capture
    func capturePhoto(_ resultCallback: @escaping FlutterResult) {
        sessionQueue.async {
            let photoSettings = AVCapturePhotoSettings()
            
            let photoCaptureDelegate = PhotoCaptureDelegate(photoSettings) { photoData in
                resultCallback(FlutterStandardTypedData(bytes: photoData))
            } didFailure: {
                resultCallback(FlutterError(code: "capture_photo", message: "Photo capture failed", details: nil))
            } didCaptureFinish: {
                self.inProgressCaptureDelegates[photoSettings.uniqueID] = nil
            }
            
            self.capturePhotoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureDelegate)
            
            self.inProgressCaptureDelegates[photoSettings.uniqueID] = photoCaptureDelegate
        }
    }
    
    // MARK: Flip camera
    func flipCamera(_ resultCallback: @escaping FlutterResult) {
        sessionQueue.async {
            let actualVideoDevice = self.videoDeviceInput.device
            let actualCameraPosition = actualVideoDevice.position
            
            func createVideoDevice(by position: AVCaptureDevice.Position) -> AVCaptureDevice? {
                return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position).devices.first
            }
            
            let newVideoDevice: AVCaptureDevice?
            switch actualCameraPosition {
            case .unspecified, .front:
                newVideoDevice = createVideoDevice(by: .back)
            case .back:
                newVideoDevice = createVideoDevice(by: .front)
            @unknown default:
                newVideoDevice = createVideoDevice(by: .front)
            }
            
            self.captureSession.beginConfiguration()
            defer { self.captureSession.commitConfiguration() }
            
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: newVideoDevice!) else {
                return resultCallback(FlutterError(code: "flip_camera", message: "Getting video device error", details: nil))
            }
            
            self.captureSession.removeInput(self.videoDeviceInput)
            
            if self.captureSession.canAddInput(videoDeviceInput) {
                self.videoDeviceInput = videoDeviceInput
                self.captureSession.addInput(self.videoDeviceInput)
            }
            
            resultCallback(true)
        }
    }
}

// MARK: - FlutterPlatformView impl
extension FLTCameraView: FlutterPlatformView {
    func view() -> UIView {
        cameraView.backgroundColor = UIColor.black
        cameraView.session = captureSession
        cameraView.videoPreviewLayer.videoGravity = .resizeAspectFill

        return cameraView
    }
}

// MARK: - PhotoCaptureDelegate
class PhotoCaptureDelegate: NSObject {
    let photoSettings: AVCapturePhotoSettings
    private let didCapturePhoto: (_ imageData: Data) -> Void
    private let didFailure: () -> Void
    private let didCaptureFinish: () -> Void
    
    init(_ photoSettings: AVCapturePhotoSettings, didCapturePhoto: @escaping (_ imageData: Data) -> Void, didFailure: @escaping () -> Void, didCaptureFinish: @escaping () -> Void) {
        self.photoSettings = photoSettings
        self.didCapturePhoto = didCapturePhoto
        self.didFailure = didFailure
        self.didCaptureFinish = didCaptureFinish
    }
}

extension PhotoCaptureDelegate: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("An error occurred while processing photo: \(error)")
            return didFailure()
        }
        
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Cannot get file data representation")
            return didFailure()
        }
        
        didCapturePhoto(imageData)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        didCaptureFinish()
    }
}
