//
//  DateExtension.swift
//  Tracker
//
//  Created by Мария Шагина on 29.07.2024.
//

import Foundation

extension Date {
    var yearMonthDayComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
}
