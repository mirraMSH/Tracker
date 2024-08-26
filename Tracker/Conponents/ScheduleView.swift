//
//  ScheduleView.swift
//  Tracker
//
//  Created by Мария Шагина on 26.08.2024.
//

import UIKit

protocol ScheduleViewDelegate: AnyObject {
    func setDates(dates: [String]?)
}

final class ScheduleView: UIView {
    
    // MARK: properties
    weak var delegate: ScheduleViewDelegate?
    
    private struct ScheduleViewConstant {
        static let collectionViewReuseIdentifier = "cell"
        static let addButtonTitle = "Готово"
    }
    
    private var scheduleCollectionViewCellHelper: ScheduleCollectionViewCellHelper?
    
    // MARK: ui
    private let scheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: ScheduleViewConstant.collectionViewReuseIdentifier
        )
        collectionView.register(
            ScheduleCollectionViewCell.self,
            forCellWithReuseIdentifier: ScheduleCollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var addButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: ScheduleViewConstant.addButtonTitle
        )
        button.addTarget(
            self,
            action: #selector(addButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: init
    init(
        frame: CGRect,
        delegate: ScheduleViewDelegate?
    ) {
        self.delegate = delegate
        
        super.init(frame: frame)
        
        scheduleCollectionViewCellHelper = ScheduleCollectionViewCellHelper()
        scheduleCollectionView.delegate = scheduleCollectionViewCellHelper
        scheduleCollectionView.dataSource = scheduleCollectionViewCellHelper
        
        setupView()
        addSubviews()
        activateConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .ypWhite
    }
    
    private func addSubviews() {
        addSubViews(
            scheduleCollectionView,
            addButton
        )
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            scheduleCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            scheduleCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            scheduleCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            scheduleCollectionView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 75),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    // MARK: actions
    @objc
    private func addButtonTapped() {
        addButton.showAnimation { [weak self] in
            guard let self = self else { return }
            let weekDayNumber = Constants.rowOfWeekdays
            let sortDays = self.scheduleCollectionViewCellHelper?.selectedDates.sorted(by: { weekDayNumber[$0] ?? 7 < weekDayNumber[$1] ?? 7
            })
            self.delegate?.setDates(dates: sortDays)
        }
    }
}
