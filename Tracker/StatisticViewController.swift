//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 07.07.2024.
//

import UIKit

class StatisticViewController: UIViewController {
    
    private let statisticTopLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Статистика"
        trackerLabel.textColor = .ypBlack
        trackerLabel.font = UIFont.boldSystemFont(ofSize: 34)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupViews()
        setupStatisticTopLabelConstraints()
        
    }
    
    private func setupViews() {
        view.addSubview(statisticTopLabel)
    }
    
    private func setupStatisticTopLabelConstraints() {
        NSLayoutConstraint.activate([
            statisticTopLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticTopLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }
    
    
    
}
