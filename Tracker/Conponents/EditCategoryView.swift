//
//  EditCategoryView.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import UIKit

protocol EditCategoryViewDelegate: AnyObject {
    func editCategory(category: String?)
}

final class EditCategoryView: UIView {
    
    // MARK: properties
    weak var delegate: EditCategoryViewDelegate?
    
    private struct CategoryViewConstant {
        static let editButtonTitle = "Готово"
        static let editCategoryTextFieldPlaceholderText = "Введите название категории"
    }
    
    private var editCategoryViewTextFieldHelper = EditCategoryViewTextFieldHelper()
    private var oldCategoryName: String?
    
    // MARK: UI
    private lazy var editCategoryTextField: TrackerTextField = {
        let textField = TrackerTextField(
            frame: .zero,
            placeholderText: CategoryViewConstant.editCategoryTextFieldPlaceholderText
        )
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    
    private lazy var editButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: CategoryViewConstant.editButtonTitle
        )
        button.addTarget(
            self,
            action: #selector(editButtonTapped),
            for: .touchUpInside
        )
        button.backgroundColor = .ypGray
        button.isEnabled = false
        return button
    }()
    
    init(
        frame: CGRect,
        delegate: EditCategoryViewDelegate?
    ) {
        self.delegate = delegate
        super.init(frame: frame)
        
        editCategoryTextField.delegate = editCategoryViewTextFieldHelper
        
        setupView()
        addSubviews()
        activateConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    func setTextFieldText(text: String?) {
        oldCategoryName = text
        editCategoryTextField.text = text
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .ypWhite
    }
    
    private func addSubviews() {
        addSubViews(
            editCategoryTextField,
            editButton
        )
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            editCategoryTextField.heightAnchor.constraint(equalToConstant: Constants.hugHeight),
            editCategoryTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            editCategoryTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            editCategoryTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            editButton.heightAnchor.constraint(equalToConstant: Constants.hugHeight),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    private func editCategory() {
        guard editCategoryTextField.text != "",
              let categoryName = editCategoryTextField.text
        else { return }
        delegate?.editCategory(category: categoryName)
    }
    
    // MARK: actions
    @objc
    private func editButtonTapped() {
        editButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.editCategory()
        }
    }
    
    @objc private func textFieldChanged() {
        if editCategoryTextField.text?.isEmpty == false {
            editButton.backgroundColor = .ypBlack
            editButton.isEnabled = true
        } else {
            editButton.backgroundColor = .ypGray
            editButton.isEnabled = false
        }
    }
}
