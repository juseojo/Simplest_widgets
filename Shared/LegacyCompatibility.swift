//
//  LegacyCompatibility.swift
//  Simplest_widgets
//
//  Legacy function compatibility layer for Widget Extensions
//  These functions wrap the new implementations for backward compatibility
//

import UIKit

// MARK: - Device Model (replaces get_deviceModel from Utils.swift)

func get_deviceModel() -> String {
    return DeviceRepository.getCurrentDeviceModel()
}

// MARK: - Date Functions (replaces Utils.swift functions)

func date_Localize(date: Date?) -> String {
    guard let date = date else {
        return "time data is none"
    }
    return date.localizedString()
}

func str_to_date(_ str: String) -> Date? {
    return Date.fromStorageString(str)
}

func date_to_str(_ date: Date) -> String? {
    return date.toStorageString()
}

// MARK: - Images Manager (replaces Images_manager class from Utils.swift)

class Images_manager {
    func save_image(data: Data, name: String) -> String {
        if SharedImageStorage.save(data: data, name: name) {
            return "SUCCESS SAVING"
        } else {
            return "SAVING IMAGE ERROR"
        }
    }

    func load_image(name: String) -> UIImage {
        return SharedImageStorage.load(name: name) ?? UIImage(systemName: "xmark")!
    }
}

// MARK: - Model Class (replaces Model class from Model.swift)

class Model {
    func get_bazel(device_name: String) -> Bazel {
        if let bezel = DeviceRepository.getBezel(for: device_name) {
            return Bazel(
                image_name: bezel.imageName,
                left_padding: bezel.leftPadding,
                top_paddings: bezel.topPadding,
                radius: bezel.radius
            )
        }
        return Bazel(image_name: "error", left_padding: 0, top_paddings: 0, radius: 0)
    }

    func get_widget(device_name: String) -> Widget_inform {
        if let widgetInfo = DeviceRepository.getWidgetInfo(for: device_name) {
            return Widget_inform(
                device_name: widgetInfo.deviceName,
                lead_padding: widgetInfo.leadPadding,
                trail_padding: widgetInfo.trailPadding,
                top_padding: widgetInfo.topPadding,
                bottom_padding: widgetInfo.bottomPadding,
                length: widgetInfo.length,
                radius: widgetInfo.radius
            )
        }
        return Widget_inform(device_name: "error", lead_padding: 0, trail_padding: 0, top_padding: 0, bottom_padding: 0, length: 0, radius: 0)
    }

    func get_widget_Rect(position: String) -> CGRect {
        let deviceName = get_deviceModel()
        return DeviceRepository.getWidgetRect(position: position, deviceName: deviceName)
    }
}

// MARK: - Legacy Structs (for compatibility with existing Widget code)

struct Bazel: Hashable {
    let image_name: String
    let left_padding: Double
    let top_paddings: Double
    let radius: Int

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
    let trail_padding: Double
    let top_padding: Double
    let bottom_padding: Double
    let length: Int
    let radius: Int

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

// MARK: - UserDefaults Extension (keep for compatibility)

extension UserDefaults {
    static var shared: UserDefaults {
        let groupIdentifier = "group.simplest_widgets"
        return UserDefaults(suiteName: groupIdentifier)!
    }
}
