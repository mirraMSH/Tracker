//
//  CategoryCollectionViewCell.swift
//  Tracker
//
//  Created by Мария Шагина on 25.08.2024.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let cellReuseIdentifier = "CategoryCollectionViewCell"
    
    private var viewModel: CategoryCellViewModelProtocol?
    
    private struct CategoryCollectionViewCellConstants {
        static let checkmarkImageName = "checkmark"
    }
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypRegularSize17
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            named: CategoryCollectionViewCellConstants.checkmarkImageName
        )?.withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.contentMode = .right
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
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
    
    override func prepareForReuse() {
        categoryLabel.text = nil
        checkmarkImageView.isHidden = true
        lineView.isHidden = false
    }
    
    func initialize(viewModel: CategoryCellViewModelProtocol?) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel else { return }
        categoryLabel.text = viewModel.categoryLabel
        checkmarkImageView.isHidden = viewModel.selectedCategory ? false : true
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .ypBackgroundday
    }
    
    func hideLineView() {
        lineView.isHidden = true
    }
    
    private func addSubview() {
        contentView.addSubViews(
            categoryLabel,
            checkmarkImageView,
            lineView
        )
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.indentationFromEdges),
            categoryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.indentationFromEdges),
            checkmarkImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            lineView.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
