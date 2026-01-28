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
            if store.isFirstLaunching {
                // 온보딩 화면
                OnboardingView {
                    store.send(.onboardingCompleted)
                }
            } else if !store.hasHomeScreenImage {
                // 홈 화면 이미지 선택
                NavigationStack {
                    HomeScreenSelectionView(store: store)
                }
            } else {
                // 메인 화면
                MainView(store: store)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Main View (기존 Main_view 대체)

struct MainView: View {
    @Bindable var store: StoreOf<AppFeature>
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Simplest Widgets")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)

                    Text("Go to home screen\n and add widget")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)

                    Spacer()

                    // 위젯 선택 버튼들
                    ForEach(AppTab.allCases, id: \.self) { tab in
                        NavigationLink(value: tab) {
                            WidgetSelectionButton(tab: tab)
                        }
                        .padding(.vertical, 10)
                    }

                    // Change Image 버튼
                    NavigationLink(value: "ChangeImage") {
                        ZStack {
                            Image("Change Image")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 70, height: 125)
                                .cornerRadius(10)
                            Text(String(localized: "Change Image"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(radius: 2, x: 4, y: 4)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationDestination(for: AppTab.self) { tab in
                switch tab {
                case .temperature:
                    TemperatureView(store: store.scope(state: \.temperature, action: \.temperature))
                case .memo:
                    MemoView(store: store.scope(state: \.memo, action: \.memo))
                case .dday:
                    DdayView(store: store.scope(state: \.dday, action: \.dday))
                }
            }
            .navigationDestination(for: MemoDestination.self) { destination in
                MemoStorageViewWithDeepLink(
                    store: store.scope(state: \.memo, action: \.memo),
                    destination: destination
                )
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "ChangeImage" {
                    HomeScreenSelectionView(store: store)
                }
            }
        }
        .onChange(of: store.selectedDestination) { oldValue, newValue in
            // Deep link로 인한 네비게이션 처리
            if let destination = newValue {
                navigationPath.append(destination)
                // 네비게이션 후 selectedDestination 초기화
                store.send(.destinationSelected(nil))
            }
        }
        .onChange(of: store.memoDestination) { oldValue, newValue in
            // Memo 딥링크로 인한 네비게이션 처리
            if let destination = newValue {
                navigationPath.append(destination)
                // 네비게이션 후 memoDestination 초기화
                store.send(.memoDestinationSelected(nil))
            }
        }
    }
}

// MARK: - Widget Selection Button

struct WidgetSelectionButton: View {
    let tab: AppTab

    var body: some View {
        ZStack {
            Image(tab.imageName)
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 70, height: 125)
                .cornerRadius(10)
            Text(tab.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(radius: 2, x: 4, y: 4)
        }
    }
}

// MARK: - Home Screen Selection View

struct HomeScreenSelectionView: View {
    let store: StoreOf<AppFeature>
    @State private var isPickerPresented = false
    @State private var selectedImageData: Data?
    @State private var showToast = false
    @State private var showOnboarding = false

    var body: some View {
        let deviceModel = DeviceRepository.getCurrentDeviceModel()
        let deviceImageName = DeviceRepository.iphoneNameDictionary[deviceModel] ?? "error"
        let bezelImage = UIImage(named: deviceImageName)

        ZStack {
            VStack {
                Text("Simplest Widgets")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Text("Choice your home screen")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                ZStack {
                    Image(systemName: "photo.badge.plus")
                        .foregroundColor(.blue)
                        .font(.system(size: 60))

                    Button {
                        isPickerPresented = true
                    } label: {
                        if let bezelImage = bezelImage {
                            Image(uiImage: bezelImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 25)
                        }
                    }
                }
                .sheet(isPresented: $isPickerPresented) {
                    PhotoPicker(selectedImageData: $selectedImageData) {
                        if let imageData = selectedImageData {
                            let imagesManager = Images_manager()
                            _ = imagesManager.save_image(data: imageData, name: "Home_screen")
                            store.send(.homeScreenImageSet)

                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 20)

            if showToast {
                VStack {
                    Text("Change success!")
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .animation(.easeInOut(duration: 1), value: showToast)
            }
        }
        .toolbar {
            Button {
                showOnboarding = true
            } label: {
                Image(systemName: "questionmark.circle")
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView {
                showOnboarding = false
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State(
            isFirstLaunching: false,
            hasHomeScreenImage: true
        )) {
            AppFeature()
        }
    )
}
