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
}

// MARK: - CoreDataError

enum CoreDataError: Error, Equatable {
    case fetchFailed(String)
    case saveFailed(String)
    case deleteFailed(String)
    case updateFailed(String)
    case memoNotFound
}

// MARK: - Persistence Controller

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
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
    }
}

// MARK: - DependencyKey

extension CoreDataClient: DependencyKey {
    static let liveValue: CoreDataClient = {
        let controller = PersistenceController.shared
        let context = controller.container.viewContext

        return CoreDataClient(
            fetchMemos: {
                let request = NSFetchRequest<Memos>(entityName: "Memos")
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Memos.date, ascending: false)]

                do {
                    let results = try context.fetch(request)
                    return results.compactMap { entity -> Memo? in
                        guard let text = entity.text,
                              let date = entity.date else { return nil }

                        // CoreData의 objectID를 기반으로 UUID 생성
                        let id = UUID(uuidString: entity.objectID.uriRepresentation().lastPathComponent) ?? UUID()
                        return Memo(id: id, text: text, date: date)
                    }
                } catch {
                    throw CoreDataError.fetchFailed(error.localizedDescription)
                }
            },

            saveMemo: { text in
                let memo = Memos(context: context)
                memo.text = text
                memo.date = Date()

                do {
                    try context.save()
                    let id = UUID(uuidString: memo.objectID.uriRepresentation().lastPathComponent) ?? UUID()
                    return Memo(id: id, text: text, date: memo.date ?? Date())
                } catch {
                    throw CoreDataError.saveFailed(error.localizedDescription)
                }
            },

            deleteMemo: { id in
                let request = NSFetchRequest<Memos>(entityName: "Memos")

                do {
                    let results = try context.fetch(request)
                    // ID로 매칭되는 메모 찾기 (간단한 구현을 위해 전체 조회 후 필터)
                    // 실제로는 더 효율적인 방법 사용 가능
                    guard let memoToDelete = results.first(where: {
                        UUID(uuidString: $0.objectID.uriRepresentation().lastPathComponent) == id
                    }) else {
                        throw CoreDataError.memoNotFound
                    }

                    context.delete(memoToDelete)
                    try context.save()
                } catch let error as CoreDataError {
                    throw error
                } catch {
                    throw CoreDataError.deleteFailed(error.localizedDescription)
                }
            },

            updateMemo: { id, newText in
                let request = NSFetchRequest<Memos>(entityName: "Memos")

                do {
                    let results = try context.fetch(request)
                    guard let memoToUpdate = results.first(where: {
                        UUID(uuidString: $0.objectID.uriRepresentation().lastPathComponent) == id
                    }) else {
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
        )
    }()

    static let testValue = CoreDataClient()
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    var coreDataClient: CoreDataClient {
        get { self[CoreDataClient.self] }
        set { self[CoreDataClient.self] = newValue }
    }
}
