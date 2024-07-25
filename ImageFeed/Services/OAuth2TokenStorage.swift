//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.07.2024.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
    func clean() -> Void
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let keychain = KeychainWrapper.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            keychain.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else {
                assertionFailure("invalid token")
                return
            }
            
            let isSuccess = keychain.set(newValue, forKey: Keys.token.rawValue)
            
            guard isSuccess else {
                assertionFailure("failed save token")
                return
            }
        }
    }
    
    func clean() {
        keychain.removeObject(forKey: Keys.token.rawValue)
    }
}
