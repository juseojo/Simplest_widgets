//
//  DdayFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture
import WidgetKit

@Reducer
struct DdayFeature {
    @ObservableState
    struct State: Equatable {
        // Widget Settings
        var widgetPosition: String = "00"
        var innerPosition: DdayInnerPosition = .position1
        var color: WidgetColorType = .white
        var targetDate: Date = Date()
        var selectedSize: WidgetSizeType = .small

        // UI States
        var errorMessage: String?

        // Computed
        var daysRemaining: Int {
            calculateDday(from: targetDate)
        }

        var ddayDisplayText: String {
            let days = daysRemaining
            if days < 0 {
                return "D - \(-days)"
            } else if days == 0 {
                return "D - day"
            } else {
                return "D + \(days)"
            }
        }

        var isSmallWidget: Bool {
            widgetPosition.first == "1" || widgetPosition == "00"
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
        case settingsLoaded(
            widgetPosition: String,
            innerPosition: String,
            color: String,
            dateString: String?
        )

        // Input
        case dateChanged(Date)

        // Widget Settings
        case widgetPositionChanged(String)
        case innerPositionChanged(DdayInnerPosition)
        case colorChanged(WidgetColorType)
        case selectedSizeChanged(WidgetSizeType)

        // Widget Reload
        case reloadWidgets

        // Error
        case clearError
    }

    @Dependency(\.userDefaultsClient) var userDefaultsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadSettings)

            case .loadSettings:
                let widgetPosition = userDefaultsClient.getDdayWidgetPosition()
                let innerPosition = userDefaultsClient.getDdayPosition()
                let color = userDefaultsClient.getDdayColor()
                let dateString = userDefaultsClient.getDdayDate()

                return .send(.settingsLoaded(
                    widgetPosition: widgetPosition,
                    innerPosition: innerPosition,
                    color: color,
                    dateString: dateString
                ))

            case let .settingsLoaded(widgetPosition, innerPosition, color, dateString):
                state.widgetPosition = widgetPosition
                state.innerPosition = DdayInnerPosition(rawValue: innerPosition) ?? .position1
                state.color = WidgetColorType(localizedString: color)

                // Parse date string
                if let dateString = dateString,
                   let date = Date.fromStorageString(dateString) {
                    state.targetDate = date
                }

                // Determine size from position
                if widgetPosition.first == "2" {
                    state.selectedSize = .medium
                } else {
                    state.selectedSize = .small
                }
                return .none

            case let .dateChanged(date):
                state.targetDate = date
                userDefaultsClient.setDdayDate(date.toStorageString())
                return .send(.reloadWidgets)

            case let .widgetPositionChanged(position):
                state.widgetPosition = position
                userDefaultsClient.setDdayWidgetPosition(position)
                return .send(.reloadWidgets)

            case let .innerPositionChanged(position):
                state.innerPosition = position
                userDefaultsClient.setDdayPosition(position.rawValue)
                return .send(.reloadWidgets)

            case let .colorChanged(color):
                state.color = color
                userDefaultsClient.setDdayColor(color.localizedName)
                return .send(.reloadWidgets)

            case let .selectedSizeChanged(size):
                state.selectedSize = size
                return .none

            case .reloadWidgets:
                return .run { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }

            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
