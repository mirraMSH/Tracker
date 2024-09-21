//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import UIKit

protocol CreateCategoryVCDelegate {
    func createdCategory(_ category: TrackerCategory)
}

final class CreateCategoryVC: UIViewController {
    
    // MARK: - properties
    private let colors = Colors()
    var delegate: CreateCategoryVCDelegate?
    
    // MARK: -  UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = "Новая категория"
        label.font = UIFont.ypMediumSize16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.indent(size: 10)
        textField.placeholder = "Введите название категории"
        textField.textColor = .ypBlack
        textField.backgroundColor = .backgroundColor
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        UITextField.appearance().clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: -  actions
    @objc func textFieldChanged() {
        if textField.text != "" {
            addCategoryButton.backgroundColor = .ypBlack
            addCategoryButton.isEnabled = true
        } else {
            addCategoryButton.backgroundColor = .gray
            addCategoryButton.isEnabled = false
        }
    }
    
    @objc func addCategoryButtonAction() {
        if let categoryName = textField.text {
            let category = TrackerCategory(title: categoryName, trackers: [])
            try? trackerCategoryStore.addNewTrackerCategory(category)
            delegate?.createdCategory(category)
            dismiss(animated: true)
        }
    }
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBG
        addSubviews()
        setupLayout()
    }
    
    // MARK: - UI methods
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(addCategoryButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UITextFieldDelegate
extension CreateCategoryVC: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
