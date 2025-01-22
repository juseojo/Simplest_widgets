//
//  ContentView.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI
import WidgetKit
import CoreLocation

struct Get_homeScreen_view: View {
	@State private var isPickerPresented = false
	@State private var selectedImageData: Data?
	@State private var toast_value = false
	@State private var isFirst = false
	@Binding var hasImage: Bool

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

							// menu's button click case
							if hasImage {
								self.toast_value = true
								// for closing toast
								DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
									self.toast_value = false
								}
							} else {
								isFirst = true
							}
							print(images_manager.save_image(data: selectedImageData!, name: "Home_screen"))
							WidgetCenter.shared.reloadAllTimelines()
							self.hasImage = true
						}
					}
				}
				.fullScreenCover(isPresented: $isFirst) { // first : false -> true, other : false
					Main_view(hasImage: $hasImage)
				}
			}.padding(.bottom, 20)

			// toast message case
			if hasImage && toast_value
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
	@Binding var hasImage: Bool

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
							Memo_view()
						}
						else if destination == "D - Day" {

						}
						else if destination == "Change Image" {
							Get_homeScreen_view(hasImage: $hasImage)
						}
					}
				}
			}
		}
		.onAppear() {
			let locationManager = CLLocationManager()
			let authorizationStatus = locationManager.authorizationStatus

			if authorizationStatus == .authorizedAlways {
				print("always ok")
			}
			else if authorizationStatus == .authorizedWhenInUse {
				print("use ok")
			}
			else if authorizationStatus == .denied {
				// move to app setting
				DispatchQueue.main.async {
					UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
				}
			}
			else if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
				// request auth
				print("request")
				locationManager.requestWhenInUseAuthorization()
			}
		}
	}
}

struct ContentView: View {

	@AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
	@AppStorage("hasImage") var hasImage: Bool = false
	@State private var link_id: String? // widget's deep link

	var body: some View {
		NavigationView {
			if link_id != nil
			{
				if link_id! == "Temperature" {
					TemperatureBar_view()
				}
				else if link_id! == "Memo" {
					Memo_view()
				}
				else if link_id! == "D - Day" {

				}
			}
			else if hasImage == false
			{
				Get_homeScreen_view(hasImage: $hasImage)
					.fullScreenCover(isPresented: $isFirstLaunching) {
						OnboardingTabView(isFirstLaunching: $isFirstLaunching)
					}
			}
			else {
				Main_view(hasImage: $hasImage)
			}
		}
		.onOpenURL { url in
			print(url)
			guard url.scheme == "simplestWidgets", url.host == "widget" else {
				print("widget url is not valid")
				return
			}

			if let id = url.pathComponents.last {
				link_id = id
			}
		}
	}
}


#Preview {
    ContentView()
}
