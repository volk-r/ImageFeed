//
//  OAuth2ServiceModels.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.08.2024.
//

import Foundation

// MARK: OAuthTokenResponseBody
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
