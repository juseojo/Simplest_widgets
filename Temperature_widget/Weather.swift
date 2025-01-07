//
//  Weather.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 1/1/25.
//

import WeatherKit
import CoreLocation

class Weather_Service:  NSObject, CLLocationManagerDelegate {
	private let location_manager: CLLocationManager = {
		let manager = CLLocationManager()

		manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers

		return manager
	}()
	private var weather: Forecast<HourWeather>?

	func get_weather(isDay: Bool) -> Forecast<HourWeather>? {

		if isDay {
			for _ in 0 ..< (weather?.count ?? 24) - 24 {
				weather?.forecast.popLast()
			}

			return weather
		}

		return weather
	}

	func refresh_weather() async throws {
		location_manager.delegate = self

		let status = location_manager.authorizationStatus

		// Location auth check
		switch status {
		case .notDetermined:
			self.location_manager.requestAlwaysAuthorization()
			// Wait auth ( func locationManagerDidChangeAuthorization catch this )
			let _ = try await withCheckedThrowingContinuation { continuation in
				NotificationCenter.default.addObserver(forName: .didChangeAuthorization, object: nil, queue: .main) { _ in
					continuation.resume()
				}
			}
		case .restricted, .denied:
			print("loaction denied, restircted")
		case .authorizedWhenInUse, .authorizedAlways:
			print("request location")
			location_manager.requestLocation()
		@unknown default:
			print("location unknown error")
		}

		/*
		 location update is immediated?

		let _ = try await withCheckedThrowingContinuation { continuation in
			NotificationCenter.default.addObserver(forName: .didUpdateLocations, object: nil, queue: .main) { _ in
				continuation.resume()
			}
		}
		 */

		if location_manager.location == nil {
			print("refresh fail : location in nil")
		}
		else {
			let start_date = Date()
			let end_date = Calendar.current.date(byAdding: .hour, value: 24 * 7, to: start_date)!
			let weather = try await WeatherService
				.shared.weather(for: location_manager.location!, including: .hourly(startDate: start_date, endDate: end_date))
			self.weather = weather
		}

		print("weather end")
	}
	// case: User choose auth
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .authorizedWhenInUse, .authorizedAlways:
			self.location_manager.requestLocation()
		case .denied:
			print("local auth deny")
		case .restricted:
			print("local auth restricted")
		case .notDetermined:
			self.location_manager.requestAlwaysAuthorization()
		@unknown default:
			break
		}

		NotificationCenter.default.post(name: .didChangeAuthorization, object: nil)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		print("UpdateLocations")
		//NotificationCenter.default.post(name: .didUpdateLocations, object: nil)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

		print("UpdateLocations fail")
		//NotificationCenter.default.post(name: .didUpdateLocations, object: nil)
		print(error)
	}
}

extension Notification.Name {
	static let didChangeAuthorization = Notification.Name("didChangeAuthorization")
	//static let didUpdateLocations = Notification.Name("didUpdateLocations")

}
