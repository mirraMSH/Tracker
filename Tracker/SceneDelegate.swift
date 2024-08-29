//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Мария Шагина on 04.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if UserDefaults.standard.value(forKey: "isOnbordingShown") == nil {
            window?.rootViewController = OnboardingViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        } else {
            window?.rootViewController = TabBarController.configure()
        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        DatabaseManager.shared.saveContext()
    }
}
/*
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 guard let windowScene = (scene as? UIWindowScene) else { return }
 window = UIWindow(windowScene: windowScene)
 let viewController = createViewController()
 window?.rootViewController = viewController
 window?.makeKeyAndVisible()
 }
 
 private func createViewController() -> UIViewController {
 let isEnabled = UserDefaults.standard.bool(forKey: Constants.firstEnabledUserDefaultsKey)
 
 if isEnabled {
 return UserTabBarViewController()
 } else {
 let pagesFactory = PageViewControllerFactory()
 let pageViewController = PageViewController(pagesFactory: pagesFactory)
 return pageViewController
 }
 }*/

