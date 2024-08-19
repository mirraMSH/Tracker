//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Мария Шагина on 28.07.2024.
//

import UIKit

struct TrackerCategory {
    let id: UUID
    let label: String
    
    init(id: UUID = UUID(), label: String) {
        self.id = id
        self.label = label
    }
}
