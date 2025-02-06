//
//  Dday_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 2/6/25.
//

import SwiftUI

import CoreData
import WidgetKit

struct Dday_view: View {
	@AppStorage("Dday widget position", store: UserDefaults.shared) var selected_widget_position: String = "00"
	@AppStorage("Dday position", store: UserDefaults.shared) var selected_position: String = "1"
	@AppStorage("Dday color", store: UserDefaults.shared) var selected_color: String = "White"
	@AppStorage("Dday date", store: UserDefaults.shared) var selected_date: String = date_to_str(Date())!
	// iOS 18.0 < version can save Date at UserDefault

	@State var selected_box: String = "2 X 2"
	@State var isPresented = false
	@State var dday_date = Date()

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
						Text("Position: ")
						Picker("Options", selection: $selected_position) {
							ForEach(["1", "2"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
						.onChange(of: selected_position) { newValue in
							print("changed to: \(newValue)")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack{
						Text("Color: ")
						Picker("Options", selection: $selected_color) {
							ForEach(["White", "Black"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
						.onChange(of: selected_color) { newValue in
							print("changed to: \(newValue)")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

					HStack {
						Text("D-day: ")
						DatePicker("", selection: $dday_date, displayedComponents: [.date])
						.onChange(of: dday_date) { newValue in
							print("changed to: \(newValue.description)")
							UserDefaults.shared.set(date_to_str(newValue), forKey: "Dday date")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)
				}
				.navigationTitle("D-day")
			}
			.onAppear {
				if UserDefaults.shared.string(forKey: "Dday widget position") == nil {
					self.selected_box = "2 X 2"
				}
				else if String(UserDefaults.shared.string(forKey: "Dday widget position")!.first!) == "2" {
					self.selected_box = "2 X 4"
				}

				dday_date = str_to_date(selected_date) ?? Date()
			}
		}
	}

	@ViewBuilder
	private func widgetItem(position: String, widget_length: CGFloat, widget_height: CGFloat, widget_radius: CGFloat, ratio_num: CGFloat) -> some View {

		if selected_widget_position == position {
			Dday(width: widget_length, height: widget_height, dday: dday_date)
		} else {
			Widget_button(title: String(position.last!), width: widget_length, height: widget_height, radius: widget_radius * ratio_num) {
				selected_widget_position = position
				WidgetCenter.shared.reloadAllTimelines()
			}
		}
	}
}

// Dday_view's subView
struct Dday: View {
	let width: CGFloat
	let height: CGFloat
	let position = UserDefaults.shared.string(forKey: "Dday position") ?? "1"
	let color: Color = (UserDefaults.shared.string(forKey: "Dday color") ?? "White") == "White" ? Color.white : Color.black
	let dday: Date

	var body: some View {
		let dday_num = calculate_dday(date: dday)

		let text: String = {
			if dday_num < 0 {
				return "D - \(-dday_num)"
			}
			else if dday_num == 0 {
				return "D - day"
			}
			else {
				return "D + \(dday_num)"
			}
		}()


		HStack {
			if position == "2" {
				Spacer()
			}

			VStack {
				Spacer()
				Text(text)
					.font(.title)
					.fontWeight(.bold)
					.foregroundStyle(color)
			}.padding(.bottom, 15)

			if position == "1" {
				Spacer()
			}
		}
		.frame(width: width, height: height)
		.cornerRadius(30)
	}
}

func calculate_dday(date: Date) -> Int
{
	let calendar = Calendar.current
	let startDate = calendar.startOfDay(for: date)
	let startToday = calendar.startOfDay(for: Date())
	let components = calendar.dateComponents([.day], from: startDate, to: startToday)

	return components.day ?? 0
}

#Preview {
	Dday_view()
}
