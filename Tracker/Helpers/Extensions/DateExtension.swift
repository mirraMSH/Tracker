//
//  DateExtension.swift
//  Tracker
//
//  Created by Мария Шагина on 29.07.2024.
//

import Foundation

extension Date {
    var getDate: Date {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let date = Calendar.current.date(from: dateComponents)
        return date?.addingTimeInterval(24*3600) ?? Date()
    }
    
    static func getStringWeekday(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let date = dateFormatter.string(from: date)
        return date
    }
}
