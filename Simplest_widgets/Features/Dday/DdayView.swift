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
                        SmallDdayWidgetGrid(
                            store: store,
                            widgetLength: widgetLength,
                            widgetInfo: widgetInfo,
                            bezel: bezel,
                            ratioNum: ratioNum
                        )
                    } else {
                        MediumDdayWidgetGrid(
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
                DdaySettingsSection(store: store)
            }
        }
        .navigationTitle(String(localized: "D-day"))
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Small Widget Grid (2x2)

private struct SmallDdayWidgetGrid: View {
    let store: StoreOf<DdayFeature>
    let widgetLength: CGFloat
    let widgetInfo: WidgetInfo?
    let bezel: Bezel?
    let ratioNum: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            // Row 1
            HStack(spacing: 0) {
                DdayWidgetButton(
                    store: store,
                    position: "11",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                DdayWidgetButton(
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
                DdayWidgetButton(
                    store: store,
                    position: "13",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                DdayWidgetButton(
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
                DdayWidgetButton(
                    store: store,
                    position: "15",
                    width: widgetLength,
                    height: widgetLength,
                    radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
                )
                .padding(.trailing, (widgetInfo?.trailPadding ?? 0) * ratioNum)

                DdayWidgetButton(
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

private struct MediumDdayWidgetGrid: View {
    let store: StoreOf<DdayFeature>
    let widgetLength: CGFloat
    let widgetInfo: WidgetInfo?
    let bezel: Bezel?
    let ratioNum: CGFloat

    var body: some View {
        let mediumWidth = widgetLength * 2.0 + (widgetInfo?.trailPadding ?? 0) * ratioNum

        VStack(spacing: 0) {
            DdayWidgetButton(
                store: store,
                position: "21",
                width: mediumWidth,
                height: widgetLength,
                radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
            )
            .padding(.top, ratioNum * (bezel?.topPadding ?? 0) + (widgetInfo?.topPadding ?? 0) * ratioNum)

            DdayWidgetButton(
                store: store,
                position: "22",
                width: mediumWidth,
                height: widgetLength,
                radius: CGFloat(widgetInfo?.radius ?? 0) * ratioNum
            )
            .padding(.top, ratioNum * (widgetInfo?.bottomPadding ?? 0))

            DdayWidgetButton(
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

// MARK: - D-day Widget Button

private struct DdayWidgetButton: View {
    let store: StoreOf<DdayFeature>
    let position: String
    let width: CGFloat
    let height: CGFloat
    let radius: CGFloat

    var body: some View {
        if store.widgetPosition == position {
            // 선택된 위치 - D-day 프리뷰 표시
            DdayPreview(
                width: width,
                height: height,
                innerPosition: store.innerPosition,
                color: store.color,
                ddayText: store.ddayDisplayText
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

// MARK: - D-day Preview

private struct DdayPreview: View {
    let width: CGFloat
    let height: CGFloat
    let innerPosition: DdayInnerPosition
    let color: WidgetColorType
    let ddayText: String

    var body: some View {
        HStack {
            if innerPosition == .position2 {
                Spacer()
            }

            VStack {
                Spacer()
                Text(ddayText)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(color.color)
            }
            .padding(.bottom, 15)

            if innerPosition == .position1 {
                Spacer()
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(30)
    }
}

// MARK: - Settings Section

private struct DdaySettingsSection: View {
    @Bindable var store: StoreOf<DdayFeature>

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

            // Position (D-day는 1, 2만 지원)
            HStack {
                Text("Position: ")
                Picker("Position", selection: $store.innerPosition.sending(\.innerPositionChanged)) {
                    ForEach(DdayInnerPosition.allCases, id: \.self) { position in
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

            // D-day Date
            HStack {
                Text(String(localized: "D-day: "))
                DatePicker("", selection: $store.targetDate.sending(\.dateChanged), displayedComponents: [.date])
            }
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 15)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DdayView(
            store: Store(initialState: DdayFeature.State()) {
                DdayFeature()
            }
        )
    }
}
