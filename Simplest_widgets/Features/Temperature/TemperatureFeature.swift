//
//  TemperatureFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture
import WidgetKit

@Reducer
struct TemperatureFeature {
    @ObservableState
    struct State: Equatable {
        // Widget Settings
        var widgetPosition: String = "00"
        var notation: TemperatureNotationType = .normal
        var widgetType: WidgetOrientationType = .horizon
        var innerPosition: WidgetInnerPosition = .position1
        var timeRange: TemperatureTimeRange = .oneDay
        var selectedSize: WidgetSizeType = .small

        // UI States
        var isLoading: Bool = false
        var errorMessage: String?

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
            notation: String,
            widgetType: String,
            innerPosition: String,
            timeRange: String
        )

        // Widget Settings
        case widgetPositionChanged(String)
        case notationChanged(TemperatureNotationType)
        case widgetTypeChanged(WidgetOrientationType)
        case innerPositionChanged(WidgetInnerPosition)
        case timeRangeChanged(TemperatureTimeRange)
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
                let widgetPosition = userDefaultsClient.getTemperatureWidgetPosition()
                let notation = userDefaultsClient.getTemperatureNotation()
                let widgetType = userDefaultsClient.getTemperatureType()
                let innerPosition = userDefaultsClient.getTemperaturePosition()
                let timeRange = userDefaultsClient.getTemperatureTime()

                return .send(.settingsLoaded(
                    widgetPosition: widgetPosition,
                    notation: notation,
                    widgetType: widgetType,
                    innerPosition: innerPosition,
                    timeRange: timeRange
                ))

            case let .settingsLoaded(widgetPosition, notation, widgetType, innerPosition, timeRange):
                state.widgetPosition = widgetPosition
                state.notation = TemperatureNotationType(localizedString: notation)
                state.widgetType = WidgetOrientationType(localizedString: widgetType)
                state.innerPosition = WidgetInnerPosition(rawValue: innerPosition) ?? .position1
                state.timeRange = TemperatureTimeRange(localizedString: timeRange)

                // Determine size from position
                if widgetPosition.first == "2" {
                    state.selectedSize = .medium
                } else {
                    state.selectedSize = .small
                }
                return .none

            case let .widgetPositionChanged(position):
                state.widgetPosition = position
                userDefaultsClient.setTemperatureWidgetPosition(position)
                return .send(.reloadWidgets)

            case let .notationChanged(notation):
                state.notation = notation
                userDefaultsClient.setTemperatureNotation(notation.localizedName)
                return .send(.reloadWidgets)

            case let .widgetTypeChanged(type):
                state.widgetType = type
                userDefaultsClient.setTemperatureType(type.localizedName)
                return .send(.reloadWidgets)

            case let .innerPositionChanged(position):
                state.innerPosition = position
                userDefaultsClient.setTemperaturePosition(position.rawValue)
                return .send(.reloadWidgets)

            case let .timeRangeChanged(timeRange):
                state.timeRange = timeRange
                userDefaultsClient.setTemperatureTime(timeRange.localizedName)
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
