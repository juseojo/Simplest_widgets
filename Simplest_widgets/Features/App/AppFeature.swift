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

// MARK: - Memo Destination (for deep links)

enum MemoDestination: Equatable {
    case storage
    case storageWithWrite
    case storageWithMic
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
        var memoDestination: MemoDestination? = nil

        // Child Features
        var memo: MemoFeature.State = MemoFeature.State()
        var temperature: TemperatureFeature.State = TemperatureFeature.State()
        var dday: DdayFeature.State = DdayFeature.State()
    }

    enum Action {
        case onAppear
        case deepLinkReceived(URL)
        case destinationSelected(AppTab?)
        case memoDestinationSelected(MemoDestination?)
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
                    // 메모 위젯 배경 탭 → MemoView로 이동
                    state.selectedDestination = .memo
                    return .none
                case .memoWrite:
                    // 작성 버튼 탭 → MemoStorageView로 이동 후 작성 시작
                    state.memoDestination = .storageWithWrite
                    return .none
                case .memoMic:
                    // 마이크 버튼 탭 → MemoStorageView로 이동 후 녹음 시작
                    state.memoDestination = .storageWithMic
                    return .none
                case .temperature:
                    state.selectedDestination = .temperature
                    return .none
                case .dday:
                    state.selectedDestination = .dday
                    return .none
                }

            case let .destinationSelected(tab):
                state.selectedDestination = tab
                return .none

            case let .memoDestinationSelected(destination):
                state.memoDestination = destination
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
