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
				VStack{
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
						VStack{
							HStack{
								Widget_button(title: "1", size: widget_length) {
									UserDefaults.shared.set("11", forKey: "widget_position")
									WidgetCenter.shared.reloadAllTimelines()
								}
								.padding(.trailing, widget_inform.trail_padding * ratio_num)

								Widget_button(title: "2", size: widget_length) {
									UserDefaults.shared.set("12", forKey: "widget_position")
									WidgetCenter.shared.reloadAllTimelines()
								}
							}
							.padding(.top, ratio_num * bazel.top_paddings + widget_inform.top_padding * ratio_num)
							HStack{
								Widget_button(title: "3", size: widget_length) {
									UserDefaults.shared.set("13", forKey: "widget_position")
									WidgetCenter.shared.reloadAllTimelines()
								}
								.padding(.trailing, widget_inform.trail_padding * ratio_num)

								Widget_button(title: "4", size: widget_length) {
									UserDefaults.shared.set("14", forKey: "widget_position")
									WidgetCenter.shared.reloadAllTimelines()
								}
							}
							.padding(.top, ratio_num * widget_inform.bottom_padding)
							HStack{
								Widget_button(title: "5", size: widget_length) {
									UserDefaults.shared.set("15", forKey: "widget_position")
									WidgetCenter.shared.reloadAllTimelines()
								}
								.padding(.trailing, widget_inform.trail_padding * ratio_num)

								Widget_button(title: "6", size: widget_length) {
									UserDefaults.shared.set("16", forKey: "widget_position")
									WidgetCenter.shared.reloadAllTimelines()
								}
							}
							.padding(.top, ratio_num * widget_inform.bottom_padding)
							Spacer()
						}
					}
					.padding(.horizontal, 60)
					.onAppear() {
						print(ratio_num)
						print(UIScreen.main.scale)
						print(UIScreen.main.bounds.width)
						print(homeScreen_image.size.width)
						print(bazel_image!.size)
						print(bazel)
						print(widget_inform)
						print(deviceModel_name)
						print(ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"])
					}
					Text("Choice your widget's option")
					HStack{
						Text("Size: ")
						Picker("Options", selection: $selected_size) {
							ForEach(["2 X 2", "2 X 4"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
					}.padding(.horizontal, 20.0)
					HStack{
						Text("Temperature: ")
						Picker("Options", selection: $selected_temperature) {
							ForEach(["normal", "diffrence now"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
					}.padding(.horizontal, 20.0)
					HStack{
						Text("Type: ")
						Picker("Options", selection: $selected_type) {
							ForEach(["Vertical", "Horizon"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
					}.padding(.horizontal, 20.0)
					HStack{
						Text("Position: ")
						Picker("Options", selection: $selected_position) {
							ForEach(["1", "2", "3"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
					}.padding(.horizontal, 20.0)
				}
				.navigationTitle("Temperature Bar")
			}
		}
	}
}

struct Widget_button: View {
	let title: String
	let size: CGFloat
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Text(title)
				.frame(width: size, height: size, alignment: .center)
		}
		.frame(width: size, height: size)
		.overlay(
			RoundedRectangle(cornerRadius: 21)
				.stroke(Color.gray, lineWidth: 1)
		)
	}
}

#Preview {
	TemperatureBar_view()
}
