//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 10.08.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func setSelectedDates(dates: [String])
}

final class ScheduleViewController: UIViewController {
    
    private var scheduleView: ScheduleView!
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private struct ScheduleViewControllerConstants {
        static let title = "Расписание"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleView = ScheduleView(
            frame: view.bounds,
            delegate: self
        )
        setupView()
    }
    
    private func setupView() {
        title =  ScheduleViewControllerConstants.title
        view.backgroundColor = .clear
        addScreenView(view: scheduleView)
    }
    
    deinit {
        print("ScheduleViewController deinit")
    }
}

extension ScheduleViewController: ScheduleViewDelegate {
    func setDates(dates: [String]?) {
        guard let dates, !dates.isEmpty else { return }
        delegate?.setSelectedDates(dates: dates)
    }
}
