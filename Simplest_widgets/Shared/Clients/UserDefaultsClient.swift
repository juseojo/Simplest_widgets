//
//  UserDefaultsClient.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture

// MARK: - UserDefaults Keys (실제 사용되는 키들)

enum UserDefaultsKey {
    // App Global
    static let isFirstLaunching = "_isFirstLaunching"
    static let hasImage = "hasImage"

    // Memo Widget
    static let memoWidgetPosition = "memo widget position"
    static let memoType = "memo type"
    static let memoPosition = "memo position"
    static let memoColor = "memo color"

    // Temperature Widget
    static let temperatureWidgetPosition = "temperature widget position"
    static let temperatureNotation = "temperature notation"
    static let temperatureType = "temperature type"
    static let temperaturePosition = "temperature position"
    static let temperatureTime = "temperature time"

    // D-Day Widget
    static let ddayWidgetPosition = "Dday widget position"
    static let ddayPosition = "Dday position"
    static let ddayColor = "Dday color"
    static let ddayDate = "Dday date"
}

// MARK: - UserDefaultsClient

@DependencyClient
struct UserDefaultsClient {
    // MARK: - App Global
    var isFirstLaunching: () -> Bool = { true }
    var setFirstLaunching: (Bool) -> Void
    var hasHomeScreenImage: () -> Bool = { false }
    var setHasHomeScreenImage: (Bool) -> Void

    // MARK: - Memo Widget
    var getMemoWidgetPosition: () -> String = { "00" }
    var setMemoWidgetPosition: (String) -> Void
    var getMemoType: () -> String = { "Horizon" }
    var setMemoType: (String) -> Void
    var getMemoPosition: () -> String = { "1" }
    var setMemoPosition: (String) -> Void
    var getMemoColor: () -> String = { "White" }
    var setMemoColor: (String) -> Void

    // MARK: - Temperature Widget
    var getTemperatureWidgetPosition: () -> String = { "00" }
    var setTemperatureWidgetPosition: (String) -> Void
    var getTemperatureNotation: () -> String = { "normal" }
    var setTemperatureNotation: (String) -> Void
    var getTemperatureType: () -> String = { "Horizon" }
    var setTemperatureType: (String) -> Void
    var getTemperaturePosition: () -> String = { "1" }
    var setTemperaturePosition: (String) -> Void
    var getTemperatureTime: () -> String = { "1 Day" }
    var setTemperatureTime: (String) -> Void

    // MARK: - D-Day Widget
    var getDdayWidgetPosition: () -> String = { "00" }
    var setDdayWidgetPosition: (String) -> Void
    var getDdayPosition: () -> String = { "1" }
    var setDdayPosition: (String) -> Void
    var getDdayColor: () -> String = { "White" }
    var setDdayColor: (String) -> Void
    var getDdayDate: () -> String? = { nil }
    var setDdayDate: (String) -> Void
}

// MARK: - DependencyKey

extension UserDefaultsClient: DependencyKey {
    static let liveValue: UserDefaultsClient = {
        let defaults = UserDefaults(suiteName: "group.simplest_widgets")!

        return UserDefaultsClient(
            // App Global
            isFirstLaunching: {
                // 키가 없으면 true (첫 실행)
                if defaults.object(forKey: UserDefaultsKey.isFirstLaunching) == nil {
                    return true
                }
                return defaults.bool(forKey: UserDefaultsKey.isFirstLaunching)
            },
            setFirstLaunching: { value in
                defaults.set(value, forKey: UserDefaultsKey.isFirstLaunching)
            },
            hasHomeScreenImage: {
                defaults.bool(forKey: UserDefaultsKey.hasImage)
            },
            setHasHomeScreenImage: { value in
                defaults.set(value, forKey: UserDefaultsKey.hasImage)
            },

            // Memo Widget
            getMemoWidgetPosition: {
                defaults.string(forKey: UserDefaultsKey.memoWidgetPosition) ?? "00"
            },
            setMemoWidgetPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.memoWidgetPosition)
            },
            getMemoType: {
                defaults.string(forKey: UserDefaultsKey.memoType) ?? String(localized: "Horizon")
            },
            setMemoType: { value in
                defaults.set(value, forKey: UserDefaultsKey.memoType)
            },
            getMemoPosition: {
                defaults.string(forKey: UserDefaultsKey.memoPosition) ?? "1"
            },
            setMemoPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.memoPosition)
            },
            getMemoColor: {
                defaults.string(forKey: UserDefaultsKey.memoColor) ?? String(localized: "White")
            },
            setMemoColor: { value in
                defaults.set(value, forKey: UserDefaultsKey.memoColor)
            },

            // Temperature Widget
            getTemperatureWidgetPosition: {
                defaults.string(forKey: UserDefaultsKey.temperatureWidgetPosition) ?? "00"
            },
            setTemperatureWidgetPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperatureWidgetPosition)
            },
            getTemperatureNotation: {
                defaults.string(forKey: UserDefaultsKey.temperatureNotation) ?? String(localized: "normal")
            },
            setTemperatureNotation: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperatureNotation)
            },
            getTemperatureType: {
                defaults.string(forKey: UserDefaultsKey.temperatureType) ?? String(localized: "Horizon")
            },
            setTemperatureType: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperatureType)
            },
            getTemperaturePosition: {
                defaults.string(forKey: UserDefaultsKey.temperaturePosition) ?? "1"
            },
            setTemperaturePosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperaturePosition)
            },
            getTemperatureTime: {
                defaults.string(forKey: UserDefaultsKey.temperatureTime) ?? String(localized: "1 Day")
            },
            setTemperatureTime: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperatureTime)
            },

            // D-Day Widget
            getDdayWidgetPosition: {
                defaults.string(forKey: UserDefaultsKey.ddayWidgetPosition) ?? "00"
            },
            setDdayWidgetPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.ddayWidgetPosition)
            },
            getDdayPosition: {
                defaults.string(forKey: UserDefaultsKey.ddayPosition) ?? "1"
            },
            setDdayPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.ddayPosition)
            },
            getDdayColor: {
                defaults.string(forKey: UserDefaultsKey.ddayColor) ?? String(localized: "White")
            },
            setDdayColor: { value in
                defaults.set(value, forKey: UserDefaultsKey.ddayColor)
            },
            getDdayDate: {
                defaults.string(forKey: UserDefaultsKey.ddayDate)
            },
            setDdayDate: { value in
                defaults.set(value, forKey: UserDefaultsKey.ddayDate)
            }
        )
    }()

    static let testValue = UserDefaultsClient()

    static let previewValue: UserDefaultsClient = {
        var memoPosition = "11"
        var memoType = "Horizon"
        var memoPositionInWidget = "1"
        var memoColor = "White"

        return UserDefaultsClient(
            isFirstLaunching: { false },
            setFirstLaunching: { _ in },
            hasHomeScreenImage: { true },
            setHasHomeScreenImage: { _ in },
            getMemoWidgetPosition: { memoPosition },
            setMemoWidgetPosition: { memoPosition = $0 },
            getMemoType: { memoType },
            setMemoType: { memoType = $0 },
            getMemoPosition: { memoPositionInWidget },
            setMemoPosition: { memoPositionInWidget = $0 },
            getMemoColor: { memoColor },
            setMemoColor: { memoColor = $0 },
            getTemperatureWidgetPosition: { "21" },
            setTemperatureWidgetPosition: { _ in },
            getTemperatureNotation: { "normal" },
            setTemperatureNotation: { _ in },
            getTemperatureType: { "Horizon" },
            setTemperatureType: { _ in },
            getTemperaturePosition: { "1" },
            setTemperaturePosition: { _ in },
            getTemperatureTime: { "1 Day" },
            setTemperatureTime: { _ in },
            getDdayWidgetPosition: { "11" },
            setDdayWidgetPosition: { _ in },
            getDdayPosition: { "1" },
            setDdayPosition: { _ in },
            getDdayColor: { "White" },
            setDdayColor: { _ in },
            getDdayDate: { nil },
            setDdayDate: { _ in }
        )
    }()
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
