//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 01.07.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    // MARK: PROPERTIES
    private lazy var authView = AuthView()
    private let oauth2Service: OAuth2ServiceProtocol = OAuth2Service.shared
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = authView
        
        setupButton()
    }
}

extension AuthViewController {
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

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        // MARK: - fetchOAuthToken
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let accessToken):
                let tokenStorage = OAuth2TokenStorage()
                tokenStorage.token = accessToken
                
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print("failed to fetch OAuthToken: \(error.localizedDescription)", #file, #function, #line)
                callAlert()
            }
        }
    }
                    
    func callAlert() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ok",
            cancelButtonText: nil
        ) {
        }
        
        alertPresenter.callAlert(with: alert)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
