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
        let deviceModel = DeviceRepository.getCurrentDeviceModel()
        let bezel = DeviceRepository.getBezel(for: deviceModel)
        let widgetInfo = DeviceRepository.getWidgetInfo(for: deviceModel)
        let deviceImageName = DeviceRepository.iphoneNameDictionary[deviceModel] ?? "error"
        let bezelImage = UIImage(named: deviceImageName)
        let homeScreenImage = Images_manager().load_image(name: "Home_screen")

        let ratioNum = (UIScreen.main.bounds.width - 120) / (bezelImage?.size.width ?? 1)
        let widgetLength = CGFloat(widgetInfo?.length ?? 0) * ratioNum

        ScrollView {
            VStack(spacing: 0) {
                // 위젯 프리뷰 영역
                ZStack {
                    // 홈 화면 이미지
                    Image(uiImage: homeScreenImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(CGFloat(bezel?.radius ?? 0) * ratioNum)
                        .padding(.horizontal, (bezel?.leftPadding ?? 0) * ratioNum)
                        .padding(.vertical, (bezel?.topPadding ?? 0) * ratioNum)

                    // 베젤 이미지
                    if let bezelImage = bezelImage {
                        Image(uiImage: bezelImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    // 위젯 버튼 그리드
                    if store.selectedSize == .small {
                        SmallWidgetGrid(
                            store: store,
                            widgetLength: widgetLength,
                            widgetInfo: widgetInfo,
                            bezel: bezel,
                            ratioNum: ratioNum
                        )
                    } else {
                        MediumWidgetGrid(
                            store: store,
                            widgetLength: widgetLength,
                            widgetInfo: widgetInfo,
                            bezel: bezel,
                            ratioNum: ratioNum
                        )
                    }
                }
                .padding(.horizontal, 60)

                // 설정 영역
                SettingsSection(store: store)
            }
        }
        .navigationTitle(String(localized: "Memo"))
        .toolbar {
            NavigationLink {
                MemoStorageView(store: store)
            } label: {
                Image(systemName: "folder")
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Small Widget Grid (2x2)

private struct SmallWidgetGrid: View {
    let store: StoreOf<MemoFeature>
    let widgetLength: CGFloat
    let widgetInfo: WidgetInfo?
    let bezel: Bezel?
    let ratioNum: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            // Row 1
            HStack(spacing: 0) {
                WidgetButton(
                    store: store,
                    position: "11",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                WidgetButton(
                    store: store,
                    position: "12",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
            }
            .padding(.top, ratioNum * (bezel?.topPadding ?? 0) + (widgetInfo?.topPadding ?? 0) * ratioNum)

            // Row 2
            HStack(spacing: 0) {
                WidgetButton(
                    store: store,
                    position: "13",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                WidgetButton(
                    store: store,
                    position: "14",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
            }
            .padding(.top, ratioNum * (widgetInfo?.bottomPadding ?? 0))

            // Row 3
            HStack(spacing: 0) {
                WidgetButton(
                    store: store,
                    position: "15",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                WidgetButton(
                    store: store,
                    position: "16",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
            }
            .padding(.top, ratioNum * (widgetInfo?.bottomPadding ?? 0))

            Spacer()
        }
    }
}

// MARK: - Medium Widget Grid (2x4)

private struct MediumWidgetGrid: View {
    let store: StoreOf<MemoFeature>
    let widgetLength: CGFloat
    let widgetInfo: WidgetInfo?
    let bezel: Bezel?
    let ratioNum: CGFloat

    var body: some View {
        let mediumWidth = widgetLength * 2.0 + (widgetInfo?.trailPadding ?? 0) * ratioNum

        VStack(spacing: 0) {
            WidgetButton(
                store: store,
                position: "21",
                width: mediumWidth,
                height: widgetLength,
                radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
            )
            .padding(.top, ratioNum * (bezel?.topPadding ?? 0) + (widgetInfo?.topPadding ?? 0) * ratioNum)

            WidgetButton(
                store: store,
                position: "22",
                width: mediumWidth,
                height: widgetLength,
                radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
            )
            .padding(.top, ratioNum * (widgetInfo?.bottomPadding ?? 0))

            WidgetButton(
                store: store,
                position: "23",
                width: mediumWidth,
                height: widgetLength,
                radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
            )
            .padding(.top, ratioNum * (widgetInfo?.bottomPadding ?? 0))

            Spacer()
        }
    }
}

// MARK: - Widget Button

private struct WidgetButton: View {
    let store: StoreOf<MemoFeature>
    let position: String
    let width: CGFloat
    let height: CGFloat
    let radius: CGFloat

    var body: some View {
        if store.widgetPosition == position {
            // 선택된 위치 - 메모 프리뷰 표시
            MemoPreview(
                width: width,
                height: height,
                widgetType: store.widgetType,
                innerPosition: store.innerPosition,
                color: store.color
            )
        } else {
            // 선택 가능한 버튼
            Button {
                store.send(.widgetPositionChanged(position))
            } label: {
                Text(String(position.last!))
                    .frame(width: width, height: height)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.white, lineWidth: 2)
            )
        }
    }
}

// MARK: - Memo Preview

private struct MemoPreview: View {
    let width: CGFloat
    let height: CGFloat
    let widgetType: WidgetOrientationType
    let innerPosition: WidgetInnerPosition
    let color: WidgetColorType

    var body: some View {
        ZStack {
            if widgetType == .horizon {
                VStack {
                    if innerPosition == .position1 || innerPosition == .position2 {
                        Spacer()
                    }

                    HStack {
                        Image(systemName: "pencil.and.list.clipboard")
                            .foregroundStyle(color.color)
                            .padding(.leading, 15)
                        Spacer()
                        Image(systemName: "microphone")
                            .foregroundStyle(color.color)
                            .padding(.trailing, 15)
                    }
                    .padding(.bottom, 10)

                    if innerPosition == .position3 || innerPosition == .position2 {
                        Spacer()
                    }
                }
                .frame(width: width, height: height)
                .cornerRadius(30)
            } else {
                HStack {
                    if innerPosition == .position3 || innerPosition == .position2 {
                        Spacer()
                    }

                    VStack {
                        Image(systemName: "pencil.and.list.clipboard")
                            .foregroundStyle(color.color)
                            .padding(.top, 15)
                        Spacer()
                        Image(systemName: "microphone")
                            .foregroundStyle(color.color)
                            .padding(.bottom, 15)
                    }
                    .padding(.bottom, 10)

                    if innerPosition == .position1 || innerPosition == .position2 {
                        Spacer()
                    }
                }
                .frame(width: width, height: height)
                .cornerRadius(30)
            }
        }
    }
}

// MARK: - Settings Section

private struct SettingsSection: View {
    @Bindable var store: StoreOf<MemoFeature>

    var body: some View {
        VStack(spacing: 15) {
            Text("Choice your widget's option")
                .padding(.vertical, 20)

            // Size
            HStack {
                Text("Size: ")
                Picker("Size", selection: $store.selectedSize.sending(\.selectedSizeChanged)) {
                    ForEach(WidgetSizeType.allCases, id: \.self) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 30)

            // Type
            HStack {
                Text("Type: ")
                Picker("Type", selection: $store.widgetType.sending(\.widgetTypeChanged)) {
                    ForEach(WidgetOrientationType.allCases, id: \.self) { type in
                        Text(type.localizedName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 30)

            // Position
            HStack {
                Text("Position: ")
                Picker("Position", selection: $store.innerPosition.sending(\.innerPositionChanged)) {
                    ForEach(WidgetInnerPosition.allCases, id: \.self) { position in
                        Text(position.displayName).tag(position)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 30)

            // Color
            HStack {
                Text("Color: ")
                Picker("Color", selection: $store.color.sending(\.colorChanged)) {
                    ForEach(WidgetColorType.allCases, id: \.self) { color in
                        Text(color.localizedName).tag(color)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 15)
    }
}

// MARK: - Memo Storage View

struct MemoStorageView: View {
    @Bindable var store: StoreOf<MemoFeature>
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Memo storage")
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading, 20)
                        .padding(.top, 20)
                    Spacer()
                }

                // 텍스트 입력 필드
                if store.isWriting {
                    TextField("Enter your memo", text: $store.inputText.sending(\.inputTextChanged))
                        .transition(.move(edge: .top))
                        .focused($isTextFieldFocused)
                        .padding(.horizontal, 20)
                        .onSubmit {
                            store.send(.saveMemo)
                        }

                    Divider()
                        .transition(.opacity)
                        .background(Color.black)
                        .padding(.horizontal, 10)
                }

                // 메모 리스트
                if store.memos.isEmpty {
                    Spacer()
                    ZStack {
                        Color(.secondarySystemBackground)
                        Text("Memo is empty.")
                    }
                    .frame(width: 200, height: 50)
                    .cornerRadius(10)
                    Spacer()
                } else {
                    List {
                        ForEach(store.memos) { memo in
                            HStack {
                                Text(memo.text)
                                    .textSelection(.enabled)
                                Spacer()
                                Text(memo.date.localizedString())
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .onDelete { indexSet in
                            store.send(.deleteMemo(indexSet))
                        }
                    }
                    .listStyle(.plain)
                }
            }

            // 녹음 중 버튼
            if store.isRecording {
                VStack {
                    Spacer()
                    Button {
                        store.send(.stopRecording)
                        store.send(.saveMemo)
                    } label: {
                        Image(systemName: "waveform.badge.microphone")
                            .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing)
                            .foregroundColor(.blue)
                            .font(.system(size: 60))
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .toolbar {
            // 쓰기 버튼
            Button {
                withAnimation(.easeInOut) {
                    store.send(.startWriting)
                    isTextFieldFocused = true
                }
            } label: {
                Image(systemName: "pencil.and.list.clipboard")
            }

            // 녹음 버튼
            Button {
                withAnimation(.easeInOut) {
                    store.send(.startRecording)
                    isTextFieldFocused = true
                }
            } label: {
                Image(systemName: "microphone")
            }
        }
        .onAppear {
            store.send(.fetchMemos)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MemoView(
            store: Store(initialState: MemoFeature.State()) {
                MemoFeature()
            }
        )
    }
}
