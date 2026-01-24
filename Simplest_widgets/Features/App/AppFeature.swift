//
//  AppFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture

// MARK: - Tab

enum AppTab: String, CaseIterable, Equatable {
    case temperature = "Temperature"
    case memo = "Memo"
    case dday = "Dday"

    var title: String {
        switch self {
        case .temperature: return String(localized: "Temperature Bar")
        case .memo: return String(localized: "Memo")
        case .dday: return String(localized: "D-day")
        }
    }

    var imageName: String {
        switch self {
        case .temperature: return "Temperature Bar"
        case .memo: return "Memo"
        case .dday: return "D - Day"
        }
    }
}

// MARK: - DeepLink

enum DeepLink: Equatable {
    case memo
    case memoWrite
    case memoMic
    case temperature
    case dday

    init?(url: URL) {
        guard url.scheme == "simplestWidgets",
              url.host == "widget",
              let pathComponent = url.pathComponents.last else {
            return nil
        }

        switch pathComponent {
        case "Memo":
            self = .memo
        case "Memo_write":
            self = .memoWrite
        case "Memo_mic":
            self = .memoMic
        case "Temperature":
            self = .temperature
        case "Dday":
            self = .dday
        default:
            return nil
        }
    }
}

// MARK: - AppFeature

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var isFirstLaunching: Bool = true
        var hasHomeScreenImage: Bool = false
        var selectedDestination: AppTab? = nil

        // Child Features
        var memo: MemoFeature.State = MemoFeature.State()
        var temperature: TemperatureFeature.State = TemperatureFeature.State()
        var dday: DdayFeature.State = DdayFeature.State()

        // Deep Link
        var deepLinkMemoType: String? = nil  // "write" or "mic"
    }

    enum Action {
        case onAppear
        case deepLinkReceived(URL)
        case destinationSelected(AppTab?)
        case onboardingCompleted
        case homeScreenImageSet

        // Child Features
        case memo(MemoFeature.Action)
        case temperature(TemperatureFeature.Action)
        case dday(DdayFeature.Action)
    }

    @Dependency(\.userDefaultsClient) var userDefaultsClient

    var body: some ReducerOf<Self> {
        Scope(state: \.memo, action: \.memo) {
            MemoFeature()
        }
        Scope(state: \.temperature, action: \.temperature) {
            TemperatureFeature()
        }
        Scope(state: \.dday, action: \.dday) {
            DdayFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isFirstLaunching = userDefaultsClient.isFirstLaunching()
                state.hasHomeScreenImage = userDefaultsClient.hasHomeScreenImage()
                return .none

            case let .deepLinkReceived(url):
                guard let deepLink = DeepLink(url: url) else { return .none }

                switch deepLink {
                case .memo:
                    state.selectedDestination = .memo
                    state.deepLinkMemoType = nil
                case .memoWrite:
                    state.selectedDestination = .memo
                    state.deepLinkMemoType = "write"
                    return .send(.memo(.startWriting))
                case .memoMic:
                    state.selectedDestination = .memo
                    state.deepLinkMemoType = "mic"
                    return .send(.memo(.startRecording))
                case .temperature:
                    state.selectedDestination = .temperature
                case .dday:
                    state.selectedDestination = .dday
                }
                return .none

            case let .destinationSelected(tab):
                state.selectedDestination = tab
                state.deepLinkMemoType = nil
                return .none

            case .onboardingCompleted:
                state.isFirstLaunching = false
                userDefaultsClient.setFirstLaunching(false)
                return .none

            case .homeScreenImageSet:
                state.hasHomeScreenImage = true
                userDefaultsClient.setHasHomeScreenImage(true)
                return .none

            case .memo, .temperature, .dday:
                return .none
            }
        }
    }
}
