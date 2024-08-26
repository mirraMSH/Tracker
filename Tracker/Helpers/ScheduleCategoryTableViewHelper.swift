//
//  ScheduleCategoryTableViewHelper.swift
//  Tracker
//
//  Created by Мария Шагина on 26.08.2024.
//

import UIKit

protocol ScheduleCategoryTableViewHelperDelegate: AnyObject {
    func showCategory()
    func showSchedule()
    func reloadTableView()
}

final class ScheduleCategoryTableViewHelper: NSObject {
    
    private var typeTracker: TypeTracker
    private var cellsTitle = [
        ScheduleCategoryTableViewModel(name: "Категория", description: nil),
        ScheduleCategoryTableViewModel(name: "Расписание", description: nil),
    ]
    
    weak var delegate: ScheduleCategoryTableViewHelperDelegate?
    
    init(typeTracker: TypeTracker) {
        self.typeTracker = typeTracker
    }
    
    func setCategory(category: String?) {
        cellsTitle[0].description = category
        delegate?.reloadTableView()
    }
    
    func setSchedule(schedule: String?) {
        cellsTitle[1].description = schedule
        delegate?.reloadTableView()
    }
    
    private func cellConfig(cell: UITableViewCell) {
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.ypRegularSize17
        cell.detailTextLabel?.font = UIFont.ypRegularSize17
        cell.detailTextLabel?.textColor = .ypGray
        cell.backgroundColor = .ypBackgroundday
    }
}

// MARK: UITableViewDelegate
extension ScheduleCategoryTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.hugHeight
    }
}

// MARK: UITableViewDataSource
extension ScheduleCategoryTableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeTracker {
        case .habit:
            return 2
        case .event:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cellConfig(cell: cell)
        cell.textLabel?.text = cellsTitle[indexPath.row].name
        cell.detailTextLabel?.text = cellsTitle[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.showCategory()
        case 1:
            delegate?.showSchedule()
        default:
            break
        }
    }
}
