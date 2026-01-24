//
//  ImageStorageClient.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import UIKit
import ComposableArchitecture

// MARK: - ImageStorageClient

@DependencyClient
struct ImageStorageClient {
    var saveImage: (Data, String) async throws -> Void
    var loadImage: (String) async -> UIImage?
    var deleteImage: (String) async throws -> Void
    var imageExists: (String) -> Bool = { _ in false }
}

// MARK: - ImageStorageError

enum ImageStorageError: Error, Equatable {
    case directoryNotFound
    case saveFailed(String)
    case deleteFailed(String)
}

// MARK: - DependencyKey

extension ImageStorageClient: DependencyKey {
    static let liveValue: ImageStorageClient = {
        let groupIdentifier = "group.simplest_widgets"

        func getContainerURL() -> URL? {
            FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
        }

        return ImageStorageClient(
            saveImage: { data, name in
                guard let containerURL = getContainerURL() else {
                    throw ImageStorageError.directoryNotFound
                }

                let fileURL = containerURL.appendingPathComponent("\(name).png")

                do {
                    try data.write(to: fileURL)
                } catch {
                    throw ImageStorageError.saveFailed(error.localizedDescription)
                }
            },

            loadImage: { name in
                guard let containerURL = getContainerURL() else {
                    return nil
                }

                let fileURL = containerURL.appendingPathComponent("\(name).png")

                guard FileManager.default.fileExists(atPath: fileURL.path) else {
                    return nil
                }

                return UIImage(contentsOfFile: fileURL.path)
            },

            deleteImage: { name in
                guard let containerURL = getContainerURL() else {
                    throw ImageStorageError.directoryNotFound
                }

                let fileURL = containerURL.appendingPathComponent("\(name).png")

                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    throw ImageStorageError.deleteFailed(error.localizedDescription)
                }
            },

            imageExists: { name in
                guard let containerURL = getContainerURL() else {
                    return false
                }

                let fileURL = containerURL.appendingPathComponent("\(name).png")
                return FileManager.default.fileExists(atPath: fileURL.path)
            }
        )
    }()

    static let testValue = ImageStorageClient()
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    var imageStorageClient: ImageStorageClient {
        get { self[ImageStorageClient.self] }
        set { self[ImageStorageClient.self] = newValue }
    }
}

// MARK: - Convenience Constants

extension ImageStorageClient {
    static let homeScreenImageName = "Home_screen"
}
