//
//  OnBoarding_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/19/24.
//

import SwiftUI

struct OnboardingPageView: View {
	let imageName: String
	let title: String

	var body: some View {
		VStack {
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
				.multilineTextAlignment(.center)
				.padding()
			Spacer()
			Image(imageName)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding(.bottom, 40.0)
		}
	}
}

struct OnboardingLastPageView: View {
	let imageName: String
	let title: String

	@Binding var isFirstLaunching: Bool

	var body: some View {
		VStack {
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
				.multilineTextAlignment(.center)
				.padding()
			Spacer()
			Image(imageName)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding(.bottom, 15.0)
			Button {
				isFirstLaunching.toggle()
			} label: {
				Text("Start")
					.fontWeight(.bold)
					.foregroundColor(.white)
					.frame(width: 200, height: 50)
					.background(Color.blue)
					.cornerRadius(6)
			}
			.padding(.bottom, 40.0)
		}
	}
}

struct OnboardingTabView: View {
	@Binding var isFirstLaunching: Bool

	var body: some View {
		TabView {
			OnboardingPageView(
				imageName: "Tutorial1",
				title: "On your home screen,\ntouch the screen for a second"
			)

			OnboardingPageView(
				imageName: "Tutorial2",
				title: "In edit mode, swipe the screen\nto the right until empty page"
			)

			OnboardingLastPageView(
				imageName: "Tutorial3",
				title: "Capture your screen",
				isFirstLaunching: $isFirstLaunching
			)
		}
		.tabViewStyle(.page)
		.ignoresSafeArea(.all)
		.background(Color.gray)
	}
}

#Preview
{
	@AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
	OnboardingTabView(isFirstLaunching: $isFirstLaunching)
}
