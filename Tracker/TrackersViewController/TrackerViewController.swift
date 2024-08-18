//
//  ViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 04.07.2024.
//

import UIKit

class TrackerViewController: UIViewController {
    
    // MARK: - Properties
    private var categories: [TrackerCategory] = TrackerCategory.sampleData
    private var currentDate = Date.from(date: Date())!
    private var searchText = ""
    private var completedTrackers: Set<TrackerRecord> = []
    private var visibleCategories: [TrackerCategory] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        
        var result = [TrackerCategory]()
        
        for category in categories {
            let trackersByDay = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return true }
                return schedule.contains(Weekday.allCases[weekday > 1 ? weekday - 2 : weekday + 5])
            }
            
            let filteredTrackers = searchText.isEmpty ? trackersByDay : trackersByDay.filter {
                $0.label.lowercased().contains(searchText.lowercased())
            }
            
            if !filteredTrackers.isEmpty {
                result.append(TrackerCategory(label: category.label, trackers: filteredTrackers))
            }
        }
        
        notFoundStack.isHidden = !result.isEmpty
        filterButton.isHidden = result.isEmpty
        
        return result
    }
    
    private let options = UICollectionView.GeometricOptions(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 10)
    
    // MARK: - Properties of UIKit View elements
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(TrackerCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        return collectionView
    }()
    
    private var searchBar: UISearchTextField = {
        let searchBar = UISearchTextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.returnKeyType = .done
        searchBar.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return searchBar
    }()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = Calendar(identifier: .iso8601)
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    private let emptyListImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptytrackerList")
        return imageView
    }()
    
    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Что будем отслеживать?"
        label.textColor = .black
        return label
    }()
    
    private lazy var notFoundStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "ypBlue")
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        updateUI()
        setupNavBarItems()
        view.backgroundColor = .ypWhite
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(emptyListImage)
        view.addSubview(emptyListLabel)
        view.addSubview(collectionView)
        view.addSubview(notFoundStack)
        view.addSubview(filterButton)
        
        notFoundStack.addArrangedSubview(emptyListImage)
        notFoundStack.addArrangedSubview(emptyListLabel)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 54),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            notFoundStack.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            notFoundStack.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func updateUI() {
        if categories.isEmpty {
            collectionView.isHidden = true
            notFoundStack.isHidden = false
        } else {
            collectionView.isHidden = false
            notFoundStack.isHidden = true
            collectionView.reloadData()
        }
    }
    
    private func setupNavBarItems() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        
        let addTrackerLabel = UIBarButtonItem(image: UIImage(named: "Add tracker"), style: .plain, target: self, action: #selector(Self.didTapPlusButton))
        addTrackerLabel.tintColor = .black
        self.navigationItem.leftBarButtonItem = addTrackerLabel
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.datePicker)
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
    }
    
    // MARK: - Actions
    
    @objc
    private func cancelButtonTapped() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    @objc
    private func didTapPlusButton() {
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addNewTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func searchTextChanged() {
        reloadVisibleCategories()
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: currentDate)
        let filterText = (searchBar.text ?? "").lowercased()
    }
    
    @objc
    private func didChangedDatePicker(_ sender: UIDatePicker) {
        currentDate = Date.from(date: sender.date)!
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        trackerCell.configure(with: tracker, days: daysCount, isCompleted: isCompleted)
        trackerCell.delegate = self
        return trackerCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableSpace = collectionView.frame.width - options.paddingWidth
        let cellWidth = availableSpace / options.cellCount
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(top: 8, left: options.leftInset, bottom: 16, right: options.rightInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackerCategoryLabel
        else { return UICollectionReusableView() }
        
        let label = visibleCategories[indexPath.section].label
        view.configure(with: label)
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

// MARK: - UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        reloadVisibleCategories()
        
        return true
    }
}

// MARK: - TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func didTapCompleteButton(of cell: TrackerCell, with tracker: Tracker) {
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if completedTrackers.contains(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            completedTrackers.remove(trackerRecord)
            cell.toggleCompletedButton(to: false)
            cell.decreaseCount()
        } else {
            completedTrackers.insert(trackerRecord)
            cell.toggleCompletedButton(to: true)
            cell.increaseCount()
        }
    }
}

// MARK: - AddNewTrackerViewControllerDelegate
extension TrackerViewController: AddNewTrackerViewControllerDelegate {
    func didSelectTracker(with type: AddNewTrackerViewController.TrackerType) {
        dismiss(animated: true)
        let newTrackerCreationViewController = NewTrackerCreationViewController(type: type)
        newTrackerCreationViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newTrackerCreationViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - NewTrackerCreationViewControllerDelegate
extension TrackerViewController: NewTrackerCreationViewControllerDelegate {
    func didTapConfirmButton(categoryLabel: String, trackerToAdd: Tracker) {
        dismiss(animated: true)
        guard let categoryIndex = categories.firstIndex(where: { $0.label == categoryLabel }) else { return }
        let updatedCategory = TrackerCategory(
            label: categoryLabel,
            trackers: categories[categoryIndex].trackers + [trackerToAdd]
        )
        categories[categoryIndex] = updatedCategory
        collectionView.reloadData()
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
}
