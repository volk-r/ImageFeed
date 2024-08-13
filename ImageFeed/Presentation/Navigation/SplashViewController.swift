//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.07.2024.
//

import UIKit

final class SplashViewController: UINavigationController {
    private let tokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
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
            case .success(let profileData):
                ProfileImageService.shared.fetchProfileImageURL(username: profileData.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                callAlert()
            }
        }
    }
    
    private func callAlert() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось загрузить профиль",
            buttonText: "Попробовать еще раз",
            cancelButtonText: nil
        ) { [weak self] in
            guard let self = self else { return }
            
            guard let token = self.tokenStorage.token else {
                self.showAuthScreen()
                return
            }
            
            self.fetchProfile(token)
        }
        
        alertPresenter.callAlert(with: alert)
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
