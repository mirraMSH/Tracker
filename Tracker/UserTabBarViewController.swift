//
//  UserTabBarViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 20.07.2024.
//

import UIKit

class UserTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    func configureTabs() {
        let vc1 = TrackerViewController()
        let vc2 = StatisticViewController()
        
        vc1.tabBarItem.image = UIImage(named: "trackers")
        vc2.tabBarItem.image = UIImage(named: "stats")
        
        vc1.tabBarItem.title = "Трекеры"
        vc2.tabBarItem.title = "Статистика"
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        tabBar.tintColor = .ypBlue
        tabBar.backgroundColor = .ypWhite
        
        setViewControllers([nav1, nav2], animated: true)
    }
}
