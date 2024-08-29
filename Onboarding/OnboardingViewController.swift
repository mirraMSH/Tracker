//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 24.08.2024.
//
import UIKit

class OnboardingViewController: UIPageViewController {
    
    // MARK: - properties
    let analyticsService = AnalyticsService()
    private lazy var pages: [UIViewController] = {
        return [blueVC, redVC]
    }()
    
    // MARK: - UI
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = UIColor.ypBlack.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var blueVC: UIViewController = {
        let blueVC = UIViewController()
        let image = "OnboardingBlue"
        let imageView = UIImageView(frame: blueVC.view.frame)
        imageView.image = UIImage(named: image)
        blueVC.view.addSubview(imageView)
        return blueVC
    }()
    
    private lazy var redVC: UIViewController = {
        let redVC = UIViewController()
        let image = "OnboardingRed"
        let imageView = UIImageView(frame: redVC.view.frame)
        imageView.image = UIImage(named: image)
        redVC.view.addSubview(imageView)
        return redVC
    }()
    
    private lazy var blueVCLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Отслеживайте только то, что хотите"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var blueVCEnterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(enterButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var redVCLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Даже если это не литры воды и йога"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var redVCEnterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(enterButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        blueVC.overrideUserInterfaceStyle = .light
        redVC.overrideUserInterfaceStyle = .light
        
        if let first = pages.first { setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        addBlueVC()
        addRedVC()
        addPageControl()
    }
    
    // MARK: - methods
    private func addBlueVC() {
        blueVC.view.addSubview(blueVCLabel)
        blueVC.view.addSubview(blueVCEnterButton)
        
        NSLayoutConstraint.activate([
            blueVCLabel.bottomAnchor.constraint(equalTo: blueVC.view.safeAreaLayoutGuide.bottomAnchor, constant: -290),
            blueVCLabel.centerXAnchor.constraint(equalTo: blueVC.view.safeAreaLayoutGuide.centerXAnchor),
            blueVCLabel.widthAnchor.constraint(equalToConstant: 343),
            
            blueVCEnterButton.heightAnchor.constraint(equalToConstant: 60),
            blueVCEnterButton.leadingAnchor.constraint(equalTo: blueVC.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            blueVCEnterButton.trailingAnchor.constraint(equalTo: blueVC.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            blueVCEnterButton.bottomAnchor.constraint(equalTo: blueVC.view.safeAreaLayoutGuide.bottomAnchor, constant: -71)
        ])
    }
    
    private func addRedVC() {
        redVC.view.addSubview(redVCLabel)
        redVC.view.addSubview(redVCEnterButton)
        
        NSLayoutConstraint.activate([
            redVCLabel.bottomAnchor.constraint(equalTo: redVC.view.safeAreaLayoutGuide.bottomAnchor, constant: -290),
            redVCLabel.centerXAnchor.constraint(equalTo: redVC.view.safeAreaLayoutGuide.centerXAnchor),
            redVCLabel.widthAnchor.constraint(equalToConstant: 343),
            
            redVCEnterButton.heightAnchor.constraint(equalToConstant: 60),
            redVCEnterButton.leadingAnchor.constraint(equalTo: redVC.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            redVCEnterButton.trailingAnchor.constraint(equalTo: redVC.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            redVCEnterButton.bottomAnchor.constraint(equalTo: redVC.view.safeAreaLayoutGuide.bottomAnchor, constant: -71)
        ])
    }
    
    private func addPageControl() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -155),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func enterButtonAction() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        window.rootViewController = TabBarController.configure()
        UserDefaults.standard.set(true, forKey: "isOnbordingShown")
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool)
    {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
