//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.07.2024.
//

import Foundation

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
    func clean() -> Void
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else {
                assertionFailure("invalid token")
                return
            }
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    func clean() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { userDefaults.removeObject(forKey: $0) }
    }
}
