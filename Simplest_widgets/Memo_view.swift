//
//  Memo_view.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 1/9/25.
//

import SwiftUI

import CoreData
import WidgetKit

struct Memo_view: View {
	@AppStorage("memo widget position", store: UserDefaults.shared) var selected_widget_position: String = "00"
	@AppStorage("memo type", store: UserDefaults.shared) var selected_type: String = "Horizon"
	@AppStorage("memo position", store: UserDefaults.shared) var selected_position: String = "1"
	@State var selected_box: String = "2 X 2"
	@State var isPresented = false
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
						Text("Type: ")
						Picker("Options", selection: $selected_type) {
							ForEach(["Horizon", "Vertical"], id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.segmented)
						.onChange(of: selected_type) { newValue in
							print("changed to: \(newValue)")
							UserDefaults.shared.set(newValue, forKey: "memo type")
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
							UserDefaults.shared.set(newValue, forKey: "memo position")
							WidgetCenter.shared.reloadAllTimelines()
						}
					}
					.padding(.horizontal, 30.0)
					.padding(.bottom, 15.0)

				}
				.navigationTitle("Memo")
				.toolbar {
					/*
					Button {} label: {
						Image(systemName: "folder")
					}
					.fullScreenCover(isPresented: $isPresented) {
							Memo_view()
						}
					 */
					NavigationLink(destination: Memo_storage()) {
						Image(systemName: "folder")
					}
				}
			}
			.onAppear {
				if UserDefaults.shared.string(forKey: "memo widget position") == nil {
					self.selected_box = "2 X 2"
				}
				else if String(UserDefaults.shared.string(forKey: "memo widget position")!.first!) == "2" {
					self.selected_box = "2 X 4"
				}
			}
		}
	}

	@ViewBuilder
	private func widgetItem(position: String, widget_length: CGFloat, widget_height: CGFloat, widget_radius: CGFloat, ratio_num: CGFloat) -> some View {

		if selected_widget_position == position {
			Memo(width: widget_length, height: widget_height)
		} else {
			Widget_button(title: String(position.last!), width: widget_length, height: widget_height, radius: widget_radius * ratio_num) {
				selected_widget_position = position
				WidgetCenter.shared.reloadAllTimelines()
			}
		}
	}
}

struct Memo: View {
	let width: CGFloat
	let height: CGFloat
	let position = UserDefaults.shared.string(forKey: "memo position") ?? "1"

	var body: some View {
		ZStack {
			VStack {
				if position == "1" || position == "2" {
					Spacer()
				}

				HStack {
					Image(systemName: "pencil.and.list.clipboard").foregroundStyle(.white).padding(.leading, 15)
					Spacer()
					Image(systemName: "microphone").foregroundStyle(.white).padding(.trailing, 15)
				}

				if position == "3" || position == "2" {
					Spacer()
				}
			}
			.frame(width: width, height: height)
			.cornerRadius(30)
		}
	}
}

struct Memo_storage: View {
	@State var isWriting: Bool = false
	@State var text: String = ""
	@FocusState private var isTextFieldFocused: Bool

	@Environment(\.managedObjectContext) var viewContext
	@FetchRequest(
		entity: Memos.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \Memos.date, ascending: false)]
	  )
	private var memos: FetchedResults<Memos>
	var link_type = "none"

	var body: some View {
		VStack {
			HStack {
				Text("Memo storage")
					.font(.largeTitle)
					.bold()
					.padding(.leading, 20)
					.padding(.top, 20)
				Spacer()
			}

			// Open text field, and save text
			if isWriting {
				TextField("Enter your memo", text: $text)
					.transition(.move(edge: .top))
					.focused($isTextFieldFocused)
					.padding(.horizontal, 20)
					.onSubmit {
						if text == "" || text.isEmpty {
							return
						}
						do {
							let memo = Memos(context: viewContext)
							memo.date = Date()
							memo.text = text
							try viewContext.save()
						} catch {
							print("memo save error")
						}

						isWriting = false
						text = ""
					}
				Divider()
					.transition(.opacity)
					.background(Color.black)
					.padding(.horizontal, 10)
			}

			// No memo case
			if memos.isEmpty {
				Spacer()
				ZStack {
					Color(.secondarySystemBackground)

					Text("Memo is empty.")
				}
				.frame(width: 200, height: 50)
				.cornerRadius(10)
				Spacer()
			}
			else {
				List {
					ForEach(memos) { data in
						HStack {
							Text(data.text ?? "memo text error").textSelection(.enabled)
							Spacer()
							Text(date_Localize(date: data.date))
								.font(.caption)
								.foregroundColor(Color.gray)
								.multilineTextAlignment(.trailing)
						}
					}
				}
				.listStyle(.plain)
			}
		}
		.toolbar {
			Button {
				withAnimation(.easeInOut) {
					isWriting.toggle()
					isTextFieldFocused.toggle()
				}
			} label: {
				Image(systemName: "pencil.and.list.clipboard")
			}
			Button {
				withAnimation(.easeInOut) {
					isWriting.toggle()
					isTextFieldFocused.toggle()
				}
			} label: {
				Image(systemName: "microphone")
			}
			Button {} label: {
				Image(systemName: "trash")
			}
		}
		.onAppear() {
			print(Locale.current.identifier)

			if link_type == "write"
			{
				withAnimation(.easeInOut) {
					isWriting.toggle()
					isTextFieldFocused.toggle()
				}
			}
			else if link_type == "mic"
			{
				print("mic")
			}
		}
	}
}

#Preview {
	Memo_view()
}
