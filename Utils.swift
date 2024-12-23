//
//  Utils.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/25/24.
//

import UIKit

class Images_manager
{
	init() {

	}

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
