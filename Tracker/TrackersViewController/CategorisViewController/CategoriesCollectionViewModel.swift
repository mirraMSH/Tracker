//
//  CategorisViewModel.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

protocol CategoriesCollectionViewModelProtocol {
    var numberOfRows: Int { get }
    var hidePlugView: Binding<Bool>? { get set }
    var needToUpdateCollectionView: Binding<Bool>? { get set }
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel?
    func getCategory(by indexPath: IndexPath) -> TrackerCategory?
    func didSelectCategory(by indexPath: IndexPath) -> TrackerCategoryCoreData?
    func updateCategories()
    func needToHidePlugView()
}

final class CategoriesCollectionViewModel {
    var hidePlugView: Binding<Bool>?
    var needToUpdateCollectionView: Binding<Bool>?
    
    private let categoryStore: TrackerCategoryStoreProtocol
    private var selectedCategory: String?
    
    init(selectedCategory: String?, categoryStore: TrackerCategoryStoreProtocol) {
        self.selectedCategory = selectedCategory
        self.categoryStore = categoryStore
    }
    
    deinit{
        print("CategoriesViewModel deinit")
    }
}

// MARK: CategoriesViewModelProtocol
extension CategoriesCollectionViewModel: CategoriesCollectionViewModelProtocol {
    var numberOfRows: Int {
        categoryStore.fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func didSelectCategory(by indexPath: IndexPath) -> TrackerCategoryCoreData? {
        categoryStore.getTrackerCategoryCoreData(by: indexPath)
    }
    
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel? {
        guard let category = categoryStore.getTrackerCategory(by: indexPath) else { return nil }
        let isSelected = selectedCategory == category.title
        return CategoryCellViewModel(category: category, isSelect: isSelected)
    }
    
    func getCategory(by indexPath: IndexPath) -> TrackerCategory? {
        categoryStore.getTrackerCategory(by: indexPath)
    }
    
    func updateCategories() {
        try? categoryStore.fetchedResultsController.performFetch()
        needToHidePlugView()
        needToUpdateCollectionView?(true)
    }
    
    func needToHidePlugView() {
        let needToHidePlugView = categoryStore.fetchedResultsController.sections?[0].numberOfObjects != 0
        needToHidePlugView ? hidePlugView?(true) : hidePlugView?(false)
    }
}
