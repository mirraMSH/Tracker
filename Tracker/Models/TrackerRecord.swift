//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Мария Шагина on 28.07.2024.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let trackerId: UUID
    let date: Date
    
    init(id: UUID = UUID(), trackerId: UUID, date: Date) {
        self.id = id
        self.trackerId = trackerId
        self.date = date
    }
}
