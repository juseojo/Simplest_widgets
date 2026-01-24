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
    case memo = "Memo"
    case temperature = "Temperature"
    case dday = "Dday"
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
        var isOnboardingCompleted: Bool = false
        var hasHomeScreenImage: Bool = false
        var selectedTab: AppTab = .memo
        var memo: MemoFeature.State = MemoFeature.State()
        var temperature: TemperatureFeature.State = TemperatureFeature.State()
        var dday: DdayFeature.State = DdayFeature.State()
    }

    enum Action {
        case onAppear
        case deepLinkReceived(URL)
        case tabSelected(AppTab)
        case onboardingCompleted
        case homeScreenImageSet

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
                state.isOnboardingCompleted = userDefaultsClient.isOnboardingCompleted()
                state.hasHomeScreenImage = userDefaultsClient.hasHomeScreenImage()
                return .none

            case let .deepLinkReceived(url):
                guard let deepLink = DeepLink(url: url) else { return .none }

                switch deepLink {
                case .memo, .memoWrite:
                    state.selectedTab = .memo
                    return .send(.memo(.startWriting))
                case .memoMic:
                    state.selectedTab = .memo
                    return .send(.memo(.startRecording))
                case .temperature:
                    state.selectedTab = .temperature
                case .dday:
                    state.selectedTab = .dday
                }
                return .none

            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none

            case .onboardingCompleted:
                state.isOnboardingCompleted = true
                userDefaultsClient.setOnboardingCompleted(true)
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
