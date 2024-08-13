//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Roman Romanov on 31.07.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanProfileData()
        cleanProfileImageData()
        cleanImageListData()
        switchToSplashViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanProfileData() {
        ProfileService.shared.clean()
    }
    
    private func cleanProfileImageData() {
        ProfileImageService.shared.clean()
        OAuth2TokenStorage().clean()
    }
    
    private func cleanImageListData() {
        ImagesListService.shared.clean()
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}

