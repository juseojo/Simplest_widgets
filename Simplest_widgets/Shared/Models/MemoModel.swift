//
//  MemoModel.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation

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

// MARK: - Memo Widget Type

enum MemoWidgetType: String, CaseIterable, Codable, Equatable {
    case normal = "normal"
    case compact = "compact"

    var displayName: String {
        switch self {
        case .normal: return "일반"
        case .compact: return "컴팩트"
        }
    }
}

// MARK: - Temperature Widget Type

enum TemperatureWidgetType: String, CaseIterable, Codable, Equatable {
    case normal = "normal"
    case reverse = "reverse"

    var displayName: String {
        switch self {
        case .normal: return "일반"
        case .reverse: return "반전"
        }
    }
}

// MARK: - Temperature Notation

enum TemperatureNotation: String, CaseIterable, Codable, Equatable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"

    var displayName: String {
        switch self {
        case .celsius: return "섭씨 (°C)"
        case .fahrenheit: return "화씨 (°F)"
        }
    }

    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
}
