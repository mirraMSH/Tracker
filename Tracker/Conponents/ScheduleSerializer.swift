//
//  ScheduleSerializer.swift
//  Tracker
//
//  Created by Мария Шагина on 20.08.2024.
//

import UIKit

final class ScheduleSerializer {
    private let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    func serialize(_ days: [String]) -> String {
        var result = ""
        for day in weekdays {
            if days.contains(day) {
                result += "1"
            } else {
                result += "0"
            }
        }
        return result
    }
    
    func deserialize(_ string: String?) -> [String] {
        var result = [String]()
        if let string = string {
            for (index, char) in string.enumerated() {
                if char == "1" {
                    result.append(weekdays[index])
                }
            }
        }
        return result
    }
}
