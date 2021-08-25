//
//  ImageDto.swift
//  Runner
//
//  Created by Mark on 23.08.2021.
//

import Foundation

struct ImageDto {
    let uuid: String
    let path: String
    let creationDate: Date
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
