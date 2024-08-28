//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Мария Шагина on 28.07.2024.
//

import UIKit

struct TrackerCategory {
    let title: String
}

extension TrackerCategory: Equatable {
    static func == (lrh: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lrh.title == rhs.title
    }
}
