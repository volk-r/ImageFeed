//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 01.07.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController, WKUIDelegate {
    // MARK: - PROPERTIES
    weak var delegate: WebViewViewControllerDelegate?
    
    private lazy var webViewView = WebViewView()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    override func loadView() {
        webViewView.webView.uiDelegate = self
        webViewView.webView.navigationDelegate = self
        view = webViewView
        view.accessibilityIdentifier = "ShowWebView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        
        configureBackButton()
        
        estimatedProgressObservation = webViewView.webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - FUNCTIONS
extension WebViewViewController {
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            print("failed created URLComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("failed created url from components")
            return
        }
        
        let request = URLRequest(url: url)
        webViewView.webView.load(request)
    }
    
    // MARK: - setup BACK button
    private func configureBackButton() {
        let image = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: #selector(backItemAction)
        )
        navigationController?.navigationBar.tintColor = AppColorSettings.backgroundColor
    }
    
    @objc private func backItemAction() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - UPDATE progressView
    private func updateProgress() {
        webViewView.progressView.progress = Float(webViewView.webView.estimatedProgress)
        webViewView.progressView.isHidden = fabs(webViewView.webView.estimatedProgress - 1.0) <= 0.0001
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
