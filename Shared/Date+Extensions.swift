//
//  Date+Extensions.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation

extension Date {
    /// 현재 로케일에 맞게 날짜를 문자열로 변환
    func localizedString(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }

    /// "yyyy-MM-dd HH:mm:ss" 형식의 문자열로 변환
    func toStorageString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = Locale.current.timeZone
        return formatter.string(from: self)
    }

    /// "yyyy-MM-dd HH:mm:ss" 형식의 문자열에서 Date 생성
    static func fromStorageString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = Locale.current.timeZone
        return formatter.date(from: string)
    }

    /// 오늘의 시작 시간 (00:00:00)
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// 두 날짜 사이의 일수 차이 계산
    func daysBetween(_ other: Date) -> Int {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: self)
        let endDate = calendar.startOfDay(for: other)
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
}
