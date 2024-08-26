//
//  SheduleView.swift
//  Tracker
//
//  Created by Мария Шагина on 26.08.2024.
//

import UIKit

protocol SheduleViewDelegate: AnyObject {
    func setDates(dates: [String]?)
}

final class SheduleView: UIView {
    
    // MARK: properties
    weak var delegate: SheduleViewDelegate?
    
    private struct SheduleViewConstant {
        static let collectionViewReuseIdentifier = "cell"
        static let addButtontitle = "Готово"
    }
    
    private var sheduleCollectionViewCellHelper: SheduleCollectionViewCellHelper?
    
    // MARK: ui
    private let sheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: SheduleViewConstant.collectionViewReuseIdentifier
        )
        collectionView.register(
            SheduleCollectionViewCell.self,
            forCellWithReuseIdentifier: SheduleCollectionViewCell.reuseIdentifire
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var addButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: SheduleViewConstant.addButtontitle
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
        delegate: SheduleViewDelegate?
    ) {
        self.delegate = delegate
        
        super.init(frame: frame)
        
        sheduleCollectionViewCellHelper = SheduleCollectionViewCellHelper()
        sheduleCollectionView.delegate = sheduleCollectionViewCellHelper
        sheduleCollectionView.dataSource = sheduleCollectionViewCellHelper
        
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
            sheduleCollectionView,
            addButton
        )
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            sheduleCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            sheduleCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            sheduleCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            sheduleCollectionView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
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
            let weeDayNumber = [ "Пн": 0, "Вт": 1, "Ср": 2, "Чт": 3, "Пт": 4, "Сб": 5, "Вс": 6]
            let sortDays = self.sheduleCollectionViewCellHelper?.selectedDates.sorted(by: { weeDayNumber[$0] ?? 7 < weeDayNumber[$1] ?? 7
            })
            self.delegate?.setDates(dates: sortDays)
        }
    }
}
