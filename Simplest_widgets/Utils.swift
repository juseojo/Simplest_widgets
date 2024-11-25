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
			let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
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
			let image_path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
				.appendingPathComponent("\(name).png")
		else {
			print("DIRECTORY ERROR")

			return UIImage(systemName: "xmark")!
		}

		return UIImage(contentsOfFile: image_path.path()) ?? UIImage(systemName: "xmark")!
	}
}
