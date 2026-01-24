//
//  UserDefaults+Shared.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation

extension UserDefaults {
    /// App Groups 공유 UserDefaults
    static var shared: UserDefaults {
        let groupIdentifier = "group.simplest_widgets"
        return UserDefaults(suiteName: groupIdentifier)!
    }
}
