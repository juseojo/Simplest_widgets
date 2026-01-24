//
//  UserDefaultsClient.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture

// MARK: - UserDefaults Keys

enum UserDefaultsKey {
    static let memoWidgetPosition = "memo widget position"
    static let memoWidgetType = "memo widget type"
    static let temperatureWidgetPosition = "temperature widget position"
    static let temperatureNotation = "temperature notation"
    static let temperatureWidgetType = "temperature widget type"
    static let ddayDate = "Dday date"
    static let ddayTitle = "Dday title"
    static let ddayWidgetPosition = "Dday widget position"
    static let isOnboardingCompleted = "is onboarding completed"
    static let hasHomeScreenImage = "has home screen image"
}

// MARK: - UserDefaultsClient

@DependencyClient
struct UserDefaultsClient {
    // MARK: - Memo
    var getMemoWidgetPosition: () -> String = { "11" }
    var setMemoWidgetPosition: (String) -> Void
    var getMemoWidgetType: () -> String = { "normal" }
    var setMemoWidgetType: (String) -> Void

    // MARK: - Temperature
    var getTemperatureWidgetPosition: () -> String = { "21" }
    var setTemperatureWidgetPosition: (String) -> Void
    var getTemperatureNotation: () -> String = { "celsius" }
    var setTemperatureNotation: (String) -> Void
    var getTemperatureWidgetType: () -> String = { "normal" }
    var setTemperatureWidgetType: (String) -> Void

    // MARK: - D-day
    var getDdayDate: () -> Date? = { nil }
    var setDdayDate: (Date) -> Void
    var getDdayTitle: () -> String = { "" }
    var setDdayTitle: (String) -> Void
    var getDdayWidgetPosition: () -> String = { "11" }
    var setDdayWidgetPosition: (String) -> Void

    // MARK: - Onboarding
    var isOnboardingCompleted: () -> Bool = { false }
    var setOnboardingCompleted: (Bool) -> Void

    // MARK: - Home Screen Image
    var hasHomeScreenImage: () -> Bool = { false }
    var setHasHomeScreenImage: (Bool) -> Void
}

// MARK: - DependencyKey

extension UserDefaultsClient: DependencyKey {
    static let liveValue: UserDefaultsClient = {
        let defaults = UserDefaults(suiteName: "group.simplest_widgets")!

        return UserDefaultsClient(
            // Memo
            getMemoWidgetPosition: {
                defaults.string(forKey: UserDefaultsKey.memoWidgetPosition) ?? "11"
            },
            setMemoWidgetPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.memoWidgetPosition)
            },
            getMemoWidgetType: {
                defaults.string(forKey: UserDefaultsKey.memoWidgetType) ?? "normal"
            },
            setMemoWidgetType: { value in
                defaults.set(value, forKey: UserDefaultsKey.memoWidgetType)
            },

            // Temperature
            getTemperatureWidgetPosition: {
                defaults.string(forKey: UserDefaultsKey.temperatureWidgetPosition) ?? "21"
            },
            setTemperatureWidgetPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperatureWidgetPosition)
            },
            getTemperatureNotation: {
                defaults.string(forKey: UserDefaultsKey.temperatureNotation) ?? "celsius"
            },
            setTemperatureNotation: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperatureNotation)
            },
            getTemperatureWidgetType: {
                defaults.string(forKey: UserDefaultsKey.temperatureWidgetType) ?? "normal"
            },
            setTemperatureWidgetType: { value in
                defaults.set(value, forKey: UserDefaultsKey.temperatureWidgetType)
            },

            // D-day
            getDdayDate: {
                defaults.object(forKey: UserDefaultsKey.ddayDate) as? Date
            },
            setDdayDate: { value in
                defaults.set(value, forKey: UserDefaultsKey.ddayDate)
            },
            getDdayTitle: {
                defaults.string(forKey: UserDefaultsKey.ddayTitle) ?? ""
            },
            setDdayTitle: { value in
                defaults.set(value, forKey: UserDefaultsKey.ddayTitle)
            },
            getDdayWidgetPosition: {
                defaults.string(forKey: UserDefaultsKey.ddayWidgetPosition) ?? "11"
            },
            setDdayWidgetPosition: { value in
                defaults.set(value, forKey: UserDefaultsKey.ddayWidgetPosition)
            },

            // Onboarding
            isOnboardingCompleted: {
                defaults.bool(forKey: UserDefaultsKey.isOnboardingCompleted)
            },
            setOnboardingCompleted: { value in
                defaults.set(value, forKey: UserDefaultsKey.isOnboardingCompleted)
            },

            // Home Screen Image
            hasHomeScreenImage: {
                defaults.bool(forKey: UserDefaultsKey.hasHomeScreenImage)
            },
            setHasHomeScreenImage: { value in
                defaults.set(value, forKey: UserDefaultsKey.hasHomeScreenImage)
            }
        )
    }()

    static let testValue = UserDefaultsClient()
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
