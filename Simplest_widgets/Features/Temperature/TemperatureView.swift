//
//  TemperatureView.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import SwiftUI
import ComposableArchitecture

struct TemperatureView: View {
    @Bindable var store: StoreOf<TemperatureFeature>

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
            .navigationTitle("온도 위젯")
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Widget Preview Section

private struct WidgetPreviewSection: View {
    let store: StoreOf<TemperatureFeature>

    var body: some View {
        VStack(spacing: 8) {
            Text("위젯 미리보기")
                .font(.headline)

            // TODO: 실제 온도 바 프리뷰 구현
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.blue, .cyan, .green, .yellow, .orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 80)
                .overlay {
                    Text("온도 바 미리보기")
                        .foregroundStyle(.white)
                        .shadow(radius: 2)
                }
        }
        .padding()
    }
}

// MARK: - Settings Section

private struct SettingsSection: View {
    @Bindable var store: StoreOf<TemperatureFeature>

    var body: some View {
        Form {
            Section("위젯 위치") {
                Picker("위치", selection: $store.widgetPosition.sending(\.widgetPositionChanged)) {
                    ForEach(MediumWidgetPosition.allCases, id: \.self) { position in
                        Text(position.displayName).tag(position.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("온도 단위") {
                Picker("단위", selection: $store.temperatureNotation.sending(\.temperatureNotationChanged)) {
                    ForEach(TemperatureNotation.allCases, id: \.self) { notation in
                        Text(notation.displayName).tag(notation)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("위젯 타입") {
                Picker("타입", selection: $store.widgetType.sending(\.widgetTypeChanged)) {
                    ForEach(TemperatureWidgetType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TemperatureView(
        store: Store(initialState: TemperatureFeature.State()) {
            TemperatureFeature()
        }
    )
}
