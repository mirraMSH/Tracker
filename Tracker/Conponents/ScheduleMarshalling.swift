//
//  ScheduleMarshalling.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import Foundation

final class ScheduleMarshalling {
    
    func stringFromArray(array: [String]) -> String {
        return array.joined(separator: ",")
    }
    
    func arrayFromString(string: String) -> [String] {
        return string.components(separatedBy: ",")
    }
}
