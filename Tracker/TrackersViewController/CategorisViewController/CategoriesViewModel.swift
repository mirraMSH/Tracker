//
// CategoriesViewModel.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import Foundation

protocol CategoriesViewModelProtocol {
    func deleteCategory(_ category: TrackerCategoryCoreData)
    func categoriesViewModel(with selectedCategory: String?) -> CategoriesCollectionViewModel
}

final class CategoriesViewModel {
    let categoryStore = TrackerCategoryStore()
}

// MARK: CategoriesViewModelProtocol
extension CategoriesViewModel: CategoriesViewModelProtocol {
    
    func categoriesViewModel(with selectedCategory: String?) -> CategoriesCollectionViewModel {
        return CategoriesCollectionViewModel(selectedCategory: selectedCategory, categoryStore: categoryStore)
    }
    
    func deleteCategory(_ category: TrackerCategoryCoreData) {
        categoryStore.deleteCategory(delete: category)
    }
}

