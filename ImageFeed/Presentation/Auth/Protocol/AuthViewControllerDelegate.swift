//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.07.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
