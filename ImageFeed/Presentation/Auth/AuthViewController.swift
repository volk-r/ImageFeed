//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 01.07.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    // MARK: PROPERTIES
    let authView = AuthView()
    
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
        navigationController?.pushViewController(webViewVC, animated: true)
    }
}
