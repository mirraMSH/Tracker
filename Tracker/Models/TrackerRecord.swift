//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Мария Шагина on 28.07.2024.
//

import Foundation

struct TrackerRecord: Hashable {
    let checkDate: Date
}

extension TrackerRecord: Equatable {
    static func == (lrh: TrackerRecord, rhs: TrackerRecord) -> Bool {
        lrh.checkDate == rhs.checkDate
    }
}
