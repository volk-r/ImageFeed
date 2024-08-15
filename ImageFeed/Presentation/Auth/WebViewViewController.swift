//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 01.07.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController, WKUIDelegate, WebViewViewControllerProtocol {
    // MARK: - PROPERTIES
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private lazy var webViewView = WebViewView()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    override func loadView() {
        webViewView.webView.uiDelegate = self
        webViewView.webView.navigationDelegate = self
        
        view = webViewView
        view.accessibilityIdentifier = "ShowWebView"
        
        let authHelper = AuthHelper()
        presenter = WebViewPresenter(authHelper: authHelper)
        presenter?.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        configureBackButton()
        
        estimatedProgressObservation = webViewView.webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(webViewView.webView.estimatedProgress)
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
    func load(request: URLRequest) {
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
    func setProgressValue(_ newValue: Float) {
        webViewView.progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        webViewView.progressView.isHidden = isHidden
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
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        
        return nil
    }
}
