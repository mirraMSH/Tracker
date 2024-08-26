//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Мария Шагина on 13.08.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifire = "EmojiCollectionViewCell"
    
    var cellIsSelected = false {
        didSet {
            cellIsSelected ? showHighlightCell() : hideHighlightCell()
        }
    }
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypBoldSize32
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
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = Constants.cornerRadius
    }
    
    func config(emoji: String?) {
        emojiLabel.text = emoji
    }
    
    private func addSubview() {
        contentView.addSubview(emojiLabel)
    }
    
    private func showHighlightCell() {
        contentView.backgroundColor = .ypLightGray
    }
    
    private func hideHighlightCell() {
        contentView.backgroundColor = .clear
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
