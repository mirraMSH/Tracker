//
//  Tracker.swift
//  Tracker
//
//  Created by Мария Шагина on 28.07.2024.
//

import UIKit

struct Tracker: Identifiable {
    let id: UUID
    let label: String
    let emoji: String
    let color: UIColor
    let completedDaysCount: Int
    let schedule: [Weekday]?
    
    init(id: UUID = UUID(), label: String, emoji: String, color: UIColor, completedDaysCount: Int, schedule: [Weekday]?) {
        self.id = id
        self.label = label
        self.emoji = emoji
        self.color = color
        self.completedDaysCount = completedDaysCount
        self.schedule = schedule
        
    }
    
    init(tracker: Tracker) {
        self.id = tracker.id
        self.label = tracker.label
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.completedDaysCount = tracker.completedDaysCount
        self.schedule = tracker.schedule
    }
    
    init(data: Data) {
        guard let emoji = data.emoji, let color = data.color else { fatalError() }
        
        self.id = UUID()
        self.label = data.label
        self.emoji = emoji
        self.color = color
        self.completedDaysCount = data.completedDaysCount
        self.schedule = data.schedule
    }
    
    var data: Data {
        Data(label: label, emoji: emoji, color: color, completedDaysCount: completedDaysCount, schedule: schedule)
    }
}
