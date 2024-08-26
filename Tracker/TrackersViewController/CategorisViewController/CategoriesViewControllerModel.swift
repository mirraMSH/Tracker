//
//  CategoriesViewControllerModel.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import Foundation

protocol CategoriesViewControllerViewModelProtocol {
    func categoriesViewModel(with selectedCategory: String?) -> CategoriesViewModel
}

final class CategoriesViewControllerViewModel {}

// MARK: CategoriesViewModelProtocol
extension CategoriesViewControllerViewModel: CategoriesViewControllerViewModelProtocol {
    func categoriesViewModel(with selectedCategory: String?) -> CategoriesViewModel {
        let categoryStore = TrackerCategoryStore()
        return CategoriesViewModel(selectedCategory: selectedCategory, categoryStore: categoryStore)
    }
}

