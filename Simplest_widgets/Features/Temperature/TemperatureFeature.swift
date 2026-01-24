//
//  TemperatureFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture

@Reducer
struct TemperatureFeature {
    @ObservableState
    struct State: Equatable {
        var widgetPosition: String = "21"
        var temperatureNotation: TemperatureNotation = .celsius
        var widgetType: TemperatureWidgetType = .normal

        // Preview
        var hourlyTemperatures: [Double] = []

        // UI States
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        // Lifecycle
        case onAppear
        case loadSettings
        case settingsLoaded(position: String, notation: TemperatureNotation, type: TemperatureWidgetType)

        // Settings
        case widgetPositionChanged(String)
        case temperatureNotationChanged(TemperatureNotation)
        case widgetTypeChanged(TemperatureWidgetType)

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
                let position = userDefaultsClient.getTemperatureWidgetPosition()
                let notationRaw = userDefaultsClient.getTemperatureNotation()
                let notation = TemperatureNotation(rawValue: notationRaw) ?? .celsius
                let typeRaw = userDefaultsClient.getTemperatureWidgetType()
                let type = TemperatureWidgetType(rawValue: typeRaw) ?? .normal

                return .send(.settingsLoaded(position: position, notation: notation, type: type))

            case let .settingsLoaded(position, notation, type):
                state.widgetPosition = position
                state.temperatureNotation = notation
                state.widgetType = type
                return .none

            case let .widgetPositionChanged(position):
                state.widgetPosition = position
                userDefaultsClient.setTemperatureWidgetPosition(position)
                return .none

            case let .temperatureNotationChanged(notation):
                state.temperatureNotation = notation
                userDefaultsClient.setTemperatureNotation(notation.rawValue)
                return .none

            case let .widgetTypeChanged(type):
                state.widgetType = type
                userDefaultsClient.setTemperatureWidgetType(type.rawValue)
                return .none

            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
