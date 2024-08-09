//
//  ImagesListServiceModels.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.08.2024.
//

import Foundation

// MARK: struct Photo
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

// MARK: struct LikeResult
struct LikeResult: Decodable {
    let photo: PhotoResult
}

// MARK: struct PhotoResult
struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let welcomeDescription: String?
    let urls: UrlsResult
    let isLiked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case urls
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Decodable {
    let thumb: String
    let full: String
}
