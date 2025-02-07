//
//  Memo_widget.swift
//  Memo_widget
//
//  Created by seongjun cho on 1/9/25.
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
		let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .atEnd)

		completion(timeline)
	}
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Memo_widgetEntryView : View {
	var entry: Provider.Entry
	var homeScreen_image: CGImage?
	var widget_position: String
	let position: String
	let color: Color
	let type: String

	init(entry: SimpleEntry) {
		self.widget_position =  UserDefaults.shared.string(forKey: "memo widget position") ?? "00"
		self.homeScreen_image = Images_manager().load_image(name: "Home_screen").cgImage
		self.position =  UserDefaults.shared.string(forKey: "memo position") ?? "1"
		self.entry = entry
		self.color = (UserDefaults.shared.string(forKey: "memo color") ?? "White") == "White" ? Color.white : Color.black
		self.type = UserDefaults.shared.string(forKey: "memo type") ?? "Horizon"
	}
	
	var body: some View {
		let model = Model()
		let crop_size = model.get_widget_Rect(position: widget_position)
		let crop_image: CGImage? = homeScreen_image?.cropping(to:crop_size)

		ZStack {
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

			if type == "Horizon"
			{
				VStack {
					if position == "1" || position == "2" {
						Spacer()
					}

					HStack {
						Link(destination: URL(string: "simplestWidgets://widget/Memo_write")!) {
							Image(systemName: "pencil.and.list.clipboard")
								.foregroundStyle(color)
								.font(.system(size: 30))
						}
						Spacer()
						Link(destination: URL(string: "simplestWidgets://widget/Memo_mic")!) {
							Image(systemName: "microphone")
								.foregroundStyle(color)
								.font(.system(size: 30))
						}
					}.padding(.vertical, 10)

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

					VStack {
						Link(destination: URL(string: "simplestWidgets://widget/Memo_write")!) {
							Image(systemName: "pencil.and.list.clipboard")
								.foregroundStyle(color)
								.font(.system(size: 30))
						}
						Spacer()
						Link(destination: URL(string: "simplestWidgets://widget/Memo_mic")!) {
							Image(systemName: "microphone")
								.foregroundStyle(color)
								.font(.system(size: 30))
						}
					}.padding(.vertical, 10)

					if position == "1" || position == "2" {
						Spacer()
					}
				}
			}
		}.widgetURL(URL(string: "simplestWidgets://widget/Memo"))
	}
}

struct Memo_widget: Widget {
    let kind: String = "Memo_widget"

    var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Memo_widgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
		.contentMarginsDisabled()
		.configurationDisplayName("Memo")
		.description("Memo short things")
    }
}

#Preview(as: .systemSmall) {
    Memo_widget()
} timeline: {
    SimpleEntry(date: .now)
}
