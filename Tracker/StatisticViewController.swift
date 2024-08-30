//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 07.07.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: -  properties
    private let colors = Colors()
    private let trackerRecordStore = TrackerRecordStore()
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - UI
    private let statisticTopLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = NSLS.statistics
        trackerLabel.textColor = .ypBlack
        trackerLabel.font = UIFont.boldSystemFont(ofSize: 34)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    private lazy var imageNoStatistics: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "noStat")
        return imageView
    }()
    
    private lazy var titleImageNoStatistics: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = "Анализировать пока нечего"
        label.font = UIFont.ypMediumSize12
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completedTrackerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var resultTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resultSubTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.ypMediumSize12
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBG
        setupViews()
        setupStatisticTopLabelConstraints()
        updateCompletedTrackers()
        trackerRecordStore.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        completedTrackerView.setGradientBorder(width: 1, colors: [.ypGradientColor1, .ypGradientColor2, .ypGradientColor3])
    }
    
    // MARK: - methods
    func updateCompletedTrackers() {
        completedTrackers = trackerRecordStore.trackerRecords
        resultTitle.text = "\(completedTrackers.count)"
        resultSubTitle.text = String.localizedStringWithFormat(NSLocalizedString("trackerCompleted", comment: "Число дней"), completedTrackers.count)
        imageNoStatistics.isHidden = completedTrackers.count > 0
        titleImageNoStatistics.isHidden = completedTrackers.count > 0
        completedTrackerView.isHidden = completedTrackers.count == 0
    }
    
    // MARK: -  UI methods
    private func setupViews() {
        view.addSubview(statisticTopLabel)
        view.addSubview(imageNoStatistics)
        view.addSubview(titleImageNoStatistics)
        view.addSubview(completedTrackerView)
        completedTrackerView.addSubview(resultSubTitle)
        completedTrackerView.addSubview(resultTitle)
    }
    
    private func setupStatisticTopLabelConstraints() {
        NSLayoutConstraint.activate([
            statisticTopLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            
            completedTrackerView.topAnchor.constraint(equalTo: statisticTopLabel.bottomAnchor, constant: 77),
            completedTrackerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completedTrackerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completedTrackerView.heightAnchor.constraint(equalToConstant: 90),
            
            imageNoStatistics.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageNoStatistics.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageNoStatistics.widthAnchor.constraint(equalToConstant: 80),
            imageNoStatistics.heightAnchor.constraint(equalToConstant: 80),
            
            titleImageNoStatistics.topAnchor.constraint(equalTo: imageNoStatistics.bottomAnchor, constant: 8),
            titleImageNoStatistics.centerXAnchor.constraint(equalTo: imageNoStatistics.centerXAnchor),
            
            resultTitle.topAnchor.constraint(equalTo: completedTrackerView.topAnchor, constant: 12),
            resultTitle.leadingAnchor.constraint(equalTo: completedTrackerView.leadingAnchor, constant: 12),
            resultTitle.trailingAnchor.constraint(equalTo: completedTrackerView.trailingAnchor, constant: -12),
            resultTitle.heightAnchor.constraint(equalToConstant: 41),
            
            resultSubTitle.bottomAnchor.constraint(equalTo: completedTrackerView.bottomAnchor, constant: -12),
            resultSubTitle.leadingAnchor.constraint(equalTo: completedTrackerView.leadingAnchor, constant: 12),
            resultSubTitle.trailingAnchor.constraint(equalTo: completedTrackerView.trailingAnchor, constant: -12),
            resultSubTitle.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

// MARK: - TrackerRecordStoreDelegate
extension StatisticViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        updateCompletedTrackers()
    }
}
