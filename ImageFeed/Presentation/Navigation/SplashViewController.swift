//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.07.2024.
//

import UIKit

final class SplashViewController: UINavigationController {
    private let tokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColorSettings.backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let token = tokenStorage.token else {
            showAuthScreen()
            return
        }
        
        print("SplashViewController -> token", token)
        // TODO: get User Data
        print("switch to profile", token)
        switchToTabBarController()
    }
}

extension SplashViewController {
    // MARK: FUNCTIONS
    private func showAuthScreen() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        pushViewController(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = MainTabBarViewController()
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
}
