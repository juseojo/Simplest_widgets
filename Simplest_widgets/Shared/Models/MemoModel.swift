//
//  MemoModel.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import SwiftUI

// MARK: - Memo Model

struct Memo: Equatable, Identifiable {
    let id: UUID
    var text: String
    var date: Date

    init(id: UUID = UUID(), text: String, date: Date = Date()) {
        self.id = id
        self.text = text
        self.date = date
    }
}

// MARK: - Widget Orientation Type (Horizon/Vertical)

enum WidgetOrientationType: String, CaseIterable, Equatable {
    case horizon = "Horizon"
    case vertical = "Vertical"

    var localizedName: String {
        switch self {
        case .horizon: return String(localized: "Horizon")
        case .vertical: return String(localized: "Vertical")
        }
    }

    init(localizedString: String) {
        if localizedString == String(localized: "Vertical") {
            self = .vertical
        } else {
            self = .horizon
        }
    }
}

// MARK: - Widget Color Type (White/Black)

enum WidgetColorType: String, CaseIterable, Equatable {
    case white = "White"
    case black = "Black"

    var localizedName: String {
        switch self {
        case .white: return String(localized: "White")
        case .black: return String(localized: "Black")
        }
    }

    var color: Color {
        switch self {
        case .white: return .white
        case .black: return .black
        }
    }

    init(localizedString: String) {
        if localizedString == String(localized: "Black") {
            self = .black
        } else {
            self = .white
        }
    }
}

// MARK: - Widget Inner Position (1/2/3)

enum WidgetInnerPosition: String, CaseIterable, Equatable {
    case position1 = "1"
    case position2 = "2"
    case position3 = "3"

    var displayName: String { rawValue }
}

// MARK: - Temperature Notation Type

enum TemperatureNotationType: String, CaseIterable, Equatable {
    case normal = "normal"
    case differenceNow = "diffrence now"

    var localizedName: String {
        switch self {
        case .normal: return String(localized: "normal")
        case .differenceNow: return String(localized: "diffrence now")
        }
    }

    init(localizedString: String) {
        if localizedString == String(localized: "diffrence now") {
            self = .differenceNow
        } else {
            self = .normal
        }
    }
}

// MARK: - Temperature Time Range

enum TemperatureTimeRange: String, CaseIterable, Equatable {
    case oneDay = "1 Day"
    case oneWeek = "1 Week"

    var localizedName: String {
        switch self {
        case .oneDay: return String(localized: "1 Day")
        case .oneWeek: return String(localized: "1 Week")
        }
    }

    init(localizedString: String) {
        if localizedString == String(localized: "1 Week") {
            self = .oneWeek
        } else {
            self = .oneDay
        }
    }
}

// MARK: - D-Day Inner Position (1/2 only)

enum DdayInnerPosition: String, CaseIterable, Equatable {
    case position1 = "1"
    case position2 = "2"

    var displayName: String { rawValue }
}

// MARK: - Widget Size Type

enum WidgetSizeType: String, CaseIterable, Equatable {
    case small = "2 X 2"
    case medium = "2 X 4"

    var displayName: String { rawValue }

    var isSmall: Bool { self == .small }
    var isMedium: Bool { self == .medium }
}
