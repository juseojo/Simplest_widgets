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
		var entries: [SimpleEntry] = []

		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate)
			entries.append(entry)
		}
		let timeline = Timeline(entries: entries, policy: .atEnd)

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
	let format = DateFormatter()

	init(entry: SimpleEntry) {
		self.widget_position =  UserDefaults.shared.string(forKey: "temperature widget position") ?? "00"
		self.homeScreen_image = Images_manager().load_image(name: "Home_screen").cgImage
		self.position =  UserDefaults.shared.string(forKey: "temperature position") ?? "1"
		self.entry = entry
		self.format.dateFormat = "yyyy-MM-dd HH:mm:ss"
	}
	
	var body: some View {
		let model = Model()
		let crop_size = model.get_widget_Rect(position: widget_position)
		let crop_image: CGImage? = homeScreen_image?.cropping(to:crop_size)

		ZStack {
			Image(uiImage: UIImage(cgImage: crop_image!,
								   scale: UIScreen.main.scale,
								   orientation: .up))
			.resizable()
			.renderingMode(.original)
			.scaledToFit()

			HStack {
				Link(destination: URL(string: "simplestWidgets://widget/Memo")!) {
					Image(systemName: "pencil.and.list.clipboard")
				}
				Spacer()
				Link(destination: URL(string: "simplestWidgets://widget/Memo")!) {
					Image(systemName: "microphone")
				}
			}
		}
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
    SimpleEntry(date: .now)
}
