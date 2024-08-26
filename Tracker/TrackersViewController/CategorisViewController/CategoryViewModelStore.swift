//
//  CategoryViewModelStore.swift
//  Tracker
//
//  Created by Мария Шагина on 26.08.2024.
//

import Foundation

class CategoriesViewModelStore {
    private let categoryStore = TrackerCategoryStore()
    
    func deleteCategory(_ category: TrackerCategoryCoreData) {
        categoryStore.deleteCategory(delete: category)
    }
}
