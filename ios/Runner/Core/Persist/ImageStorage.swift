//
//  ImageStorage.swift
//  Runner
//
//  Created by Mark on 23.08.2021.
//

import Foundation

protocol ImageStorageProtocol: AnyObject {
    func getAllImages() throws -> [ImageDto]
    func save(image: Data) throws
    func delete(byIds ids: [String]) throws
}

protocol ImageStorageObserverDelegate {
    func didAllImagesUpdated(_ images: [ImageDto])
}

enum ImageStorageError: Error {
    case whileCreatingImageInstance
    case whileCreatingFilePath
    case whileWritingData
    case whileReadingData
}

class ImageStorage {
    private let observerDelegate: ImageStorageObserverDelegate
    
    init(observerDelegate: ImageStorageObserverDelegate) {
        self.observerDelegate = observerDelegate
    }
    
    private func createFilePath(with directoryURL: URL? = try? FileManager.default.imagesDirectory()) throws -> URL {
        guard directoryURL != nil else { throw ImageStorageError.whileCreatingFilePath }
        
        let fileName = NSUUID().uuidString
        
        return directoryURL!.appendingPathComponent("\(fileName).jpg")
    }
    
    private func notifyDataChanged() {
        guard let images = try? getAllImages() else { return }
        observerDelegate.didAllImagesUpdated(images)
    }
}

extension ImageStorage: ImageStorageProtocol {
    func getAllImages() throws -> [ImageDto] {
        let fileManager = FileManager.default
        let documentUrl = try fileManager.imagesDirectory()
        
        let files = try fileManager.contentsOfDirectory(at: documentUrl, includingPropertiesForKeys: nil)
        
        return files.compactMap {
            guard let attributes = try? fileManager.attributesOfItem(atPath: $0.path) else { return nil }
            guard let fileCreationDate = attributes[.creationDate] as? Date else { return nil }
            
            return ImageDto(uuid: $0.deletingPathExtension().lastPathComponent, path: $0.path, creationDate: fileCreationDate)
        }
    }
    
    func save(image: Data) throws {
        guard let imageData = UIImage(data: image)?.jpegData(compressionQuality: 0.5) else { throw ImageStorageError.whileCreatingImageInstance }
        let filePath = try createFilePath()
        
        do {
            try imageData.write(to: filePath, options: .atomic)
        } catch let e {
            print(e)
            throw ImageStorageError.whileWritingData
        }
        
        notifyDataChanged()
    }
    
    func delete(byIds ids: [String]) throws {
        let fileManager = FileManager.default
        let documentUrl = try fileManager.imagesDirectory()
        
        let files = try fileManager.contentsOfDirectory(at: documentUrl, includingPropertiesForKeys: nil)
        
        try files.forEach { url in
            let uuid = url.deletingPathExtension().lastPathComponent
            
            if ids.contains(uuid) {
                try fileManager.removeItem(at: url)
            }
        }
    }
}

extension FileManager {
    fileprivate func imagesDirectory() throws -> URL {
        guard let fullDirectoryURL = self.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Photos") else { throw ImageStorageError.whileCreatingFilePath }
        
        if !self.fileExists(atPath: fullDirectoryURL.path) {
            try self.createDirectory(at: fullDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        return fullDirectoryURL
    }
    
    fileprivate func tempDirectory() throws -> URL {
        let fullDirectoryURL = self.temporaryDirectory.appendingPathComponent("Photos")
        
        if !self.fileExists(atPath: fullDirectoryURL.path) {
            try self.createDirectory(at: fullDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        return fullDirectoryURL
    }
}
