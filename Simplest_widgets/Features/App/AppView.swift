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
                HomeScreenSelectionView(store: store)
            } else {
                // 메인 화면
                MainView(store: store)
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

// MARK: - Main View (기존 Main_view 대체)

struct MainView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        NavigationStack {
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
            .navigationDestination(for: String.self) { destination in
                if destination == "ChangeImage" {
                    HomeScreenSelectionView(store: store)
                }
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

// MARK: - Onboarding View

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPageView(
                imageName: "Tutorial1",
                title: String(localized: "Welcome to Simplest Widgets"),
                description: String(localized: "Simple and beautiful widgets for your home screen")
            )
            .tag(0)

            OnboardingPageView(
                imageName: "Tutorial2",
                title: String(localized: "Choose Your Style"),
                description: String(localized: "Select widget position and customize settings")
            )
            .tag(1)

            OnboardingPageView(
                imageName: "Tutorial3",
                title: String(localized: "Get Started"),
                description: String(localized: "Capture your home screen to begin"),
                showButton: true,
                onButtonTap: onComplete
            )
            .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    var showButton: Bool = false
    var onButtonTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 400)
                .cornerRadius(20)
                .padding(.horizontal, 40)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            if showButton {
                Button(action: {
                    onButtonTap?()
                }) {
                    Text(String(localized: "Get Started"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
            }

            Spacer()
        }
    }
}

// MARK: - Home Screen Selection View

struct HomeScreenSelectionView: View {
    let store: StoreOf<AppFeature>
    @State private var isPickerPresented = false
    @State private var selectedImageData: Data?
    @State private var showToast = false

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
