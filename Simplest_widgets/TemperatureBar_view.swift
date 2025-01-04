//
//  TemperatureBar_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI
import WidgetKit

struct TemperatureBar_view: View {
	@AppStorage("temperature size", store: UserDefaults.shared) var selected_size: String = "00"
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
									Widget_button(title: "1", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("11", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									Widget_button(title: "2", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("12", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * bazel.top_paddings + widget_inform.top_padding * ratio_num)

								HStack(spacing: 0) {
									Widget_button(title: "3", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("13", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									Widget_button(title: "4", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("14", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * widget_inform.bottom_padding)

								HStack(spacing: 0) {
									Widget_button(title: "5", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("15", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									Widget_button(title: "6", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("16", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * widget_inform.bottom_padding)
								Spacer()
							}
						}
						else {
							// VStack for 2 X 4 widget buttons
							VStack(spacing: 0) {
								HStack(spacing: 0) {
									Widget_button(title: "1", width: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("21", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * bazel.top_paddings + widget_inform.top_padding * ratio_num)

								HStack(spacing: 0) {
									Widget_button(title: "2", width: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("22", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * widget_inform.bottom_padding)

								HStack(spacing: 0) {
									Widget_button(title: "3", width: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("23", forKey: "temperature size")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
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
				if UserDefaults.shared.string(forKey: "temperature size") == nil {
					self.selected_box = "2 X 2"
				}
				else if String(UserDefaults.shared.string(forKey: "temperature size")!.first!) == "2" {
					self.selected_box = "2 X 4"
				}
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

#Preview {
	TemperatureBar_view()
}
