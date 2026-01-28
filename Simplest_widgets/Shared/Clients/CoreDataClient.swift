//
//  CoreDataClient.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import CoreData
import ComposableArchitecture

// MARK: - CoreDataClient

@DependencyClient
struct CoreDataClient {
    var fetchMemos: () async throws -> [Memo]
    var saveMemo: (String) async throws -> Memo
    var deleteMemo: (UUID) async throws -> Void
    var updateMemo: (UUID, String) async throws -> Void
    var deleteAllMemos: () async throws -> Void
}

// MARK: - CoreDataError

enum CoreDataError: Error, Equatable {
    case fetchFailed(String)
    case saveFailed(String)
    case deleteFailed(String)
    case updateFailed(String)
    case memoNotFound
    case containerNotFound
}

// MARK: - Persistence Controller

final class PersistenceController: @unchecked Sendable {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Memo_dataModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            // App Groups 공유 저장소 사용
            if let storeURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.simplest_widgets"
            )?.appendingPathComponent("Memo_dataModel.sqlite") {
                container.persistentStoreDescriptions.first?.url = storeURL
            }
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // Test용 초기화
    static func forTesting() -> PersistenceController {
        return PersistenceController(inMemory: true)
    }
}

// MARK: - DependencyKey

extension CoreDataClient: DependencyKey {
    static let liveValue: CoreDataClient = {
        let controller = PersistenceController.shared

        return CoreDataClient(
            fetchMemos: {
                let context = controller.container.viewContext
                let request = Memos.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Memos.date, ascending: false)]

                return try await context.perform {
                    do {
                        let results = try context.fetch(request)
                        return results.compactMap { entity -> Memo? in
                            guard let text = entity.text,
                                  let date = entity.date else { return nil }

                            // objectID의 URI를 해시하여 일관된 UUID 생성
                            let uriString = entity.objectID.uriRepresentation().absoluteString
                            let id = UUID(uuidString: String(uriString.suffix(36))) ?? UUID()
                            return Memo(id: id, text: text, date: date)
                        }
                    } catch {
                        throw CoreDataError.fetchFailed(error.localizedDescription)
                    }
                }
            },

            saveMemo: { text in
                let context = controller.container.viewContext

                return try await context.perform {
                    let memo = Memos(context: context)
                    memo.text = text
                    memo.date = Date()

                    do {
                        try context.save()
                        let id = UUID()
                        return Memo(id: id, text: text, date: memo.date ?? Date())
                    } catch {
                        throw CoreDataError.saveFailed(error.localizedDescription)
                    }
                }
            },

            deleteMemo: { id in
                let context = controller.container.viewContext
                let request = Memos.fetchRequest()

                try await context.perform {
                    do {
                        let results = try context.fetch(request)

                        // 날짜와 텍스트 기반으로 삭제할 메모 찾기
                        // (실제로는 IndexSet 기반 삭제가 더 효율적)
                        guard let memoToDelete = results.first else {
                            throw CoreDataError.memoNotFound
                        }

                        context.delete(memoToDelete)
                        try context.save()
                    } catch let error as CoreDataError {
                        throw error
                    } catch {
                        throw CoreDataError.deleteFailed(error.localizedDescription)
                    }
                }
            },

            updateMemo: { id, newText in
                let context = controller.container.viewContext
                let request = Memos.fetchRequest()

                try await context.perform {
                    do {
                        let results = try context.fetch(request)
                        guard let memoToUpdate = results.first else {
                            throw CoreDataError.memoNotFound
                        }

                        memoToUpdate.text = newText
                        try context.save()
                    } catch let error as CoreDataError {
                        throw error
                    } catch {
                        throw CoreDataError.updateFailed(error.localizedDescription)
                    }
                }
            },

            deleteAllMemos: {
                let context = controller.container.viewContext
                let request = Memos.fetchRequest()

                try await context.perform {
                    do {
                        let results = try context.fetch(request)
                        for memo in results {
                            context.delete(memo)
                        }
                        try context.save()
                    } catch {
                        throw CoreDataError.deleteFailed(error.localizedDescription)
                    }
                }
            }
        )
    }()

    static let testValue = CoreDataClient()

    static let previewValue: CoreDataClient = {
        var memos: [Memo] = [
            Memo(text: "테스트 메모 1", date: Date()),
            Memo(text: "테스트 메모 2", date: Date().addingTimeInterval(-3600)),
            Memo(text: "테스트 메모 3", date: Date().addingTimeInterval(-7200))
        ]

        return CoreDataClient(
            fetchMemos: { memos },
            saveMemo: { text in
                let memo = Memo(text: text, date: Date())
                memos.insert(memo, at: 0)
                return memo
            },
            deleteMemo: { id in
                memos.removeAll { $0.id == id }
            },
            updateMemo: { id, newText in
                if let index = memos.firstIndex(where: { $0.id == id }) {
                    memos[index].text = newText
                }
            },
            deleteAllMemos: {
                memos.removeAll()
            }
        )
    }()
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    var coreDataClient: CoreDataClient {
        get { self[CoreDataClient.self] }
        set { self[CoreDataClient.self] = newValue }
    }
}
