//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 15.06.2024.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    private let profileVC = ProfileViewController()
    private let ImagesListVC = ImagesListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = AppColorSettings.backgroundColor
        UITabBar.appearance().tintColor = .white
        
        setupControllers()
    }
    
    private func setupControllers() {
        let navigationControllerFeed = UINavigationController(rootViewController: ImagesListVC)
        let navigationControllerProfile = UINavigationController(rootViewController: profileVC)
        navigationControllerFeed.navigationBar.isHidden = true
        
        ImagesListVC.tabBarItem.title = "Лента"
        ImagesListVC.tabBarItem.image = UIImage(named: "tab_editorial_active")
        
        profileVC.tabBarItem.title = "Профиль"
        profileVC.tabBarItem.image = UIImage(named: "tab_profile_active")
        
        viewControllers = [navigationControllerFeed, navigationControllerProfile]
    }
}
