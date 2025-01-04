//
//  Temperature_widget.swift
//  Temperature_widget
//
//  Created by seongjun cho on 11/16/24.
//

import WidgetKit
import SwiftUI
import WeatherKit
import CoreLocation

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
		let weather_service = Weather_Service()
		var weather: Weather?

		// Refresh weather and get temperatures
		do {
			try await weather_service.refresh_weather()
			weather = weather_service.get_wether()
			configuration.temperatures = weather?.hourlyForecast.forecast.map { data in
				data.temperature.value } ?? [0.0]
			if UserDefaults.shared.string(forKey: "temperature time") ?? "1 Day" == "1 Day" {
				for _ in 0 ..< (weather?.hourlyForecast.forecast.count ?? 24) - 24 {
					configuration.temperatures.popLast()
				}
			}
			else {
				for _ in 0 ..< (weather?.hourlyForecast.forecast.count ?? 24) - 24 * 7 {
					configuration.temperatures.popLast()
				}
			}
			print(configuration.temperatures)
			print(configuration.temperatures.count)
			print(UserDefaults.shared.string(forKey: "temperature notation"))
		}
		catch {
			print("Failed to fetch weather: \(error)")
			configuration.temperatures = [0.0]
		}

        for hourOffset in 0 ..< 6 {
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

// Return CGRect for croping image
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
	case "21":
		return CGRect(x: widget_inform.lead_padding,
					  y: widget_inform.top_padding,
					  width: Double(widget_inform.length * 2) + widget_inform.trail_padding,
					  height: CGFloat(widget_inform.length))
	case "22":
		return CGRect(x: widget_inform.lead_padding,
					  y: widget_inform.top_padding + Double(widget_inform.length) + widget_inform.bottom_padding,
					  width: Double(widget_inform.length * 2) + widget_inform.trail_padding,
					  height: CGFloat(widget_inform.length))
	case "23":
		return CGRect(x: widget_inform.lead_padding,
					  y: widget_inform.top_padding + 2.0 * Double(widget_inform.length) + 2 * widget_inform.bottom_padding,
					  width: Double(widget_inform.length * 2) + widget_inform.trail_padding,
					  height: CGFloat(widget_inform.length))
	default:
		print("position error")
		return CGRect(x: 0, y: 0, width: 0, height: 0)
	}
}

// Return gradation color
private func make_temperatureColors(temperatures: [Double], isNormal: Bool) -> [Color] {
	var colors = [Color]()

	if isNormal
	{
		for temperature in temperatures {
			let color = temperature < 10 ? Color.red : Color.blue
			colors.append(color)
		}
	}
	else
	{
		for temperature in temperatures {
			let color = temperatures[0] - temperature > 0 ? Color.red : Color.blue
			colors.append(color)
		}
	}
	return colors
}

struct Temperature_widgetEntryView : View {
    var entry: Provider.Entry
	var homeScreen_image : CGImage?
	var widget_position: String
	let format = DateFormatter()

	init(entry: SimpleEntry) {
		self.widget_position =  UserDefaults.shared.string(forKey: "temperature size") ?? "none"
		self.homeScreen_image = Images_manager().load_image(name: "Home_screen").cgImage
		self.entry = entry
		self.format.dateFormat = "yyyy-MM-dd HH:mm:ss"
	}

	// widget body
	var body: some View {
		let crop_size = get_widget_Rect(position: widget_position)
		let position =  UserDefaults.shared.string(forKey: "temperature position") ?? "1"
		ZStack {
			Color.white
			// background image
			Image(uiImage: UIImage(cgImage: homeScreen_image?.cropping(to: crop_size) ?? UIImage(systemName: "xmark")!.cgImage!,
								   scale: UIScreen.main.scale,
								   orientation: .up))
			.resizable()
			.renderingMode(.original)
			.scaledToFit()

			if UserDefaults.shared.string(forKey: "temperature type") ?? "Horizon" == "Horizon" {
				VStack {
					if position == "1" || position == "2" {
						Spacer()
					}
					// temperatur Bar
					Temperature_Bar(temperatures: entry.configuration.temperatures)
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
					// temperatur Bar
					Temperature_Bar(temperatures: entry.configuration.temperatures)
					if position == "1" || position == "2" {
						Spacer()
					}
				}
			}
		}
	}
}

struct Temperature_Bar: View {

	var temperatures: [Double]
	var body: some View {

		if UserDefaults.shared.string(forKey: "temperature type") ?? "Horizon" == "Horizon" {
			ZStack{
				if UserDefaults.shared.string(forKey: "temperature notation") ?? "normal" == "normal" {
					LinearGradient(gradient: Gradient(colors: make_temperatureColors(temperatures: temperatures, isNormal: true)), startPoint: .leading, endPoint: .trailing)
				}
				else {
					LinearGradient(gradient: Gradient(colors: make_temperatureColors(temperatures: temperatures, isNormal: false)), startPoint: .leading, endPoint: .trailing)
				}
			}
			.frame(height: 15)
			.cornerRadius(30)
			.padding(.horizontal, 10)
		}
		else
		{
			ZStack{
				if UserDefaults.shared.string(forKey: "temperature notation") ?? "normal" == "normal" {
					LinearGradient(gradient: Gradient(colors: make_temperatureColors(temperatures: temperatures, isNormal: true)), startPoint: .top, endPoint: .bottom)
				}
				else {
					LinearGradient(gradient: Gradient(colors: make_temperatureColors(temperatures: temperatures, isNormal: false)), startPoint: .top, endPoint: .bottom)
				}
			}
			.frame(width: 15)
			.cornerRadius(30)
			.padding(.vertical, 10)
		}
	}
}

struct Temperature_widget: Widget {
    let kind: String = "Temperature_widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Temperature_widgetEntryView(entry: entry)
				.containerBackground(.clear, for: .widget)
		}
		.contentMarginsDisabled()
		.configurationDisplayName("Temperature Bar")
		.description("Check easily temperature")
    }
}

extension ConfigurationAppIntent {
    
    fileprivate static var temp: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
		intent.temperatures = [0]
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
	SimpleEntry(date: .now, configuration: .temp)
}

extension UserDefaults {
	static var shared: UserDefaults {
		let groupIdentifier = "group.simplest_widgets"
		return UserDefaults(suiteName: groupIdentifier)!
	}
}
