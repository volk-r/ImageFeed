//
//  ProfileImageServiceModels.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.08.2024.
//

import Foundation

// MARK: struct UserResult
struct UserResult: Codable {
    let profileImage: ImageResult
        
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageResult: Codable {
    let small: String
    let medium: String
    let large: String
}
