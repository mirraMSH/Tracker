//
//  CreateNewTypeCategoryVC.swift
//  Tracker
//
//  Created by Мария Шагина on 29.08.2024.
//
import UIKit

protocol CreateNewTypeCategoryDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, categoryName: String)
}

class CreateNewTypeCategoryVC: UIViewController {
    private let colors = Colors()
    public weak var delegate: CreateNewTypeCategoryDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = "Создание трекера"
        label.font = UIFont.ypMediumSize16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createRegularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLS.transHabit, for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(regularEventButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLS.irregularEvent, for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(irregularEventButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBG
        addSubviews()
        setupLayout()
    }
    
    @objc private func irregularEventButtonAction() {
        let vc = CreateEventVC(.irregular)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func regularEventButtonAction() {
        let vc = CreateEventVC(.regular)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(createRegularEventButton)
        view.addSubview(createIrregularEventButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            createRegularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createRegularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createRegularEventButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 295),
            createRegularEventButton.widthAnchor.constraint(equalToConstant: 335),
            createRegularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            createIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createIrregularEventButton.topAnchor.constraint(equalTo: createRegularEventButton.bottomAnchor, constant: 16),
            createIrregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            createIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension CreateNewTypeCategoryVC: CreateEventVCDelegate {
    func createTracker(_ tracker: Tracker, categoryName: String) {
        delegate?.createTracker(tracker, categoryName: categoryName)
    }
}

extension CreateNewTypeCategoryVC: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
