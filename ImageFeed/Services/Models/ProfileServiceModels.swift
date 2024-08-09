//
//  ProfileServiceModels.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.08.2024.
//

import Foundation

// MARK: struct Profile
struct Profile {
    let username: String
    let loginName: String
    let name: String
    let bio: String
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = ("\(result.firstName) \(result.lastName ?? "")")
        self.loginName = "@\(result.username)"
        self.bio = ("\(result.bio ?? "")")
    }
}

// MARK: struct ProfileResult
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
