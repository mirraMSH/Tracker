//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Мария Шагина on 24.08.2024.
//

import UIKit

struct ColorPage {
    let backgroundImageName: String
    let onboardingInfoText: String
}

final class OnboardingViewController: UIViewController {
    
    //MARK: -  properties
    private var colorPage: ColorPage
    
    //MARK: UI
    private lazy var onboardingView: OnboardingView = {
        let view = OnboardingView(
            frame: view.frame,
            imageNamed: colorPage.backgroundImageName,
            infoLabelText: colorPage.onboardingInfoText)
        view.delegate = self
        return view
    }()
    
    // MARK: - initialization
    init(colorPage: ColorPage) {
        self.colorPage = colorPage
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addViews()
        activateConstraints()
    }
    
    //MARK: - methods
    private func setupView() {
        view.backgroundColor = .clear
    }
    
    private func addViews() {
        view.addSubview(onboardingView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showMainViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration")}
        let tabBarVC = UserTabBarViewController()
        window.rootViewController = tabBarVC
        UserDefaults.standard.set(true, forKey: Constants.firstEnabledUserDefaultsKey)
    }
}

// MARK: OnboardingViewDelegate
extension OnboardingViewController: OnboardingViewDelegate {
    func onboardingButtonTapped() {
        showMainViewController()
    }
}
