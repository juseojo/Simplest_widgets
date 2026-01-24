//
//  DdayView.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import SwiftUI
import ComposableArchitecture

struct DdayView: View {
    @Bindable var store: StoreOf<DdayFeature>

    var body: some View {
        NavigationStack {
            VStack {
                // 위젯 프리뷰 영역
                WidgetPreviewSection(store: store)

                Divider()

                // 설정 영역
                SettingsSection(store: store)

                Spacer()
            }
            .navigationTitle("D-Day 위젯")
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Widget Preview Section

private struct WidgetPreviewSection: View {
    let store: StoreOf<DdayFeature>

    var body: some View {
        VStack(spacing: 8) {
            Text("위젯 미리보기")
                .font(.headline)

            // D-Day 프리뷰
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .overlay {
                    VStack(spacing: 8) {
                        if !store.title.isEmpty {
                            Text(store.title)
                                .font(.headline)
                        }
                        Text(store.ddayDisplayText)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(store.daysRemaining <= 0 ? .red : .primary)
                    }
                }
        }
        .padding()
    }
}

// MARK: - Settings Section

private struct SettingsSection: View {
    @Bindable var store: StoreOf<DdayFeature>

    var body: some View {
        Form {
            Section("D-Day 정보") {
                TextField("제목", text: $store.title.sending(\.titleChanged))

                DatePicker(
                    "날짜",
                    selection: $store.targetDate.sending(\.dateChanged),
                    displayedComponents: [.date]
                )
            }

            Section("위젯 위치") {
                Picker("위치", selection: $store.widgetPosition.sending(\.widgetPositionChanged)) {
                    ForEach(SmallWidgetPosition.allCases, id: \.self) { position in
                        Text(position.displayName).tag(position.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("현재 상태") {
                HStack {
                    Text("D-Day")
                    Spacer()
                    Text(store.ddayDisplayText)
                        .font(.headline)
                        .foregroundStyle(store.daysRemaining <= 0 ? .red : .primary)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DdayView(
        store: Store(initialState: DdayFeature.State(
            targetDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
            title: "생일"
        )) {
            DdayFeature()
        }
    )
}
