//
//  FilterVC.swift
//  Tracker
//
//  Created by Мария Шагина on 29.08.2024.
//

import UIKit

protocol FiltersVCDelegate: AnyObject {
    func filterSelected(filter: Filter)
}

final class FiltersVC: UIViewController {
    // MARK: - properies
    private let colors = Colors()
    weak var delegate: FiltersVCDelegate?
    
    private let filters: [Filter] = Filter.allCases
    var selectedFilter: Filter?
    
    // MARK: -  UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = NSLS.filtersButtonTitle
        label.font = UIFont.ypMediumSize16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCollectionViewCell.self, forCellReuseIdentifier: CategoryCollectionViewCell.identifier)
        tableView.separatorColor = .ypGray
        tableView.backgroundColor = .ypWhite
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: -  override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBG
        addSubviews()
        setupLayout()
    }
    
    // MARK: - UI methods
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension FiltersVC: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return filters.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let filterCell = tableView.dequeueReusableCell(withIdentifier: CategoryCollectionViewCell.identifier) as? CategoryCollectionViewCell else {
            return UITableViewCell()
        }
        let filter = filters[indexPath.row]
        filterCell.checkmarkImage.isHidden = filter != selectedFilter
        filterCell.label.text = filters[indexPath.row].rawValue
        if indexPath.row == filters.count - 1 {
            filterCell.separatorInset = UIEdgeInsets(top: 0, left: filterCell.bounds.size.width + 200, bottom: 0, right: 0);
            filterCell.contentView.clipsToBounds = true
            filterCell.contentView.layer.cornerRadius = 16
            filterCell.contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == 0 {
            filterCell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            filterCell.contentView.clipsToBounds = true
            filterCell.contentView.layer.cornerRadius = 16
            filterCell.contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            filterCell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            filterCell.contentView.layer.cornerRadius = 0
        }
        filterCell.selectionStyle = .none
        return filterCell
    }
}

// MARK: - UITableViewDelegate
extension FiltersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let filterCell = tableView.cellForRow(at: indexPath) as? CategoryCollectionViewCell else {
            return
        }
        let filter = filters[indexPath.row]
        delegate?.filterSelected(filter: filter)
        dismiss(animated: true)
    }
}
