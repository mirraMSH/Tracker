//
//  PageViewControllerFactory.swift
//  Tracker
//
//  Created by Мария Шагина on 26.08.2024.
//

import UIKit

final class PageViewControllerFactory {
    var viewControllers: [UIViewController] = ColorPageType.allCases.compactMap { $0.viewControllers }
}
