//
//  TrackerCategoryExtension.swift
//  Tracker
//
//  Created by Мария Шагина on 29.07.2024.
//

import UIKit

extension TrackerCategory {
    static let sampleData: [TrackerCategory] = [
        TrackerCategory(
            label: "Уборка",
            trackers: [
                Tracker(
                    label: "Помыть посуду",
                    emoji: "🍽",
                    color: UIColor(named: "Color selection 15")!,
                    schedule: [.saturday]
                )
            ]
        )
    ]
}
