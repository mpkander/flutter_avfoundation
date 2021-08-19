//
//  CameraView.swift
//  Runner
//
//  Created by Mark on 18.08.2021.
//

import Foundation
import UIKit
import AVFoundation

class CameraView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    
    var session: AVCaptureSession? {
        get { videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
