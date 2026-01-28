//
//  WidgetReloadClient.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import WidgetKit
import ComposableArchitecture

// MARK: - WidgetReloadClient

@DependencyClient
struct WidgetReloadClient {
    var reloadAllTimelines: () async -> Void
    var reloadTimeline: (String) async -> Void
}

// MARK: - DependencyKey

extension WidgetReloadClient: DependencyKey {
    static let liveValue = WidgetReloadClient(
        reloadAllTimelines: {
            WidgetCenter.shared.reloadAllTimelines()
        },
        reloadTimeline: { kind in
            WidgetCenter.shared.reloadTimelines(ofKind: kind)
        }
    )

    static let testValue = WidgetReloadClient()

    static let previewValue = WidgetReloadClient(
        reloadAllTimelines: { },
        reloadTimeline: { _ in }
    )
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    var widgetReloadClient: WidgetReloadClient {
        get { self[WidgetReloadClient.self] }
        set { self[WidgetReloadClient.self] = newValue }
    }
}

// MARK: - Widget Kinds

enum WidgetKind {
    static let temperature = "Temperature_widget"
    static let memo = "Memo_widget"
    static let dday = "Dday_widget"
}
