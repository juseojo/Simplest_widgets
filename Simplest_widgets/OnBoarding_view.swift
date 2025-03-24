//
//  OnBoarding_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/19/24.
//

import SwiftUI

struct OnboardingFirstPageView: View {
	let title: String

	var body: some View {
		VStack {
			if #available(iOS 18.0, *) {
				Image(systemName: "hand.wave.fill")
					.resizable(resizingMode: .tile)
					.foregroundColor(Color.white)
					.frame(width: 100.0, height: 100.0)
					.symbolEffect(.wiggle, options: .speed(0.5))
			}
			else {
				Image(systemName: "hand.wave.fill")
					.resizable(resizingMode: .tile)
					.foregroundColor(Color.white)
					.frame(width: 100.0, height: 100.0)
			}
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
				.multilineTextAlignment(.center)
				.padding()
		}
	}
}

struct OnboardingPageView: View {
	let imageName: String
	let title: String
	let deviceModel_name = get_deviceModel()
	let model = Model()

	var body: some View {
		let bazel_image = UIImage(named: model.iphones_name_dic[deviceModel_name] ?? "error") ?? UIImage(systemName: "xmark")!
		let bazel = model.get_bazel(device_name: deviceModel_name)
		let ratio_num =  (UIScreen.main.bounds.width - 100) / bazel_image.size.width

		VStack {
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
				.multilineTextAlignment(.center)
				.padding()
			Spacer()
			ZStack {
				Image(imageName)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(CGFloat(bazel.radius) * ratio_num)
					.padding(.horizontal, bazel.left_padding * ratio_num) // frame length
					.padding(.vertical, bazel.top_paddings * ratio_num)
				Image(uiImage: bazel_image)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}
			.padding(.bottom, 40.0)
			.padding(.horizontal, 50.0)
		}
	}
}

struct OnboardingLastPageView: View {
	let imageName: String
	let title: String
	let deviceModel_name = get_deviceModel()
	let model = Model()


	@Binding var isFirstLaunching: Bool

	var body: some View {
		let bazel_image = UIImage(named: model.iphones_name_dic[deviceModel_name] ?? "error") ?? UIImage(systemName: "xmark")!
		let bazel = model.get_bazel(device_name: deviceModel_name)
		let ratio_num =  (UIScreen.main.bounds.width - 100) / bazel_image.size.width

		VStack {
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
				.multilineTextAlignment(.center)
				.padding()
			Spacer()
			ZStack {
				Image(imageName)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(CGFloat(bazel.radius) * ratio_num)
					.padding(.horizontal, bazel.left_padding * ratio_num) // frame length
					.padding(.vertical, bazel.top_paddings * ratio_num - 1.0)
				Image(uiImage: bazel_image)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}
			.padding(.bottom, 20.0)
			.padding(.horizontal, 50.0)
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
			OnboardingFirstPageView(
				title: "Hi, 😃\n We need home screen image for clear widget background.\n\n This tutorial can help that.\nthank you 😊"
			)
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
	@Previewable @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
	OnboardingTabView(isFirstLaunching: $isFirstLaunching)
}
