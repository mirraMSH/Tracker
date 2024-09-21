//
//  TabBarController.swift
//  Tracker
//
//  Created by Мария Шагина on 20.07.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    // MARK: - methods
    private func generateTabBar() {
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor(red:0.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha:0.2).cgColor
        tabBar.clipsToBounds = true
    }
    
    // MARK: - class tabbar elements params
    class func configure() -> UIViewController {
        let trackersViewController = UINavigationController(rootViewController: TrackerViewController())
        trackersViewController.tabBarItem.image = UIImage(named: "trackers")
        let statisticsViewController = UINavigationController(rootViewController: StatisticViewController())
        statisticsViewController.tabBarItem.image = UIImage(named: "stats")
        statisticsViewController.title = NSLS.statistics
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [trackersViewController, statisticsViewController]
        return tabBarController
    }
}
