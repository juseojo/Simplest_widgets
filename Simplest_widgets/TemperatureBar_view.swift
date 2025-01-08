//
//  TemperatureBar_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI
import WidgetKit

struct TemperatureBar_view: View {
	@AppStorage("temperature widget position", store: UserDefaults.shared) var selected_widget_position: String = "00"
	@AppStorage("temperature notation", store: UserDefaults.shared) var selected_temperature: String = "normal"
	@AppStorage("temperature type", store: UserDefaults.shared) var selected_type: String = "Horizon"
	@AppStorage("temperature position", store: UserDefaults.shared) var selected_position: String = "1"
	@AppStorage("temperature time", store: UserDefaults.shared) var time: String = "1 Day"
	@State var selected_box: String = "2 X 2"

	let model = Model()

	var body: some View {
		let homeScreen_image = Images_manager().load_image(name: "Home_screen")
		let deviceModel_name = get_deviceModel()
		let bazel = model.get_bazel(device_name: deviceModel_name)
		let widget_inform = model.get_widget(device_name: deviceModel_name)
		let bazel_image = UIImage(named: model.iphones_name_dic[deviceModel_name] ?? "error")
		let ratio_num =  (UIScreen.main.bounds.width - 120) / (bazel_image?.size.width)!  // (screen width - padding) / Bazel image width
		let widget_length = CGFloat(widget_inform.length) * ratio_num

		NavigationView {
			ScrollView() {
				VStack(spacing: 0) {
					ZStack{
						// screen image
						Image(uiImage: homeScreen_image)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.cornerRadius(CGFloat(bazel.radius) * ratio_num)
							.padding(.horizontal, bazel.left_padding * ratio_num) // frame length
							.padding(.vertical, bazel.top_paddings * ratio_num)
						// bazel image
						Image(uiImage: bazel_image ?? UIImage(systemName: "xmark")!)
							.resizable()
							.aspectRatio(contentMode: .fit)

						if selected_box == "2 X 2"
						{
							// VStack for 2 X 2 widget buttons
							VStack(spacing: 0) {
								HStack(spacing: 0) {
									widgetItem(position: "11", widget_length: widget_length, widget_height: widget_length,
											   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									widgetItem(position: "12", widget_length: widget_length, widget_height: widget_length,
											   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
								}
								.padding(.top, ratio_num * bazel.top_paddings + widget_inform.top_padding * ratio_num)

								HStack(spacing: 0) {
									widgetItem(position: "13", widget_length: widget_length, widget_height: widget_length,
											   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									widgetItem(position: "14", widget_length: widget_length, widget_height: widget_length,
											   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
								}
								.padding(.top, ratio_num * widget_inform.bottom_padding)

								HStack(spacing: 0) {
									widgetItem(position: "15", widget_length: widget_length, widget_height: widget_length,
											   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									widgetItem(position: "16", widget_length: widget_length, widget_height: widget_length,
											   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
								}
								.padding(.top, ratio_num * widget_inform.bottom_padding)
								Spacer()
							}
						}
						else {
							// VStack for 2 X 4 widget buttons
							VStack(spacing: 0) {
								widgetItem(position: "21", widget_length: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, widget_height: widget_length,
										   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
								.padding(.top, ratio_num * bazel.top_paddings + widget_inform.top_padding * ratio_num)

								widgetItem(position: "22", widget_length: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, widget_height: widget_length,
										   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
								.padding(.top, ratio_num * widget_inform.bottom_padding)

								widgetItem(position: "23", widget_length: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, widget_height: widget_length,
										   widget_radius: CGFloat(widget_inform.radius), ratio_num: ratio_num)
								.padding(.top, ratio_num * widget_inform.bottom_padding)
								Spacer()
							}
						}
					}
					.padding(.horizontal, 60)

					Text("Choice your widget's option")
						.padding(.vertical, 20)

					HStack{
						Text("Size: ")
						Picker("Options", selection: $selected_box) {
							ForEach(["2 X 2", "2 X 4"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack{
						Text("Temperature: ")
						Picker("Options", selection: $selected_temperature) {
							ForEach(["normal", "diffrence now"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
						.onChange(of: selected_temperature) { newValue in
							print("changed to: \(newValue)")
							UserDefaults.shared.set(newValue, forKey: "temperature notation")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack{
						Text("Time: ")
						Picker("Options", selection: $time) {
							ForEach(["1 Day", "1 Week"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
						.onChange(of: time) { newValue in
							print("changed to: \(newValue)")
							UserDefaults.shared.set(newValue, forKey: "temperature time")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack{
						Text("Type: ")
						Picker("Options", selection: $selected_type) {
							ForEach(["Horizon", "Vertical"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
						.onChange(of: selected_type) { newValue in
							print("changed to: \(newValue)")
							UserDefaults.shared.set(newValue, forKey: "temperature type")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack{
						Text("Position: ")
						Picker("Options", selection: $selected_position) {
							ForEach(["1", "2", "3"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
						.onChange(of: selected_position) { newValue in
							print("changed to: \(newValue)")
							UserDefaults.shared.set(newValue, forKey: "temperature position")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

				}
				.navigationTitle("Temperature Bar")
			}
			.onAppear {
				if UserDefaults.shared.string(forKey: "temperature widget position") == nil {
					self.selected_box = "2 X 2"
				}
				else if String(UserDefaults.shared.string(forKey: "temperature widget position")!.first!) == "2" {
					self.selected_box = "2 X 4"
				}
			}
		}
	}

	@ViewBuilder
	private func widgetItem(position: String, widget_length: CGFloat, widget_height: CGFloat, widget_radius: CGFloat, ratio_num: CGFloat) -> some View {

		if selected_widget_position == position {
			TemperatureBar(width: widget_length, height: widget_height)
		} else {
			Widget_button(title: String(position.last!), width: widget_length, height: widget_height, radius: widget_radius * ratio_num) {
				selected_widget_position = position
				WidgetCenter.shared.reloadAllTimelines()
			}
		}
	}
}

struct Widget_button: View {
	let title: String
	let width: CGFloat
	let height: CGFloat
	let radius: CGFloat
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Text(title)
				.frame(width: width, height: height, alignment: .center)
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

struct TemperatureBar: View {
	let width: CGFloat
	let height: CGFloat
	let position = UserDefaults.shared.string(forKey: "temperature position") ?? "1"

	var body: some View {
		ZStack {
			if UserDefaults.shared.string(forKey: "temperature type") ?? "Horizon" == "Horizon"
			{
				VStack {
					if position == "1" || position == "2" {
						Spacer()
					}

					Rectangle()
						.fill(Color.red)
						.frame(width: width, height: 10)
						.cornerRadius(30)
						.padding(.horizontal, 10)

					if position == "3" || position == "2" {
						Spacer()
					}
				}
			}
			else
			{
				HStack {
					if position == "3" || position == "2" {
						Spacer()
					}

					Rectangle()
						.fill(Color.blue)
						.frame(width: 10, height: height)
						.cornerRadius(30)
						.padding(.horizontal, 10)

					if position == "1" || position == "2" {
						Spacer()
					}
				}
			}
		}
		.frame(width: width, height: height)
		.cornerRadius(30)
	}
}

#Preview {
	TemperatureBar_view()
}
