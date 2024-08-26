//
//  TypeTrackerViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 10.08.2024.
//

import UIKit

enum TypeTracker {
    case habit
    case event
}

protocol TypeTrackerViewControllerDelegate: AnyObject {
    func dismissViewController(_ viewController: UIViewController)
}

final class TypeTrackerViewController: UIViewController {
    
    weak var delegate: TypeTrackerViewControllerDelegate?
    
    private var typeTrackerView: TypeTrackerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeTrackerView = TypeTrackerView(frame: .zero, delegate: self)
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = TypeTrackerViewControllerConstants.viewControllerTitle
        addScreenView(view: typeTrackerView)
    }
    
    deinit {
        print("TypeTrackerViewController deinit")
    }
}

// MARK: TypeTrackerViewDelegate
extension TypeTrackerViewController: TypeTrackerViewDelegate {
    func showIrregularEvents() {
        let viewController = createTrackerViewController(typeTracker: .event)
        present(viewController, animated: true)
    }
    
    func showHabit() {
        let viewController = createTrackerViewController(typeTracker: .habit)
        present(viewController, animated: true)
    }
}

extension TypeTrackerViewController {
    private struct TypeTrackerViewControllerConstants {
        static let viewControllerTitle = "Создание трекера"
    }
}

// MARK: create TrackerViewController
extension TypeTrackerViewController {
    private func createTrackerViewController(typeTracker: TypeTracker) -> UINavigationController {
        let viewController = CreateTrackerViewController()
        viewController.typeTracker = typeTracker
        viewController.delegate = self
        let navigationViewController = UINavigationController(rootViewController: viewController)
        return navigationViewController
    }
}

extension TypeTrackerViewController: CreateTrackerViewControllerDelegate {
    func dismissViewController(_ viewController: UIViewController) {
        delegate?.dismissViewController(viewController)
    }
}
