//
//  ScheduleCategoryTableViewModel.swift
//  Tracker
//
//  Created by Мария Шагина on 26.08.2024.
//

import Foundation

struct ScheduleCategoryTableViewModel {
    let name: String
    var description: String?
}

extension ScheduleCategoryTableViewModel: Equatable {
    static func == (lrh: ScheduleCategoryTableViewModel, rhs: ScheduleCategoryTableViewModel) -> Bool {
        lrh.description == rhs.description
    }
}
