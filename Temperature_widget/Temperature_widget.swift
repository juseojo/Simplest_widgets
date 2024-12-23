//
//  Temperature_widget.swift
//  Temperature_widget
//
//  Created by seongjun cho on 11/16/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 12 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

// return CGRect for croping image
private func get_widget_Rect(position: String) -> CGRect {
	let model = Model()
	let widget_inform = model.get_widget(device_name: get_deviceModel())

	switch position {
	case "11":
		return CGRect(x: widget_inform.lead_padding,
					  y: widget_inform.top_padding,
					  width: CGFloat(widget_inform.length),
					  height: CGFloat(widget_inform.length))
	case "12":
		return CGRect(x: widget_inform.lead_padding + Double(widget_inform.length) + widget_inform.trail_padding,
					  y: widget_inform.top_padding,
					  width: CGFloat(widget_inform.length),
					  height: CGFloat(widget_inform.length))
	case "13":
		return CGRect(x: widget_inform.lead_padding,
					  y: widget_inform.top_padding + Double(widget_inform.length) + widget_inform.bottom_padding,
					  width: CGFloat(widget_inform.length),
					  height: CGFloat(widget_inform.length))
	case "14":
		return CGRect(x: widget_inform.lead_padding + Double(widget_inform.length) + widget_inform.trail_padding,
					  y: widget_inform.top_padding + Double(widget_inform.length) + widget_inform.bottom_padding,
					  width: CGFloat(widget_inform.length),
					  height: CGFloat(widget_inform.length))
	case "15":
		return CGRect(x: widget_inform.lead_padding,
					  y: widget_inform.top_padding + 2.0 * Double(widget_inform.length) + 2 * widget_inform.bottom_padding,
					  width: CGFloat(widget_inform.length),
					  height: CGFloat(widget_inform.length))
	case "16":
		return CGRect(x: widget_inform.lead_padding + Double(widget_inform.length) + widget_inform.trail_padding,
					  y: widget_inform.top_padding + 2.0 * Double(widget_inform.length) + 2 * widget_inform.bottom_padding,
					  width: CGFloat(widget_inform.length),
					  height: CGFloat(widget_inform.length))
	default:
		print("position error")
		return CGRect(x: 0, y: 0, width: 0, height: 0)
	}
}

struct Temperature_widgetEntryView : View {
    var entry: Provider.Entry
	var homeScreen_image : CGImage?
	var widget_position: String

	init(entry: SimpleEntry) {
		self.widget_position =  UserDefaults.shared.string(forKey: "widget_position") ?? "none"
		self.homeScreen_image = Images_manager().load_image(name: "Home_screen").cgImage
		self.entry = entry
	}

	// widget body
	var body: some View {
		let crop_size = get_widget_Rect(position: widget_position)

		ZStack {
			Color.white
			// background image
			Image(uiImage: UIImage(cgImage: homeScreen_image?.cropping(to: crop_size) ?? UIImage(systemName: "xmark")!.cgImage!,
								   scale: UIScreen.main.scale,
								   orientation: .up))
				.resizable()
				.renderingMode(.original)
				.scaledToFit()

			// Your widget content
			VStack {
				Text("Hello, Widget!")
					.font(.headline)
					.foregroundColor(.primary)
			}
			.padding()	
		}
	}
}

struct Temperature_widget: Widget {
    let kind: String = "Temperature_widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Temperature_widgetEntryView(entry: entry)
				.containerBackground(.clear, for: .widget)
		}.contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

struct VisualEffectView: UIViewRepresentable {
	var effect: UIVisualEffect?

	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView()
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = effect
	}
}

#Preview(as: .systemSmall) {
    Temperature_widget()
} timeline: {
    //SimpleEntry(date: .now, configuration: .smiley)
	SimpleEntry(date: .now, configuration: .starEyes)
}

extension UserDefaults {
	static var shared: UserDefaults {
		let groupIdentifier = "group.simplest_widgets"
		return UserDefaults(suiteName: groupIdentifier)!
	}
}
