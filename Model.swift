//
//  Model.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 12/16/24.
//

class Model
{
	let iphones_name_dic: [String: String] = [
		// system name : images name

		// iPhone 8
		"iPhone10,1": "Apple iPhone 8 Space Grey",
		"iPhone10,4": "Apple iPhone 8 Space Grey",
		"iPhone10,2": "Apple iPhone 8 Plus Space Grey",
		"iPhone10,5": "Apple iPhone 8 Plus Space Grey",

		// iPhone X
		"iPhone10,3": "Apple iPhone X Space Grey",
		"iPhone10,6": "Apple iPhone X Space Grey",
		"iPhone11,8": "Apple iPhone XR Space Grey",
		"iPhone11,2": "Apple iPhone XS Space Grey",
		"iPhone11,6": "Apple iPhone XS Max Space Grey",
		"iPhone11,4": "Apple iPhone XS Max Space Grey",

		// iPhone 11
		"iPhone12,1": "Apple iPhone 11 Black",
		"iPhone12,3": "Apple iPhone 11 Pro Space Grey",
		"iPhone12,5": "Apple iPhone 11 Pro Max Space Grey",

		// iPhone SE 2nd
		"iPhone12,8": "Apple iPhone SE Black",

		// iPhone 12
		"iPhone13,1": "Apple iPhone 12 Mini Black",
		"iPhone13,2": "Apple iPhone 12 Black",
		"iPhone13,3": "Apple iPhone 12 Pro Graphite",
		"iPhone13,4": "Apple iPhone 12 Pro Max Graphite",

		// iPhone 13
		"iPhone14,4": "iPhone 13 Mini — Midnight",
		"iPhone14,5": "Apple iPhone 13 — Midnight",
		"iPhone14,2": "Apple iPhone 13 Pro — Graphite",
		"iPhone14,3": "Apple iPhone 13 Pro Max — Graphite",

		// iPhone SE - 3rd
		"iPhone14,6": "Apple iPhone SE Black",

		// iPhone 14
		"iPhone15,2": "iPhone 14 Pro – Space Black",
		"iPhone15,3": "iPhone 14 Pro Max – Space Black",
		"iPhone15,4": "iPhone 14 – Midnight",
		"iPhone15,5": "iPhone 14 Plus – Midnight",

		// iPhone 15
		"iPhone16,3": "Apple iPhone 15 Black",
		"iPhone16,2": "Apple iPhone 15 Plus Black",
		"iPhone16,1": "Apple iPhone 15 Pro Black Titanium",
		"iPhone16,4": "Apple iPhone 15 Pro Max Black Titanium",

		// iPhone 16
		"iPhone17,1": "Apple iPhone 16 Black",
		"iPhone17,2": "Apple iPhone 16 Plus Black",
		"iPhone17,3": "Apple iPhone 16 Pro Black Titanium",
		"iPhone17,4": "iPhone 16 Pro Max Black Titanium",

		"arm64": "Apple iPhone 15 Pro Black Titanium"
	]

	let Bazels: Set<Bazel> = [
		Bazel(image_name: "Apple iPhone 8 Space Grey", left_padding: 100, top_paddings: 280, radius: 0),
		Bazel(image_name: "Apple iPhone 8 Plus Space Grey", left_padding: 200, top_paddings: 400, radius: 0),
		Bazel(image_name: "Apple iPhone X Space Grey", left_padding: 140, top_paddings: 180, radius: 115),
		Bazel(image_name: "Apple iPhone XR Space Grey", left_padding: 110, top_paddings: 110, radius: 82),
		Bazel(image_name: "Apple iPhone XS Space Grey", left_padding: 130, top_paddings: 120, radius: 115),
		Bazel(image_name: "Apple iPhone XS Max Space Grey", left_padding: 140, top_paddings: 138, radius: 115),
		Bazel(image_name: "Apple iPhone 11 Black", left_padding: 100, top_paddings: 100, radius: 82),
		Bazel(image_name: "Apple iPhone 11 Pro Space Grey", left_padding: 130, top_paddings: 130, radius: 115),
		Bazel(image_name: "Apple iPhone 11 Pro Max Space Grey", left_padding: 130, top_paddings: 130, radius: 115),
		Bazel(image_name: "Apple iPhone 12 Black", left_padding: 180, top_paddings: 180, radius: 140),
		Bazel(image_name: "Apple iPhone 12 Mini Black", left_padding: 160, top_paddings: 160, radius: 128),
		Bazel(image_name: "Apple iPhone 12 Pro Graphite", left_padding: 180, top_paddings: 180, radius: 140),
		Bazel(image_name: "Apple iPhone 12 Pro Max Graphite", left_padding: 200, top_paddings: 200, radius: 155),
		Bazel(image_name: "Apple iPhone SE Black", left_padding: 150, top_paddings: 300, radius: 0),
		Bazel(image_name: "Apple iPhone 13 — Midnight", left_padding: 200, top_paddings: 200, radius: 150),
		Bazel(image_name: "iPhone 13 Mini — Midnight", left_padding: 200, top_paddings: 200, radius: 128),
		Bazel(image_name: "Apple iPhone 13 Pro — Graphite", left_padding: 200, top_paddings: 200, radius: 140),
		Bazel(image_name: "Apple iPhone 13 Pro Max — Graphite", left_padding: 200, top_paddings: 200, radius: 150),
		Bazel(image_name: "iPhone 14 – Midnight", left_padding: 124, top_paddings: 114, radius: 100),
		Bazel(image_name: "iPhone 14 Plus – Midnight", left_padding: 115, top_paddings: 113.5, radius: 105),
		Bazel(image_name: "iPhone 14 Pro – Space Black", left_padding: 119, top_paddings: 112, radius: 115),
		Bazel(image_name: "iPhone 14 Pro Max – Space Black", left_padding: 109, top_paddings: 101.5, radius: 112),
		Bazel(image_name: "Apple iPhone 15 Black", left_padding: 68, top_paddings: 58, radius: 165),
		Bazel(image_name: "Apple iPhone 15 Plus Black", left_padding: 68, top_paddings: 58, radius: 159),
		Bazel(image_name: "Apple iPhone 15 Pro Black Titanium", left_padding: 57, top_paddings: 50, radius: 159),
		Bazel(image_name: "Apple iPhone 15 Pro Max Black Titanium", left_padding: 58, top_paddings: 50, radius: 165),
		Bazel(image_name: "Apple iPhone 16 Black", left_padding: 67, top_paddings: 58, radius: 165),
		Bazel(image_name: "Apple iPhone 16 Plus Black", left_padding: 67, top_paddings: 59, radius: 165),
		Bazel(image_name: "Apple iPhone 16 Pro Black Titanium", left_padding: 52, top_paddings: 44, radius: 178),
		Bazel(image_name: "iPhone 16 Pro Max Black Titanium", left_padding: 52, top_paddings: 44, radius: 180)
	]

	let Widgets: Set<Widget_inform> = [
		// iPhone 16
		Widget_inform(device_name: "iPhone17,1", lead_padding: 81, trail_padding: 69, top_padding: 270, bottom_padding: 114, length: 510, radius: 63),
		Widget_inform(device_name: "iPhone17,3", lead_padding: 96, trail_padding: 66, top_padding: 270, bottom_padding: 114, length: 474, radius: 63),
		Widget_inform(device_name: "iPhone17,2", lead_padding: 99, trail_padding: 72, top_padding: 252, bottom_padding: 126, length: 510, radius: 67),
		Widget_inform(device_name: "iPhone17,4", lead_padding: 114, trail_padding: 72, top_padding: 282, bottom_padding: 126, length: 510, radius: 67),

		// iPhone 15
		Widget_inform(device_name: "iPhone16,1", lead_padding: 81, trail_padding: 68, top_padding: 240, bottom_padding: 114, length: 474, radius: 65),
		Widget_inform(device_name: "iPhone16,2", lead_padding: 93, trail_padding: 83, top_padding: 282, bottom_padding: 126, length: 510, radius: 67),
		Widget_inform(device_name: "iPhone16,3", lead_padding: 81, trail_padding: 68, top_padding: 270, bottom_padding: 114, length: 474, radius: 65),
		Widget_inform(device_name: "iPhone16,4", lead_padding: 93, trail_padding: 83, top_padding: 282, bottom_padding: 126, length: 510, radius: 67),

		// iPhone 14
		Widget_inform(device_name: "iPhone15,4", lead_padding: 78, trail_padding: 66, top_padding: 201, bottom_padding: 114, length: 474, radius: 62),
		Widget_inform(device_name: "iPhone15,5", lead_padding: 96, trail_padding: 72, top_padding: 216, bottom_padding: 126, length: 510, radius: 67),
		Widget_inform(device_name: "iPhone15,2", lead_padding: 81, trail_padding: 69, top_padding: 240, bottom_padding: 114, length: 474, radius: 63),
		Widget_inform(device_name: "iPhone15,3", lead_padding: 99, trail_padding: 72, top_padding: 252, bottom_padding: 126, length: 510, radius: 67),

		// iPhone SE
		Widget_inform(device_name: "iPhone14,6", lead_padding: 54, trail_padding: 50, top_padding: 60, bottom_padding: 56, length: 296, radius: 37),
		Widget_inform(device_name: "iPhone12,8", lead_padding: 54, trail_padding: 50, top_padding: 60, bottom_padding: 56, length: 296, radius: 37),

		// iPhone 13
		Widget_inform(device_name: "iPhone14,4", lead_padding: 66, trail_padding: 54, top_padding: 193, bottom_padding: 100, length: 296, radius: 60),
		Widget_inform(device_name: "iPhone14,5", lead_padding: 78, trail_padding: 66, top_padding: 201, bottom_padding: 114, length: 474, radius: 62),
		Widget_inform(device_name: "iPhone14,2", lead_padding: 78, trail_padding: 66, top_padding: 201, bottom_padding: 114, length: 474, radius: 62),
		Widget_inform(device_name: "iPhone14,3", lead_padding: 96, trail_padding: 72, top_padding: 216, bottom_padding: 126, length: 510, radius: 69),

		// iPhone 12
		Widget_inform(device_name: "iPhone13,1", lead_padding: 66, trail_padding: 54, top_padding: 193, bottom_padding: 100, length: 447, radius: 59),
		Widget_inform(device_name: "iPhone13,2", lead_padding: 78, trail_padding: 66, top_padding: 201, bottom_padding: 114, length: 474, radius: 62),
		Widget_inform(device_name: "iPhone13,3", lead_padding: 78, trail_padding: 67, top_padding: 201, bottom_padding: 114, length: 474, radius: 62),
		Widget_inform(device_name: "iPhone13,4", lead_padding: 96, trail_padding: 72, top_padding: 216, bottom_padding: 126, length: 510, radius: 66),

		// iPhone 11
		Widget_inform(device_name: "iPhone12,1", lead_padding: 54, trail_padding: 44, top_padding: 140, bottom_padding: 82, length: 338, radius: 44),
		Widget_inform(device_name: "iPhone12,3", lead_padding: 69, trail_padding: 57, top_padding: 183, bottom_padding: 105, length: 465, radius: 62),
		Widget_inform(device_name: "iPhone12,5", lead_padding: 81, trail_padding: 66, top_padding: 198, bottom_padding: 123, length: 507, radius: 67),

		// iPhone X
		Widget_inform(device_name: "iPhone11,8", lead_padding: 54, trail_padding: 44, top_padding: 140, bottom_padding: 82, length: 338, radius: 44),
		Widget_inform(device_name: "iPhone11,2", lead_padding: 69, trail_padding: 57, top_padding: 183, bottom_padding: 105, length: 465, radius: 62),
		Widget_inform(device_name: "iPhone11,4", lead_padding: 81, trail_padding: 66, top_padding: 198, bottom_padding: 123, length: 507, radius: 66),
		Widget_inform(device_name: "iPhone11,6", lead_padding: 81, trail_padding: 66, top_padding: 198, bottom_padding: 123, length: 507, radius: 66),
		Widget_inform(device_name: "iPhone10,3", lead_padding: 69, trail_padding: 57, top_padding: 213, bottom_padding: 105, length: 465, radius: 62),
		Widget_inform(device_name: "iPhone10,6", lead_padding: 69, trail_padding: 57, top_padding: 213, bottom_padding: 105, length: 465, radius: 62),

		// iPhone 8
		Widget_inform(device_name: "iPhone10,1", lead_padding: 54, trail_padding: 50, top_padding: 60, bottom_padding: 56, length: 296, radius: 37),
		Widget_inform(device_name: "iPhone10,4", lead_padding: 54, trail_padding: 50, top_padding: 60, bottom_padding: 56, length: 296, radius: 37),
		Widget_inform(device_name: "iPhone10,2", lead_padding: 99, trail_padding: 102, top_padding: 114, bottom_padding: 111, length: 471, radius: 62),
		Widget_inform(device_name: "iPhone10,5", lead_padding: 99, trail_padding: 102, top_padding: 114, bottom_padding: 111, length: 471, radius: 62),

		Widget_inform(device_name: "arm64",  lead_padding: 81, trail_padding: 68, top_padding: 270, bottom_padding: 114, length: 474, radius: 65)

		]

	func get_bazel(device_name: String) -> Bazel
	{
		for bazel in Bazels {
			if bazel.image_name == iphones_name_dic[device_name] {
				return bazel
			}
		}
		print("get_bazel : device name error")

		return Bazel(image_name: "error", left_padding: 0, top_paddings: 0, radius: 0)
	}

	func get_widget(device_name: String) -> Widget_inform
	{
		for widget_inform in Widgets {
			if widget_inform.device_name == device_name {
				return widget_inform
			}
		}
		print("get_widget : device name error")

		return Widget_inform(device_name: "error", lead_padding: 0, trail_padding: 0, top_padding: 0, bottom_padding: 0, length: 0, radius: 0)
	}
}

struct Bazel: Hashable {
	let image_name: String
	let left_padding: Double
	let top_paddings: Double
	let radius : Int

	init(image_name: String, left_padding: Double, top_paddings: Double, radius: Int) {
		self.image_name = image_name
		self.left_padding = left_padding
		self.top_paddings = top_paddings
		self.radius = radius
	}
}

struct Widget_inform: Hashable {
	let device_name: String
	let lead_padding: Double
	let	trail_padding: Double
	let top_padding: Double
	let bottom_padding: Double
	let length: Int
	let radius : Int

	init(device_name: String, lead_padding: Double, trail_padding: Double, top_padding: Double, bottom_padding: Double, length: Int, radius: Int) {
		self.device_name = device_name
		self.lead_padding = lead_padding
		self.trail_padding = trail_padding
		self.top_padding = top_padding
		self.bottom_padding = bottom_padding
		self.length = length
		self.radius = radius
	}
}
