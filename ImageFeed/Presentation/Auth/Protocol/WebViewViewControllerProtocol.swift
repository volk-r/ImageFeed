//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Roman Romanov on 14.08.2024.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
