//
//  Images.swift
//  Runner
//
//  Created by Mark on 20.08.2021.
//

import Foundation

class ImagesHandler: NSObject {
    private var eventSink: FlutterEventSink? = nil
}

extension ImagesHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}

extension ImagesHandler: ImageStorageObserverDelegate {
    func didAllImagesUpdated(_ images: [ImageDto]) {
        eventSink?(images.map { $0.toDictionary() })
    }
}

extension ImageDto {
    func toDictionary() -> [String: Any] {
        return [
            "uuid": self.uuid,
            "path": self.path,
            "creationTimestamp": Int(self.creationDate.timeIntervalSince1970)
        ]
    }
}
