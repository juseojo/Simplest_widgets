//
//  MemoFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture

@Reducer
struct MemoFeature {
    @ObservableState
    struct State: Equatable {
        var memos: [Memo] = []
        var inputText: String = ""
        var widgetPosition: String = "11"
        var widgetType: MemoWidgetType = .normal

        // Recording
        var isRecording: Bool = false
        var transcribedText: String = ""

        // UI States
        var isWriting: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        // Lifecycle
        case onAppear
        case loadSettings
        case settingsLoaded(position: String, type: MemoWidgetType)

        // Memos
        case fetchMemos
        case memosLoaded([Memo])
        case memosFetchFailed(String)

        // Input
        case inputTextChanged(String)
        case startWriting
        case cancelWriting
        case saveMemo
        case memoSaved(Memo)
        case memoSaveFailed(String)

        // Delete
        case deleteMemo(IndexSet)
        case memoDeleted
        case memoDeleteFailed(String)

        // Settings
        case widgetPositionChanged(String)
        case widgetTypeChanged(MemoWidgetType)

        // Speech Recognition
        case startRecording
        case stopRecording
        case transcriptionUpdated(String)
        case transcriptionFinished

        // Error
        case clearError
    }

    @Dependency(\.coreDataClient) var coreDataClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.speechRecognizerClient) var speechRecognizerClient

    private enum CancelID {
        case transcription
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.loadSettings),
                    .send(.fetchMemos)
                )

            case .loadSettings:
                let position = userDefaultsClient.getMemoWidgetPosition()
                let typeRaw = userDefaultsClient.getMemoWidgetType()
                let type = MemoWidgetType(rawValue: typeRaw) ?? .normal
                return .send(.settingsLoaded(position: position, type: type))

            case let .settingsLoaded(position, type):
                state.widgetPosition = position
                state.widgetType = type
                return .none

            case .fetchMemos:
                state.isLoading = true
                return .run { send in
                    do {
                        let memos = try await coreDataClient.fetchMemos()
                        await send(.memosLoaded(memos))
                    } catch {
                        await send(.memosFetchFailed(error.localizedDescription))
                    }
                }

            case let .memosLoaded(memos):
                state.isLoading = false
                state.memos = memos
                return .none

            case let .memosFetchFailed(error):
                state.isLoading = false
                state.errorMessage = error
                return .none

            case let .inputTextChanged(text):
                state.inputText = text
                return .none

            case .startWriting:
                state.isWriting = true
                state.inputText = ""
                return .none

            case .cancelWriting:
                state.isWriting = false
                state.inputText = ""
                state.transcribedText = ""
                return .cancel(id: CancelID.transcription)

            case .saveMemo:
                let text = state.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !text.isEmpty else { return .none }

                state.isLoading = true
                return .run { send in
                    do {
                        let memo = try await coreDataClient.saveMemo(text)
                        await send(.memoSaved(memo))
                    } catch {
                        await send(.memoSaveFailed(error.localizedDescription))
                    }
                }

            case let .memoSaved(memo):
                state.isLoading = false
                state.isWriting = false
                state.inputText = ""
                state.transcribedText = ""
                state.memos.insert(memo, at: 0)
                return .none

            case let .memoSaveFailed(error):
                state.isLoading = false
                state.errorMessage = error
                return .none

            case let .deleteMemo(indexSet):
                guard let index = indexSet.first,
                      index < state.memos.count else { return .none }

                let memoId = state.memos[index].id
                state.memos.remove(atOffsets: indexSet)

                return .run { send in
                    do {
                        try await coreDataClient.deleteMemo(memoId)
                        await send(.memoDeleted)
                    } catch {
                        await send(.memoDeleteFailed(error.localizedDescription))
                    }
                }

            case .memoDeleted:
                return .none

            case let .memoDeleteFailed(error):
                state.errorMessage = error
                return .send(.fetchMemos) // Refresh to restore state

            case let .widgetPositionChanged(position):
                state.widgetPosition = position
                userDefaultsClient.setMemoWidgetPosition(position)
                return .none

            case let .widgetTypeChanged(type):
                state.widgetType = type
                userDefaultsClient.setMemoWidgetType(type.rawValue)
                return .none

            case .startRecording:
                state.isRecording = true
                state.isWriting = true
                state.transcribedText = ""

                return .run { send in
                    for await transcript in speechRecognizerClient.startTranscribing() {
                        await send(.transcriptionUpdated(transcript))
                    }
                    await send(.transcriptionFinished)
                }
                .cancellable(id: CancelID.transcription)

            case .stopRecording:
                state.isRecording = false
                return .run { _ in
                    await speechRecognizerClient.stopTranscribing()
                }

            case let .transcriptionUpdated(text):
                state.transcribedText = text
                state.inputText = text
                return .none

            case .transcriptionFinished:
                state.isRecording = false
                return .none

            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
