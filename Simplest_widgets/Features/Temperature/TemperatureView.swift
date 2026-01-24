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
                        SmallTemperatureWidgetGrid(
                            store: store,
                            widgetLength: widgetLength,
                            widgetInfo: widgetInfo,
                            bezel: bezel,
                            ratioNum: ratioNum
                        )
                    } else {
                        MediumTemperatureWidgetGrid(
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
                TemperatureSettingsSection(store: store)
            }
        }
        .navigationTitle(String(localized: "Temperature Bar"))
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Small Widget Grid (2x2)

private struct SmallTemperatureWidgetGrid: View {
    let store: StoreOf<TemperatureFeature>
    let widgetLength: CGFloat
    let widgetInfo: WidgetInfo?
    let bezel: Bezel?
    let ratioNum: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            // Row 1
            HStack(spacing: 0) {
                TemperatureWidgetButton(
                    store: store,
                    position: "11",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                TemperatureWidgetButton(
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
                TemperatureWidgetButton(
                    store: store,
                    position: "13",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                TemperatureWidgetButton(
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
                TemperatureWidgetButton(
                    store: store,
                    position: "15",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                TemperatureWidgetButton(
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

private struct MediumTemperatureWidgetGrid: View {
    let store: StoreOf<TemperatureFeature>
    let widgetLength: CGFloat
    let widgetInfo: WidgetInfo?
    let bezel: Bezel?
    let ratioNum: CGFloat

    var body: some View {
        let mediumWidth = widgetLength * 2.0 + (widgetInfo?.trailPadding ?? 0) * ratioNum

        VStack(spacing: 0) {
            TemperatureWidgetButton(
                store: store,
                position: "21",
                width: mediumWidth,
                height: widgetLength,
                radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
            )
            .padding(.top, ratioNum * (bezel?.topPadding ?? 0) + (widgetInfo?.topPadding ?? 0) * ratioNum)

            TemperatureWidgetButton(
                store: store,
                position: "22",
                width: mediumWidth,
                height: widgetLength,
                radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
            )
            .padding(.top, ratioNum * (widgetInfo?.bottomPadding ?? 0))

            TemperatureWidgetButton(
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

// MARK: - Temperature Widget Button

private struct TemperatureWidgetButton: View {
    let store: StoreOf<TemperatureFeature>
    let position: String
    let width: CGFloat
    let height: CGFloat
    let radius: CGFloat

    var body: some View {
        if store.widgetPosition == position {
            // 선택된 위치 - 온도 바 프리뷰 표시
            TemperatureBarPreview(
                width: width,
                height: height,
                widgetType: store.widgetType,
                innerPosition: store.innerPosition
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

// MARK: - Temperature Bar Preview

private struct TemperatureBarPreview: View {
    let width: CGFloat
    let height: CGFloat
    let widgetType: WidgetOrientationType
    let innerPosition: WidgetInnerPosition

    var body: some View {
        ZStack {
            if widgetType == .horizon {
                VStack {
                    if innerPosition == .position1 || innerPosition == .position2 {
                        Spacer()
                    }

                    Rectangle()
                        .fill(Color.red)
                        .frame(width: width, height: 10)
                        .cornerRadius(30)
                        .padding(.horizontal, 10)

                    if innerPosition == .position3 || innerPosition == .position2 {
                        Spacer()
                    }
                }
            } else {
                HStack {
                    if innerPosition == .position3 || innerPosition == .position2 {
                        Spacer()
                    }

                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 10, height: height)
                        .cornerRadius(30)
                        .padding(.horizontal, 10)

                    if innerPosition == .position1 || innerPosition == .position2 {
                        Spacer()
                    }
                }
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(30)
    }
}

// MARK: - Settings Section

private struct TemperatureSettingsSection: View {
    @Bindable var store: StoreOf<TemperatureFeature>

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

            // Temperature notation
            HStack {
                Text("Temperature: ")
                Picker("Temperature", selection: $store.notation.sending(\.notationChanged)) {
                    ForEach(TemperatureNotationType.allCases, id: \.self) { notation in
                        Text(notation.localizedName).tag(notation)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 30)

            // Time range
            HStack {
                Text("Time: ")
                Picker("Time", selection: $store.timeRange.sending(\.timeRangeChanged)) {
                    ForEach(TemperatureTimeRange.allCases, id: \.self) { time in
                        Text(time.localizedName).tag(time)
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
        }
        .padding(.bottom, 15)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TemperatureView(
            store: Store(initialState: TemperatureFeature.State()) {
                TemperatureFeature()
            }
        )
    }
}
