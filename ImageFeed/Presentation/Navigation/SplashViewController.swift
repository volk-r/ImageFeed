//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.07.2024.
//

import UIKit

final class SplashViewController: UINavigationController {
    private let tokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColorSettings.backgroundColor
        navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let token = tokenStorage.token else {
            showAuthScreen()
            return
        }
        
        fetchProfile(token)
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
    
    // MARK: fetchProfile
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case .success:
               self.switchToTabBarController()

            case .failure:
                // TODO: [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = tokenStorage.token else {
            return
        }
        
        fetchProfile(token)
    }
}
