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
		var weathers: Forecast<HourWeather>?
		let isDay = (UserDefaults.shared.string(forKey: "temperature time") ?? String(localized:"1 Day")) == String(localized:"1 Day")

		// Refresh weather and get temperatures
		do {
			try await weather_service.refresh_weather()
			weathers = weather_service.get_weather()
			configuration.temperatures = weathers?.forecast.map { data in
				data.temperature.value } ?? [0.0]
		}
		catch {
			print("Failed to fetch weather: \(error)")
			configuration.temperatures = [0.0]
		}

		let temperatures = configuration.temperatures

        for hourOffset in 1 ..< 3 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!

			if isDay {
				configuration.temperatures = Array(temperatures[hourOffset...(24 + hourOffset)])
			}
			else {
				configuration.temperatures = Array(temperatures[hourOffset...(24 * 7 + hourOffset)])
			}

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

// Return gradation color
private func make_temperatureColors(temperatures: [Double], isNormal: Bool) -> [Color] {
	var colors = [Color]()

	if isNormal
	{
		for temperature in temperatures {
			let color = get_normalColor(for: temperature)
			colors.append(color)
		}
	}
	else
	{
		for temperature in temperatures {
			let color = get_diffrenceColor(for: abs(temperatures[0]) - abs(temperature))
			colors.append(color)
		}
	}

	return colors
}

private func get_normalColor(for temperature: Double) -> Color {
	// Temperature's colors
	switch temperature {
	case ...(-15):
		return interpolateColor(from: .black, to: .indigo, fraction: 1)
	case -15..<(-10):
		return interpolateColor(from: .indigo, to: .blue, fraction: (temperature + 15) / 5)
	case -10..<(-5):
		return interpolateColor(from: .blue, to: .cyan, fraction: (temperature + 10) / 5)
	case -5..<(-2):
		return interpolateColor(from: .cyan, to: Color("skyBlue"), fraction: temperature + 5 / 3)
	case -2..<2:
		return interpolateColor(from: Color("skyBlue"), to: .white, fraction: (temperature + 2) / 4)
	case 2..<10:
		return interpolateColor(from: .white, to: .yellow, fraction: (temperature - 2) / 8)
	case 10..<20:
		return interpolateColor(from: .yellow, to: .orange, fraction: (temperature - 10) / 10)
	case 20..<30:
		return interpolateColor(from: .orange, to: .red, fraction: (temperature - 20) / 10)
	case 30..<40:
		return interpolateColor(from: .red, to: .pink, fraction: (temperature - 30) / 10)
	case 40...:
		return interpolateColor(from: .pink, to: .purple, fraction: 1)
	default:
		return .gray
	}
}

private func get_diffrenceColor(for temperature: Double) -> Color {
	// Temperature's colors
	switch temperature {
	case ...(-15):
		return interpolateColor(from: .black, to: .indigo, fraction: 1)
	case -15..<(-10):
		return interpolateColor(from: .indigo, to: .blue, fraction: (temperature + 15) / 5)
	case -10..<(-6):
		return interpolateColor(from: .blue, to: .cyan, fraction: (temperature + 10) / 4)
	case -6..<(-3):
		return interpolateColor(from: .cyan, to: Color("skyBlue"), fraction: (temperature + 6) / 3)
	case -3..<0:
		return interpolateColor(from: Color("skyBlue"), to: .white, fraction: (temperature + 3) / 3)
	case 0..<3:
		return interpolateColor(from: .white, to: .yellow, fraction: temperature / 3)
	case 3..<6:
		return interpolateColor(from: .yellow, to: .orange, fraction: (temperature - 3) / 3)
	case 6..<10:
		return interpolateColor(from: .orange, to: .red, fraction: (temperature - 6) / 4)
	case 10..<15:
		return interpolateColor(from: .red, to: .pink, fraction: (temperature - 10) / 5)
	case 15...:
		return interpolateColor(from: .pink, to: .purple, fraction: 1)
	default:
		return .gray
	}
}

private func interpolateColor(from: Color, to: Color, fraction: Double) -> Color {
	// Mix color by near color, fraction
	let uiFrom = UIColor(from)
	let uiTo = UIColor(to)

	var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
	var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

	uiFrom.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
	uiTo.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

	let r = r1 + CGFloat(fraction) * (r2 - r1)
	let g = g1 + CGFloat(fraction) * (g2 - g1)
	let b = b1 + CGFloat(fraction) * (b2 - b1)
	let a = a1 + CGFloat(fraction) * (a2 - a1)

	return Color(UIColor(red: r, green: g, blue: b, alpha: a))
}

struct Temperature_widgetEntryView : View {
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

	// widget body
	var body: some View {
		let model = Model()
		let crop_size = model.get_widget_Rect(position: widget_position)
		let location_manager = CLLocationManager()
		let crop_image: CGImage? = homeScreen_image?.cropping(to:crop_size)

		ZStack {
			Color.white

			// background image
			if crop_image != nil {
				Image(uiImage: UIImage(cgImage: crop_image!,
									   scale: UIScreen.main.scale,
									   orientation: .up))
				.resizable()
				.renderingMode(.original)
				.scaledToFit()

				// case: Location auth X
				if location_manager.authorizationStatus == .notDetermined ||
					location_manager.authorizationStatus == .restricted ||
					   location_manager.authorizationStatus == .denied {
					Text("Please allow location authorization").background(.white)
				}
			} else {
				// case: image nil, Location auth X
				VStack {
					if UserDefaults.shared.string(forKey: "temperature widget position") ?? "00" == "00" {
						Text("Please choice widget position").padding(.bottom, 10)
					}
					else {
						Text("Please set correct image").padding(.bottom, 10)
					}

					if location_manager.authorizationStatus == .notDetermined ||
						location_manager.authorizationStatus == .restricted ||
						location_manager.authorizationStatus == .denied {
						Text("Please allow location authorization")
					}
				}
			}

			// Decide Temperature Bar Shape & postion
			if UserDefaults.shared.string(forKey: "temperature type") ?? String(localized:"Horizon") == String(localized:"Horizon") {
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
		.widgetURL(URL(string: "simplestWidgets://widget/Temperature"))
	}
}

struct Temperature_Bar: View {

	var temperatures: [Double]
	var body: some View {

		if UserDefaults.shared.string(forKey: "temperature type") ?? String(localized:"Horizon") == String(localized:"Horizon") {
			ZStack{
				if UserDefaults.shared.string(forKey: "temperature notation") ?? String(localized:"normal") == String(localized:"normal") {
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
				if UserDefaults.shared.string(forKey: "temperature notation") ?? String(localized:"normal") == String(localized:"normal") {
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
		.supportedFamilies([.systemSmall,
							.systemMedium])
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
