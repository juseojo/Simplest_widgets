//
//  TemperatureBar_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/14/24.
//

import SwiftUI
import WidgetKit

struct TemperatureBar_view: View {
	@State var selected_size = "2 X 2"
	@State var selected_temperature = "normal"
	@State var selected_type = "Vertical"
	@State var selected_position = "1"
	@State var time = "1 Day"

	let model = Model()

	init(selected_size: String = "2 X 2", selected_temperature: String = "normal", selected_type: String = "Vertical", selected_position: String = "1", time: String = "1 Day") {
		if UserDefaults.shared.string(forKey: "widget_position") == nil {
			self.selected_size = "2 X 2"
		}
		else if String(UserDefaults.shared.string(forKey: "widget_position")!.first!) == "2" {
			self.selected_size = "2 X 4"
		}
		
		self.selected_temperature = selected_temperature
		self.selected_type = selected_type
		self.selected_position = selected_position
		self.time = time
	}

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

						if selected_size == "2 X 2"
						{
							// VStack for 2 X 2 widget buttons
							VStack(spacing: 0) {
								HStack(spacing: 0) {
									Widget_button(title: "1", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("11", forKey: "widget_position")
										WidgetCenter.shared.reloadAllTimelines()
									}
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									Widget_button(title: "2", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("12", forKey: "widget_position")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * bazel.top_paddings + widget_inform.top_padding * ratio_num)

								HStack(spacing: 0) {
									Widget_button(title: "3", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("13", forKey: "widget_position")
										WidgetCenter.shared.reloadAllTimelines()
									}
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									Widget_button(title: "4", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("14", forKey: "widget_position")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * widget_inform.bottom_padding)

								HStack(spacing: 0) {
									Widget_button(title: "5", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("15", forKey: "widget_position")
										WidgetCenter.shared.reloadAllTimelines()
									}
									.padding(.trailing, widget_inform.trail_padding * ratio_num)

									Widget_button(title: "6", width: widget_length, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("16", forKey: "widget_position")
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
										UserDefaults.shared.set("21", forKey: "widget_position")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * bazel.top_paddings + widget_inform.top_padding * ratio_num)

								HStack(spacing: 0) {
									Widget_button(title: "2", width: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("22", forKey: "widget_position")
										WidgetCenter.shared.reloadAllTimelines()
									}
								}
								.padding(.top, ratio_num * widget_inform.bottom_padding)

								HStack(spacing: 0) {
									Widget_button(title: "3", width: widget_length * 2.0 + widget_inform.trail_padding * ratio_num, height: widget_length, radius: CGFloat(widget_inform.radius) * ratio_num) {
										UserDefaults.shared.set("23", forKey: "widget_position")
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
						Picker("Options", selection: $selected_size) {
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
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack{
						Text("Time: ")
						Picker("Options", selection: $time) {
							ForEach(["1 Day", "1 Weekend"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack{
						Text("Type: ")
						Picker("Options", selection: $selected_type) {
							ForEach(["Vertical", "Horizon"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
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
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

				}
				.navigationTitle("Temperature Bar")
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
