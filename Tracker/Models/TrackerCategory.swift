//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Мария Шагина on 28.07.2024.
//

import UIKit

struct TrackerCategory {
    let label: String
    let trackers: [Tracker]
    
    init(label: String, trackers: [Tracker]) {
        self.label = label
        self.trackers = trackers
    }
}
