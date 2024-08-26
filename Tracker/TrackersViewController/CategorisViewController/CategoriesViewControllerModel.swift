//
//  CategoriesViewControllerModel.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import Foundation

protocol CategoriesViewModelProtocol {
    func categoriesViewModel(with selectedCategory: String?) -> CategoriesCollectionViewModel
}

final class CategoriesViewModel {}

// MARK: CategoriesViewModelProtocol
extension CategoriesViewModel: CategoriesViewModelProtocol {
    func categoriesViewModel(with selectedCategory: String?) -> CategoriesCollectionViewModel {
        let categoryStore = TrackerCategoryStore()
        return CategoriesCollectionViewModel(selectedCategory: selectedCategory, categoryStore: categoryStore)
    }
}

