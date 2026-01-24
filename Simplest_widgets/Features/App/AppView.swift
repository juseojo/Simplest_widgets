//
//  AppView.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        Group {
            if !store.isOnboardingCompleted {
                // TODO: OnboardingView로 교체
                OnboardingPlaceholderView {
                    store.send(.onboardingCompleted)
                }
            } else if !store.hasHomeScreenImage {
                // TODO: HomeScreenSelectionView로 교체
                HomeScreenSelectionPlaceholderView {
                    store.send(.homeScreenImageSet)
                }
            } else {
                MainTabView(store: store)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .onOpenURL { url in
            store.send(.deepLinkReceived(url))
        }
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            MemoView(store: store.scope(state: \.memo, action: \.memo))
                .tabItem {
                    Label("메모", systemImage: "note.text")
                }
                .tag(AppTab.memo)

            TemperatureView(store: store.scope(state: \.temperature, action: \.temperature))
                .tabItem {
                    Label("온도", systemImage: "thermometer")
                }
                .tag(AppTab.temperature)

            DdayView(store: store.scope(state: \.dday, action: \.dday))
                .tabItem {
                    Label("D-Day", systemImage: "calendar")
                }
                .tag(AppTab.dday)
        }
    }
}

// MARK: - Placeholder Views (임시)

struct OnboardingPlaceholderView: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("온보딩 화면")
                .font(.largeTitle)

            Button("완료") {
                onComplete()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct HomeScreenSelectionPlaceholderView: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("홈 화면 이미지 선택")
                .font(.largeTitle)

            Button("선택 완료") {
                onComplete()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Preview

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State(isOnboardingCompleted: true, hasHomeScreenImage: true)) {
            AppFeature()
        }
    )
}
