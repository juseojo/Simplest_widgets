//
//  MemoFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture
import WidgetKit

@Reducer
struct MemoFeature {
    @ObservableState
    struct State: Equatable {
        // Memos
        var memos: [Memo] = []

        // Widget Settings
        var widgetPosition: String = "00"
        var widgetType: WidgetOrientationType = .horizon
        var innerPosition: WidgetInnerPosition = .position1
        var color: WidgetColorType = .white
        var selectedSize: WidgetSizeType = .small

        // Input
        var inputText: String = ""

        // Recording
        var isRecording: Bool = false
        var transcribedText: String = ""

        // UI States
        var isWriting: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?

        // Deep Link Navigation
        var shouldNavigateToStorage: Bool = false

        // Computed
        var isSmallWidget: Bool {
            widgetPosition.first == "1" || widgetPosition == "00"
        }
    }

    enum Action {
        // Lifecycle
        case onAppear
        case loadSettings
        case settingsLoaded(
            widgetPosition: String,
            widgetType: String,
            innerPosition: String,
            color: String
        )

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

        // Widget Settings
        case widgetPositionChanged(String)
        case widgetTypeChanged(WidgetOrientationType)
        case innerPositionChanged(WidgetInnerPosition)
        case colorChanged(WidgetColorType)
        case selectedSizeChanged(WidgetSizeType)

        // Speech Recognition
        case startRecording
        case stopRecording
        case transcriptionUpdated(String)
        case transcriptionFinished

        // Widget Reload
        case reloadWidgets

        // Error
        case clearError

        // Deep Link Navigation
        case navigateToStorage
        case storageNavigationCompleted
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
                let widgetPosition = userDefaultsClient.getMemoWidgetPosition()
                let widgetType = userDefaultsClient.getMemoType()
                let innerPosition = userDefaultsClient.getMemoPosition()
                let color = userDefaultsClient.getMemoColor()

                return .send(.settingsLoaded(
                    widgetPosition: widgetPosition,
                    widgetType: widgetType,
                    innerPosition: innerPosition,
                    color: color
                ))

            case let .settingsLoaded(widgetPosition, widgetType, innerPosition, color):
                state.widgetPosition = widgetPosition
                state.widgetType = WidgetOrientationType(localizedString: widgetType)
                state.innerPosition = WidgetInnerPosition(rawValue: innerPosition) ?? .position1
                state.color = WidgetColorType(localizedString: color)

                // Determine size from position
                if widgetPosition.first == "2" {
                    state.selectedSize = .medium
                } else {
                    state.selectedSize = .small
                }
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
                state.isRecording = false
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
                return .send(.reloadWidgets)

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
                return .send(.reloadWidgets)

            case let .memoDeleteFailed(error):
                state.errorMessage = error
                return .send(.fetchMemos)

            case let .widgetPositionChanged(position):
                state.widgetPosition = position
                userDefaultsClient.setMemoWidgetPosition(position)
                return .send(.reloadWidgets)

            case let .widgetTypeChanged(type):
                state.widgetType = type
                userDefaultsClient.setMemoType(type.localizedName)
                return .send(.reloadWidgets)

            case let .innerPositionChanged(position):
                state.innerPosition = position
                userDefaultsClient.setMemoPosition(position.rawValue)
                return .send(.reloadWidgets)

            case let .colorChanged(color):
                state.color = color
                userDefaultsClient.setMemoColor(color.localizedName)
                return .send(.reloadWidgets)

            case let .selectedSizeChanged(size):
                state.selectedSize = size
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

            case .reloadWidgets:
                return .run { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }

            case .clearError:
                state.errorMessage = nil
                return .none

            case .navigateToStorage:
                state.shouldNavigateToStorage = true
                return .none

            case .storageNavigationCompleted:
                state.shouldNavigateToStorage = false
                return .none
            }
        }
    }
}
