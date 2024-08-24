//
//  AddNewTrackerViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 10.08.2024.
//

import UIKit

protocol AddNewTrackerViewControllerDelegate: AnyObject {
    func didSelectTracker(with: AddNewTrackerViewController.TrackerType)
}

final class AddNewTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AddNewTrackerViewControllerDelegate?
    
    private var labelText = ""
    private var category: String?
    private var schedule: [Weekday]?
    private var emoji: String?
    private var color: UIColor?
    
    private var isConfirmButtonEnabled: Bool {
        labelText.count > 0 && !isValidationMessageVisible
    }
    
    private var isValidationMessageVisible = false
    private var parameters = ["Категория", "Расписание"]
    private let colors = UIColor.selection
    
    private lazy var addHabitButton: UIButton = {
        let button = Button(title: "Привычка")
        button.addTarget(self, action: #selector(didTapAddHabitButton), for: .touchUpInside)
        return button
    }()
    private lazy var addIrregularEventButton: UIButton = {
        let button = Button(title: "Нерегулярное событие")
        button.addTarget(self, action: #selector(didTapAddIrregularEventButton), for: .touchUpInside)
        return button
    }()
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapAddHabitButton() {
        title = "Новая привычка"
        delegate?.didSelectTracker(with: .habit)
    }
    
    @objc
    private func didTapAddIrregularEventButton() {
        delegate?.didSelectTracker(with: .irregularEvent)
    }
}

// MARK: - UIKit View elements

private extension AddNewTrackerViewController {
    func setupContent() {
        title = "Создание трекера"
        view.backgroundColor = .white
        
        view.addSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(addHabitButton)
        buttonsStack.addArrangedSubview(addIrregularEventButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addHabitButton.heightAnchor.constraint(equalToConstant: 60),
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension AddNewTrackerViewController {
    enum TrackerType {
        case habit, irregularEvent
    }
}
