//
//  WeekdayExtention.swift
//  Tracker
//
//  Created by Мария Шагина on 18.08.2024.
//

import Foundation

extension Weekday {
    static func code(_ weekdays: [Weekday]?) -> String? {
        guard let weekdays else { return nil }
        let indexes = weekdays.map { Self.allCases.firstIndex(of: $0) }
        var result = ""
        for i in 0..<7 {
            if indexes.contains(i) {
                result += "1"
            } else {
                result += "0"
            }
        }
        return result
    }
    
    static func decode(from string: String?) -> [Weekday]? {
        guard let string else { return nil }
        var weekdays = [Weekday]()
        for (index, value) in string.enumerated() {
            guard value == "1" else { continue }
            let weekday = Self.allCases[index]
            weekdays.append(weekday)
        }
        return weekdays
    }
}
