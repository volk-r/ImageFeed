//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 01.07.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    // MARK: PROPERTIES
    private let authView = AuthView()
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = authView
        
        setupButton()
    }
    
    // MARK: - SETUP
    
    private func setupButton() {
        authView.loginButton.addTarget(self, action: #selector(openLoginPage), for: .touchUpInside)
    }
    
    @objc private func openLoginPage() {
        let webViewVC = WebViewViewController()
        webViewVC.delegate = self
        navigationController?.pushViewController(webViewVC, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        // MARK: - TODO fetchOAuthToken
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let accessToken):
                let tokenStorage = OAuth2TokenStorage()
                tokenStorage.token = accessToken
                
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print(error, #file, #function, #line)
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
