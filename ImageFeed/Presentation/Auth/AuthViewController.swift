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
//        fetchOAuthToken(code: code, completion: Result<String, Error>)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
