//
//  Utils.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/25/24.
//

import UIKit

class Images_manager
{
	func save_image(data: Data, name: String) -> String {
		guard
			let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.simplest_widgets")?
				.appendingPathComponent("\(name).png")
		else {
			return "DIRECTORY ERROR"
		}

		do {
			try data.write(to: path)
			return "SUCCESS SAVING"
		} catch {
			print(error.localizedDescription)
			return "SAVING IMAGE ERROR"
		}
	}

	func load_image(name: String) -> UIImage {
		guard
			let image_path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.simplest_widgets")?
				.appendingPathComponent("\(name).png")
		else {
			print("DIRECTORY ERROR")

			return UIImage(systemName: "xmark")!
		}

		return UIImage(contentsOfFile: image_path.path()) ?? UIImage(systemName: "xmark")!
	}
}

func get_deviceModel() -> String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let modelCode = withUnsafePointer(to: &systemInfo.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: 1) {
				String(cString: $0)
			}
		}
		return modelCode
}

func date_Localize(date: Date?) -> String
{
	// exception
	if date == nil {
		return "time data is none"
	}

	let dateFormatter = DateFormatter()

	dateFormatter.dateStyle = .short
	dateFormatter.timeStyle = .short
	dateFormatter.locale = Locale.current
	dateFormatter.timeZone = TimeZone.current

	return dateFormatter.string(from: date!)
}

func str_to_date(_ str: String) -> Date?
{
	let dateFormatter = DateFormatter()

	dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	dateFormatter.timeZone = Locale.current.timeZone

	if let date = dateFormatter.date(from: str) {
		return date
	} else {
		print("Fail change str to date")
		return nil
	}
}

func date_to_str(_ date: Date) -> String?
{
	let dateFormatter = DateFormatter()

	dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	dateFormatter.timeZone = Locale.current.timeZone

	let str = dateFormatter.string(from: date)

	return str
}
