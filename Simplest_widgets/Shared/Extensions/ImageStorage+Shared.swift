//
//  ImageStorage+Shared.swift
//  Simplest_widgets
//
//  Shared image storage functions for both App and Widget Extensions
//

import UIKit

// MARK: - Shared Image Storage (TCA-free)

enum SharedImageStorage {
    static let groupIdentifier = "group.simplest_widgets"
    static let homeScreenImageName = "Home_screen"

    static func save(data: Data, name: String) -> Bool {
        guard let path = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)?
            .appendingPathComponent("\(name).png") else {
            return false
        }

        do {
            try data.write(to: path)
            return true
        } catch {
            print("SharedImageStorage save error: \(error.localizedDescription)")
            return false
        }
    }

    static func load(name: String) -> UIImage? {
        guard let imagePath = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)?
            .appendingPathComponent("\(name).png") else {
            return nil
        }

        return UIImage(contentsOfFile: imagePath.path())
    }

    static func loadHomeScreenImage() -> UIImage? {
        return load(name: homeScreenImageName)
    }

    static func exists(name: String) -> Bool {
        guard let containerURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
            return false
        }

        let fileURL = containerURL.appendingPathComponent("\(name).png")
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
}
