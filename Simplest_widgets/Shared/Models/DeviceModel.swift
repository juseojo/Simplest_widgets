//
//  DeviceModel.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import CoreGraphics

// MARK: - Bezel Model

struct Bezel: Hashable, Equatable {
    let imageName: String
    let leftPadding: Double
    let topPadding: Double
    let radius: Int

    init(imageName: String, leftPadding: Double, topPadding: Double, radius: Int) {
        self.imageName = imageName
        self.leftPadding = leftPadding
        self.topPadding = topPadding
        self.radius = radius
    }
}

// MARK: - Widget Info Model

struct WidgetInfo: Hashable, Equatable {
    let deviceName: String
    let leadPadding: Double
    let trailPadding: Double
    let topPadding: Double
    let bottomPadding: Double
    let length: Int
    let radius: Int

    init(
        deviceName: String,
        leadPadding: Double,
        trailPadding: Double,
        topPadding: Double,
        bottomPadding: Double,
        length: Int,
        radius: Int
    ) {
        self.deviceName = deviceName
        self.leadPadding = leadPadding
        self.trailPadding = trailPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.length = length
        self.radius = radius
    }
}

// MARK: - Device Repository

struct DeviceRepository {

    // MARK: - iPhone Name Dictionary

    static let iphoneNameDictionary: [String: String] = [
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

        // iPhone SE 3rd
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

        // Simulator
        "arm64": "Apple iPhone 15 Pro Black Titanium"
    ]

    // MARK: - Bezels

    static let bezels: Set<Bezel> = [
        Bezel(imageName: "Apple iPhone 8 Space Grey", leftPadding: 100, topPadding: 280, radius: 0),
        Bezel(imageName: "Apple iPhone 8 Plus Space Grey", leftPadding: 200, topPadding: 400, radius: 0),
        Bezel(imageName: "Apple iPhone X Space Grey", leftPadding: 140, topPadding: 180, radius: 115),
        Bezel(imageName: "Apple iPhone XR Space Grey", leftPadding: 110, topPadding: 110, radius: 82),
        Bezel(imageName: "Apple iPhone XS Space Grey", leftPadding: 130, topPadding: 120, radius: 115),
        Bezel(imageName: "Apple iPhone XS Max Space Grey", leftPadding: 140, topPadding: 138, radius: 115),
        Bezel(imageName: "Apple iPhone 11 Black", leftPadding: 100, topPadding: 100, radius: 82),
        Bezel(imageName: "Apple iPhone 11 Pro Space Grey", leftPadding: 130, topPadding: 130, radius: 115),
        Bezel(imageName: "Apple iPhone 11 Pro Max Space Grey", leftPadding: 130, topPadding: 130, radius: 115),
        Bezel(imageName: "Apple iPhone 12 Black", leftPadding: 180, topPadding: 180, radius: 140),
        Bezel(imageName: "Apple iPhone 12 Mini Black", leftPadding: 160, topPadding: 160, radius: 128),
        Bezel(imageName: "Apple iPhone 12 Pro Graphite", leftPadding: 180, topPadding: 180, radius: 140),
        Bezel(imageName: "Apple iPhone 12 Pro Max Graphite", leftPadding: 200, topPadding: 200, radius: 155),
        Bezel(imageName: "Apple iPhone SE Black", leftPadding: 150, topPadding: 300, radius: 0),
        Bezel(imageName: "Apple iPhone 13 — Midnight", leftPadding: 200, topPadding: 200, radius: 150),
        Bezel(imageName: "iPhone 13 Mini — Midnight", leftPadding: 200, topPadding: 200, radius: 128),
        Bezel(imageName: "Apple iPhone 13 Pro — Graphite", leftPadding: 200, topPadding: 200, radius: 140),
        Bezel(imageName: "Apple iPhone 13 Pro Max — Graphite", leftPadding: 200, topPadding: 200, radius: 150),
        Bezel(imageName: "iPhone 14 – Midnight", leftPadding: 124, topPadding: 114, radius: 100),
        Bezel(imageName: "iPhone 14 Plus – Midnight", leftPadding: 115, topPadding: 113.5, radius: 105),
        Bezel(imageName: "iPhone 14 Pro – Space Black", leftPadding: 119, topPadding: 112, radius: 115),
        Bezel(imageName: "iPhone 14 Pro Max – Space Black", leftPadding: 109, topPadding: 101.5, radius: 112),
        Bezel(imageName: "Apple iPhone 15 Black", leftPadding: 68, topPadding: 58, radius: 165),
        Bezel(imageName: "Apple iPhone 15 Plus Black", leftPadding: 68, topPadding: 58, radius: 159),
        Bezel(imageName: "Apple iPhone 15 Pro Black Titanium", leftPadding: 57, topPadding: 50, radius: 159),
        Bezel(imageName: "Apple iPhone 15 Pro Max Black Titanium", leftPadding: 58, topPadding: 50, radius: 165),
        Bezel(imageName: "Apple iPhone 16 Black", leftPadding: 67, topPadding: 58, radius: 165),
        Bezel(imageName: "Apple iPhone 16 Plus Black", leftPadding: 67, topPadding: 59, radius: 165),
        Bezel(imageName: "Apple iPhone 16 Pro Black Titanium", leftPadding: 52, topPadding: 44, radius: 178),
        Bezel(imageName: "iPhone 16 Pro Max Black Titanium", leftPadding: 52, topPadding: 44, radius: 180)
    ]

    // MARK: - Widgets

    static let widgets: Set<WidgetInfo> = [
        // iPhone 16
        WidgetInfo(deviceName: "iPhone17,1", leadPadding: 81, trailPadding: 69, topPadding: 270, bottomPadding: 114, length: 510, radius: 63),
        WidgetInfo(deviceName: "iPhone17,3", leadPadding: 96, trailPadding: 66, topPadding: 270, bottomPadding: 114, length: 474, radius: 63),
        WidgetInfo(deviceName: "iPhone17,2", leadPadding: 99, trailPadding: 72, topPadding: 252, bottomPadding: 126, length: 510, radius: 67),
        WidgetInfo(deviceName: "iPhone17,4", leadPadding: 114, trailPadding: 72, topPadding: 282, bottomPadding: 126, length: 510, radius: 67),

        // iPhone 15
        WidgetInfo(deviceName: "iPhone16,1", leadPadding: 81, trailPadding: 69, topPadding: 240, bottomPadding: 114, length: 474, radius: 65),
        WidgetInfo(deviceName: "iPhone16,2", leadPadding: 93, trailPadding: 83, topPadding: 282, bottomPadding: 126, length: 510, radius: 67),
        WidgetInfo(deviceName: "iPhone16,3", leadPadding: 81, trailPadding: 68, topPadding: 270, bottomPadding: 114, length: 474, radius: 65),
        WidgetInfo(deviceName: "iPhone16,4", leadPadding: 93, trailPadding: 83, topPadding: 282, bottomPadding: 126, length: 510, radius: 67),

        // iPhone 14
        WidgetInfo(deviceName: "iPhone15,4", leadPadding: 78, trailPadding: 66, topPadding: 201, bottomPadding: 114, length: 474, radius: 62),
        WidgetInfo(deviceName: "iPhone15,5", leadPadding: 96, trailPadding: 72, topPadding: 216, bottomPadding: 126, length: 510, radius: 67),
        WidgetInfo(deviceName: "iPhone15,2", leadPadding: 81, trailPadding: 69, topPadding: 240, bottomPadding: 114, length: 474, radius: 63),
        WidgetInfo(deviceName: "iPhone15,3", leadPadding: 99, trailPadding: 72, topPadding: 252, bottomPadding: 126, length: 510, radius: 67),

        // iPhone SE
        WidgetInfo(deviceName: "iPhone14,6", leadPadding: 54, trailPadding: 50, topPadding: 60, bottomPadding: 56, length: 296, radius: 37),
        WidgetInfo(deviceName: "iPhone12,8", leadPadding: 54, trailPadding: 50, topPadding: 60, bottomPadding: 56, length: 296, radius: 37),

        // iPhone 13
        WidgetInfo(deviceName: "iPhone14,4", leadPadding: 66, trailPadding: 54, topPadding: 193, bottomPadding: 100, length: 296, radius: 60),
        WidgetInfo(deviceName: "iPhone14,5", leadPadding: 78, trailPadding: 66, topPadding: 201, bottomPadding: 114, length: 474, radius: 62),
        WidgetInfo(deviceName: "iPhone14,2", leadPadding: 78, trailPadding: 66, topPadding: 201, bottomPadding: 114, length: 474, radius: 62),
        WidgetInfo(deviceName: "iPhone14,3", leadPadding: 96, trailPadding: 72, topPadding: 216, bottomPadding: 126, length: 510, radius: 69),

        // iPhone 12
        WidgetInfo(deviceName: "iPhone13,1", leadPadding: 66, trailPadding: 54, topPadding: 193, bottomPadding: 100, length: 447, radius: 59),
        WidgetInfo(deviceName: "iPhone13,2", leadPadding: 78, trailPadding: 66, topPadding: 201, bottomPadding: 114, length: 474, radius: 62),
        WidgetInfo(deviceName: "iPhone13,3", leadPadding: 78, trailPadding: 67, topPadding: 201, bottomPadding: 114, length: 474, radius: 62),
        WidgetInfo(deviceName: "iPhone13,4", leadPadding: 96, trailPadding: 72, topPadding: 216, bottomPadding: 126, length: 510, radius: 66),

        // iPhone 11
        WidgetInfo(deviceName: "iPhone12,1", leadPadding: 54, trailPadding: 44, topPadding: 140, bottomPadding: 82, length: 338, radius: 44),
        WidgetInfo(deviceName: "iPhone12,3", leadPadding: 69, trailPadding: 57, topPadding: 183, bottomPadding: 105, length: 465, radius: 62),
        WidgetInfo(deviceName: "iPhone12,5", leadPadding: 81, trailPadding: 66, topPadding: 198, bottomPadding: 123, length: 507, radius: 67),

        // iPhone X
        WidgetInfo(deviceName: "iPhone11,8", leadPadding: 54, trailPadding: 44, topPadding: 140, bottomPadding: 82, length: 338, radius: 44),
        WidgetInfo(deviceName: "iPhone11,2", leadPadding: 69, trailPadding: 57, topPadding: 183, bottomPadding: 105, length: 465, radius: 62),
        WidgetInfo(deviceName: "iPhone11,4", leadPadding: 81, trailPadding: 66, topPadding: 198, bottomPadding: 123, length: 507, radius: 66),
        WidgetInfo(deviceName: "iPhone11,6", leadPadding: 81, trailPadding: 66, topPadding: 198, bottomPadding: 123, length: 507, radius: 66),
        WidgetInfo(deviceName: "iPhone10,3", leadPadding: 69, trailPadding: 57, topPadding: 213, bottomPadding: 105, length: 465, radius: 62),
        WidgetInfo(deviceName: "iPhone10,6", leadPadding: 69, trailPadding: 57, topPadding: 213, bottomPadding: 105, length: 465, radius: 62),

        // iPhone 8
        WidgetInfo(deviceName: "iPhone10,1", leadPadding: 54, trailPadding: 50, topPadding: 60, bottomPadding: 56, length: 296, radius: 37),
        WidgetInfo(deviceName: "iPhone10,4", leadPadding: 54, trailPadding: 50, topPadding: 60, bottomPadding: 56, length: 296, radius: 37),
        WidgetInfo(deviceName: "iPhone10,2", leadPadding: 99, trailPadding: 102, topPadding: 114, bottomPadding: 111, length: 471, radius: 62),
        WidgetInfo(deviceName: "iPhone10,5", leadPadding: 99, trailPadding: 102, topPadding: 114, bottomPadding: 111, length: 471, radius: 62),

        // Simulator
        WidgetInfo(deviceName: "arm64", leadPadding: 81, trailPadding: 68, topPadding: 240, bottomPadding: 114, length: 474, radius: 65)
    ]

    // MARK: - Query Methods

    static func getBezel(for deviceName: String) -> Bezel? {
        guard let imageName = iphoneNameDictionary[deviceName] else { return nil }
        return bezels.first { $0.imageName == imageName }
    }

    static func getWidgetInfo(for deviceName: String) -> WidgetInfo? {
        return widgets.first { $0.deviceName == deviceName }
    }

    static func getWidgetRect(position: String, deviceName: String) -> CGRect {
        guard let widgetInfo = getWidgetInfo(for: deviceName) else {
            return .zero
        }

        let length = CGFloat(widgetInfo.length)
        let leadPadding = widgetInfo.leadPadding
        let trailPadding = widgetInfo.trailPadding
        let topPadding = widgetInfo.topPadding
        let bottomPadding = widgetInfo.bottomPadding

        switch position {
        case "11":
            return CGRect(x: leadPadding, y: topPadding, width: length, height: length)
        case "12":
            return CGRect(x: leadPadding + Double(length) + trailPadding, y: topPadding, width: length, height: length)
        case "13":
            return CGRect(x: leadPadding, y: topPadding + Double(length) + bottomPadding, width: length, height: length)
        case "14":
            return CGRect(x: leadPadding + Double(length) + trailPadding, y: topPadding + Double(length) + bottomPadding, width: length, height: length)
        case "15":
            return CGRect(x: leadPadding, y: topPadding + 2 * Double(length) + 2 * bottomPadding, width: length, height: length)
        case "16":
            return CGRect(x: leadPadding + Double(length) + trailPadding, y: topPadding + 2 * Double(length) + 2 * bottomPadding, width: length, height: length)
        case "21":
            return CGRect(x: leadPadding, y: topPadding, width: Double(length * 2) + trailPadding, height: length)
        case "22":
            return CGRect(x: leadPadding, y: topPadding + Double(length) + bottomPadding, width: Double(length * 2) + trailPadding, height: length)
        case "23":
            return CGRect(x: leadPadding, y: topPadding + 2 * Double(length) + 2 * bottomPadding, width: Double(length * 2) + trailPadding, height: length)
        default:
            return .zero
        }
    }

    static func getCurrentDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
        return modelCode
    }

    static func getCurrentDeviceImageName() -> String? {
        let deviceModel = getCurrentDeviceModel()
        return iphoneNameDictionary[deviceModel]
    }
}
