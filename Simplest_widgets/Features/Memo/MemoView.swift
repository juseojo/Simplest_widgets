//
//  MemoView.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import SwiftUI
import ComposableArchitecture

struct MemoView: View {
    @Bindable var store: StoreOf<MemoFeature>

    var body: some View {
        NavigationStack {
            VStack {
                // 위젯 프리뷰 영역
                WidgetPreviewSection(store: store)

                Divider()

                // 설정 영역
                SettingsSection(store: store)

                Divider()

                // 메모 저장소 영역
                MemoStorageSection(store: store)
            }
            .navigationTitle("메모 위젯")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.startWriting)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $store.isWriting.sending(\.startWriting).animation()) {
                MemoInputSheet(store: store)
            }
            .alert("오류", isPresented: .constant(store.errorMessage != nil)) {
                Button("확인") {
                    store.send(.clearError)
                }
            } message: {
                Text(store.errorMessage ?? "")
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Widget Preview Section

private struct WidgetPreviewSection: View {
    let store: StoreOf<MemoFeature>

    var body: some View {
        VStack(spacing: 8) {
            Text("위젯 미리보기")
                .font(.headline)

            // TODO: 실제 위젯 프리뷰 구현
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .overlay {
                    VStack {
                        ForEach(store.memos.prefix(3)) { memo in
                            Text(memo.text)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
        }
        .padding()
    }
}

// MARK: - Settings Section

private struct SettingsSection: View {
    @Bindable var store: StoreOf<MemoFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("설정")
                .font(.headline)

            HStack {
                Text("위젯 위치")
                Spacer()
                Picker("위치", selection: $store.widgetPosition.sending(\.widgetPositionChanged)) {
                    ForEach(SmallWidgetPosition.allCases, id: \.self) { position in
                        Text(position.displayName).tag(position.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }

            HStack {
                Text("위젯 타입")
                Spacer()
                Picker("타입", selection: $store.widgetType.sending(\.widgetTypeChanged)) {
                    ForEach(MemoWidgetType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding()
    }
}

// MARK: - Memo Storage Section

private struct MemoStorageSection: View {
    @Bindable var store: StoreOf<MemoFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("저장된 메모")
                    .font(.headline)
                Spacer()
                Text("\(store.memos.count)개")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if store.memos.isEmpty {
                ContentUnavailableView(
                    "메모가 없습니다",
                    systemImage: "note.text",
                    description: Text("+ 버튼을 눌러 메모를 추가하세요")
                )
            } else {
                List {
                    ForEach(store.memos) { memo in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(memo.text)
                                .lineLimit(2)
                            Text(memo.date.localizedString())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        store.send(.deleteMemo(indexSet))
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Memo Input Sheet

private struct MemoInputSheet: View {
    @Bindable var store: StoreOf<MemoFeature>
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("메모를 입력하세요", text: $store.inputText.sending(\.inputTextChanged), axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5...10)
                    .focused($isFocused)

                HStack {
                    Button {
                        if store.isRecording {
                            store.send(.stopRecording)
                        } else {
                            store.send(.startRecording)
                        }
                    } label: {
                        Image(systemName: store.isRecording ? "mic.fill" : "mic")
                            .foregroundStyle(store.isRecording ? .red : .primary)
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("저장") {
                        store.send(.saveMemo)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("새 메모")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        store.send(.cancelWriting)
                    }
                }
            }
            .onAppear {
                isFocused = true
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Preview

#Preview {
    MemoView(
        store: Store(initialState: MemoFeature.State(
            memos: [
                Memo(text: "테스트 메모 1", date: Date()),
                Memo(text: "테스트 메모 2", date: Date().addingTimeInterval(-3600))
            ]
        )) {
            MemoFeature()
        }
    )
}
