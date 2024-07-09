//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Roman Romanov on 03.07.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
