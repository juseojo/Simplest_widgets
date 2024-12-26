//
//  ContentView.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI

struct Get_homeScreen_view: View {
	@State private var isPickerPresented = false
	@State private var isFinished = false
	@State private var selectedImageData: Data?
	@State private var toast_value = false

	var isFirst: Bool
	private var shouldShow_mainView: Binding<Bool> {
		Binding(
			get: { isFinished && isFirst },
			set: { isFinished = $0 }
		)
	}

	var body: some View {
		ZStack {
			VStack {
				Text("Simplest Widgets")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding(.top, 40.0)
				Text("Choice your home screen")
					.font(.title2)
					.fontWeight(.semibold)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
				Button(action: {
					print("Choice home screen button click")
					isPickerPresented = true
				}, label: {
					Image("Choice home screen")
						.resizable()
						.aspectRatio(contentMode: .fit)
				})
				.sheet(isPresented: $isPickerPresented) {
					PhotoPicker(selectedImageData: $selectedImageData) {
						print("choose image")
						if self.selectedImageData != nil
						{
							let images_manager = Images_manager()

							self.isFinished = true

							// menu's button click case
							if isFirst == false {
								self.toast_value = true
								// for closing toast
								DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
									self.toast_value = false
								}
							}
							print(images_manager.save_image(data: selectedImageData!, name: "Home_screen"))
						}
					}
				}
				.fullScreenCover(isPresented: shouldShow_mainView) {
					Main_view()
				}
			}.padding(.bottom, 20)

			// toast message case
			if !isFirst && isFinished && toast_value
			{
				VStack {
					Text("Change success!")
						.padding()
						.background(Color.gray.opacity(0.4))
						.foregroundColor(.black)
						.cornerRadius(10)
						.shadow(radius: 10)
				}
				.animation(.easeInOut(duration: 1), value: toast_value)
			}
		}
	}
}

struct Main_view: View {
	var body: some View {
		NavigationStack {
			ScrollView() {
				VStack(spacing: 0) {
					Text("Simplest Widgets")
						.font(.largeTitle)
						.fontWeight(.bold)
						.padding(.top, 40.0)
					Text("Go to home screen\n and add widget")
						.font(.title2)
						.fontWeight(.semibold)
						.foregroundColor(Color.gray)
						.multilineTextAlignment(.center)
						.padding(.top, 10.0)
					Spacer()

					let widgets = ["Temperature Bar", "Memo", "D - Day", "Change Image"]

					// widget buttons
					ForEach(0..<widgets.count) { num in
						NavigationLink(value: widgets[num]) {
							ZStack {
								Image(widgets[num])
									.resizable()
									.frame(width: UIScreen.main.bounds.width - 70, height: 125)
									.cornerRadius(10)
								Text(widgets[num])
									.font(.largeTitle)
									.fontWeight(.bold)
									.foregroundColor(Color.white)
									.shadow(radius: 2, x: 4, y: 4)
							}
						}.padding(.vertical, 10.0)
					}.navigationDestination(for: String.self) { destination in
						if destination == "Temperature Bar" {
							TemperatureBar_view()
						}
						else if destination == "Memo" {

						}
						else if destination == "D - Day" {

						}
						else if destination == "Change Image" {
							Get_homeScreen_view(isFirst: false)
						}
					}
				}
			}
		}
	}
}

struct ContentView: View {

	@AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true

	var body: some View {
		if UserDefaults.standard.data(forKey: "HomeScreen_imageData") == nil
		{
			Get_homeScreen_view(isFirst: true)
				.fullScreenCover(isPresented: $isFirstLaunching) {
					OnboardingTabView(isFirstLaunching: $isFirstLaunching)
				}
		}
		else {
			Main_view()
		}
	}
}

#Preview {
    ContentView()
}


extension UserDefaults {
	static var shared: UserDefaults {
		let appGroupId = "group.simplest_widgets"

		return UserDefaults(suiteName: appGroupId)!
	}
}

