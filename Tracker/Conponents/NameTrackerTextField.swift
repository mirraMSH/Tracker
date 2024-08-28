//
//  NameTrackerTextField.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import UIKit

final class TrackerTextField: UITextField {
    
    private let inset: CGFloat = 16
    
    init(frame: CGRect, placeholderText: String?) {
        super.init(frame: frame)
        setupView(placeholderText: placeholderText)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: inset, dy: inset)
    }
    
    private func setupView(placeholderText: String?) {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.ypRegularSize17
        textColor = .ypBlack
        backgroundColor = .ypBackgroundday
        placeholder = placeholderText
        returnKeyType = UIReturnKeyType.go
        keyboardType = UIKeyboardType.default
        clearButtonMode = .whileEditing
        layer.cornerRadius = 16
    }
}

