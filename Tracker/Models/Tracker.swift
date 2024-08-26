//
//  Tracker.swift
//  Tracker
//
//  Created by Мария Шагина on 28.07.2024.
//

import UIKit

struct Tracker {
    let id: String
    let name: String
    let color: UIColor?
    let emoji: String
    let schedule: [String]?
}

extension Tracker: Equatable {
    static func == (lrh: Tracker, rhs: Tracker) -> Bool {
        lrh.id == rhs.id
    }
}
