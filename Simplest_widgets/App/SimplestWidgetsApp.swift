//
//  SimplestWidgetsApp.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import SwiftUI
import ComposableArchitecture

@main
struct SimplestWidgetsApp: App {
    // TCA Store
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: SimplestWidgetsApp.store)
                .onOpenURL { url in
                    SimplestWidgetsApp.store.send(.deepLinkReceived(url))
                }
        }
    }
}
