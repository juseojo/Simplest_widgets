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
	private var weather: Weather?

	func get_wether() -> Weather? {

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
			DispatchQueue.main.async {
				//self.errorMessage = "we need auth, plz set that."
			}
		case .authorizedWhenInUse, .authorizedAlways:
			print("request location")
			location_manager.requestLocation()
		@unknown default:
			DispatchQueue.main.async {
				//self.errorMessage = "Unknown Auth"
			}
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
			let weather = try await WeatherService.shared.weather(for: location_manager.location!)
			self.weather = weather
		}

		print("weather end")
	}
	// case: User choose auth
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .authorizedWhenInUse, .authorizedAlways:
			self.location_manager.requestLocation() // 위치 요청
		case .denied:
			print("local auth deny")
			//self.errorMessage = "위치 권한이 거부되었습니다. 설정에서 권한을 허용해주세요."
		case .restricted:
			//self.errorMessage = "위치 권한이 제한되었습니다."
			print("local auth restricted")
		case .notDetermined:
			self.location_manager.requestAlwaysAuthorization()
			//self.errorMessage = "위치 권한이 결정되지 않았습니다."
		@unknown default:
			//self.errorMessage = "알 수 없는 권한 상태입니다."
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
