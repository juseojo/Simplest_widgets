//
//  WidgetPosition.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation

/// 2x2 위젯 포지션 (Small Widget)
/// 11, 12 - 1행
/// 13, 14 - 2행
/// 15, 16 - 3행
enum SmallWidgetPosition: String, CaseIterable, Codable, Equatable {
    case position11 = "11"
    case position12 = "12"
    case position13 = "13"
    case position14 = "14"
    case position15 = "15"
    case position16 = "16"

    var displayName: String {
        switch self {
        case .position11: return "1행 좌측"
        case .position12: return "1행 우측"
        case .position13: return "2행 좌측"
        case .position14: return "2행 우측"
        case .position15: return "3행 좌측"
        case .position16: return "3행 우측"
        }
    }

    var row: Int {
        switch self {
        case .position11, .position12: return 1
        case .position13, .position14: return 2
        case .position15, .position16: return 3
        }
    }

    var column: Int {
        switch self {
        case .position11, .position13, .position15: return 1
        case .position12, .position14, .position16: return 2
        }
    }
}

/// 2x4 위젯 포지션 (Medium Widget)
/// 21 - 1행
/// 22 - 2행
/// 23 - 3행
enum MediumWidgetPosition: String, CaseIterable, Codable, Equatable {
    case position21 = "21"
    case position22 = "22"
    case position23 = "23"

    var displayName: String {
        switch self {
        case .position21: return "1행"
        case .position22: return "2행"
        case .position23: return "3행"
        }
    }

    var row: Int {
        switch self {
        case .position21: return 1
        case .position22: return 2
        case .position23: return 3
        }
    }
}

/// 통합 위젯 포지션
enum WidgetPosition: Equatable, Codable {
    case small(SmallWidgetPosition)
    case medium(MediumWidgetPosition)

    var rawValue: String {
        switch self {
        case .small(let position): return position.rawValue
        case .medium(let position): return position.rawValue
        }
    }

    init?(rawValue: String) {
        if let small = SmallWidgetPosition(rawValue: rawValue) {
            self = .small(small)
        } else if let medium = MediumWidgetPosition(rawValue: rawValue) {
            self = .medium(medium)
        } else {
            return nil
        }
    }

    var isSmall: Bool {
        if case .small = self { return true }
        return false
    }

    var isMedium: Bool {
        if case .medium = self { return true }
        return false
    }
}
