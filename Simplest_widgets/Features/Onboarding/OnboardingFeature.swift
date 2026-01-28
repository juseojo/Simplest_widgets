//
//  OnboardingFeature.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var currentPage: Int = 0
        var totalPages: Int = 3
    }

    enum Action {
        case nextPage
        case previousPage
        case pageChanged(Int)
        case skipOnboarding
        case completeOnboarding
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextPage:
                if state.currentPage < state.totalPages - 1 {
                    state.currentPage += 1
                }
                return .none

            case .previousPage:
                if state.currentPage > 0 {
                    state.currentPage -= 1
                }
                return .none

            case let .pageChanged(page):
                state.currentPage = page
                return .none

            case .skipOnboarding:
                return .none

            case .completeOnboarding:
                return .none
            }
        }
    }
}
