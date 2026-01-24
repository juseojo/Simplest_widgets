//
//  DdayFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture

@Reducer
struct DdayFeature {
    @ObservableState
    struct State: Equatable {
        var targetDate: Date = Date()
        var title: String = ""
        var widgetPosition: String = "11"

        // Computed
        var daysRemaining: Int {
            calculateDday(from: targetDate)
        }

        var ddayDisplayText: String {
            let days = daysRemaining
            if days == 0 {
                return "D-Day"
            } else if days > 0 {
                return "D+\(days)"
            } else {
                return "D\(days)"
            }
        }

        private func calculateDday(from date: Date) -> Int {
            let calendar = Calendar.current
            let startDate = calendar.startOfDay(for: date)
            let today = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: startDate, to: today)
            return components.day ?? 0
        }
    }

    enum Action {
        // Lifecycle
        case onAppear
        case loadSettings
        case settingsLoaded(date: Date?, title: String, position: String)

        // Input
        case dateChanged(Date)
        case titleChanged(String)

        // Settings
        case widgetPositionChanged(String)
    }

    @Dependency(\.userDefaultsClient) var userDefaultsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadSettings)

            case .loadSettings:
                let date = userDefaultsClient.getDdayDate()
                let title = userDefaultsClient.getDdayTitle()
                let position = userDefaultsClient.getDdayWidgetPosition()

                return .send(.settingsLoaded(date: date, title: title, position: position))

            case let .settingsLoaded(date, title, position):
                state.targetDate = date ?? Date()
                state.title = title
                state.widgetPosition = position
                return .none

            case let .dateChanged(date):
                state.targetDate = date
                userDefaultsClient.setDdayDate(date)
                return .none

            case let .titleChanged(title):
                state.title = title
                userDefaultsClient.setDdayTitle(title)
                return .none

            case let .widgetPositionChanged(position):
                state.widgetPosition = position
                userDefaultsClient.setDdayWidgetPosition(position)
                return .none
            }
        }
    }
}
