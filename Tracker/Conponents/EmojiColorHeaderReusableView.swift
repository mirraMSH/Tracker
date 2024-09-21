//
//  EmojiColorHeaderReusableView.swift
//  Tracker
//
//  Created by Мария Шагина on 29.08.2024.
//

import UIKit

final class EmojiColorHeaderReusableView: UICollectionReusableView {
    
    static let identifier = "header"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypBoldSize19
        label.textColor = .ypBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubview()
        activateConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String?) {
        titleLabel.text = title
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func addSubview() {
        addSubview(titleLabel)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
