//
//  Dday_widget.swift
//  Dday_widget
//
//  Created by seongjun cho on 2/6/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date())
	}

	func getSnapshot(in context: Context, completion: @escaping @Sendable (SimpleEntry) -> Void) {
		completion(SimpleEntry(date: Date()))
	}

	func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<SimpleEntry>) -> Void) {
		let timeline = Timeline(entries: [SimpleEntry(date: Calendar.current.startOfDay(for: Date()))], policy: .atEnd)

		completion(timeline)
	}
}

struct SimpleEntry: TimelineEntry {
	let date: Date
}

struct Dday_widgetEntryView : View {
	var entry: Provider.Entry
	var homeScreen_image: CGImage?
	var widget_position: String
	let position: String
	let color: Color
	let date_str: String

	init(entry: SimpleEntry) {
		self.widget_position =  UserDefaults.shared.string(forKey: "Dday widget position") ?? "00"
		self.homeScreen_image = Images_manager().load_image(name: "Home_screen").cgImage
		self.position =  UserDefaults.shared.string(forKey: "Dday position") ?? "1"
		self.entry = entry
		self.color = (UserDefaults.shared.string(forKey: "Dday color") ?? "White") == "White" ? Color.white : Color.black
		self.date_str = UserDefaults.shared.string(forKey: "Dday date") ?? date_to_str(Date())!
	}

	var body: some View {
		let model = Model()
		let crop_size = model.get_widget_Rect(position: widget_position)
		let crop_image: CGImage? = homeScreen_image?.cropping(to:crop_size)
		let dday = str_to_date(date_str) ?? Date()
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

		ZStack {
			// exceoption control
			if crop_image == nil {
				Text("Please set correct image").padding(.bottom, 10)
			}
			else {
				Image(uiImage: UIImage(cgImage: crop_image!,
									   scale: UIScreen.main.scale,
									   orientation: .up))
				.resizable()
				.renderingMode(.original)
				.scaledToFit()
			}

			// dday
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
			}.padding(.horizontal, 10)
		}.widgetURL(URL(string: "simplestWidgets://widget/Dday"))
	}
}

struct Dday_widget: Widget {
	let kind: String = "dday_widget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			Dday_widgetEntryView(entry: entry)
				.containerBackground(.fill.tertiary, for: .widget)
		}
		.contentMarginsDisabled()
		.configurationDisplayName("D-day")
		.description("Check easily d-day")
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

#Preview(as: .systemSmall) {
	Dday_widget()
} timeline: {
	SimpleEntry(date: .now)
}
