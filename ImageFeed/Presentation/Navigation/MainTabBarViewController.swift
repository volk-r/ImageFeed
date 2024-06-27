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
        
        UINavigationBar.appearance().barTintColor = AppColorSettings.backgroundColor
        UINavigationBar.appearance().tintColor = .white
        
        setupControllers()
    }
    
    private func setupControllers() {
        let navigationControllerFeed = UINavigationController(rootViewController: ImagesListVC)
        let navigationControllerProfile = UINavigationController(rootViewController: profileVC)
        navigationControllerProfile.navigationBar.isHidden = true
        
        ImagesListVC.tabBarItem.image = UIImage(named: "tab_editorial_active")
        ImagesListVC.title = ""
        profileVC.tabBarItem.image = UIImage(named: "tab_profile_active")
        profileVC.title = ""
        
        viewControllers = [navigationControllerFeed, navigationControllerProfile]
    }
}
