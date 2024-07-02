//
//  WebViewView.swift
//  ImageFeed
//
//  Created by Roman Romanov on 02.07.2024.
//

import UIKit
import WebKit

final class WebViewView: UIView {
    // MARK: - PROPERTIES
    var wkWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.backgroundColor = .white
        
        return webView
    }()
    
    // MARK: INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColorSettings.backgroundColor
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP LAYOUT
    private func setupLayout() {
        [
            wkWebView,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: topAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
