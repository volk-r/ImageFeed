//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Roman Romanov on 14.07.2024.
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

// MARK: ProfileImageServiceProtocol
protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: ProfileImageService
final class ProfileImageService: ProfileImageServiceProtocol {
    // MARK: PROPERTIES
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    private var task: Task<(), Never>?
    
    private init() {
        
    }
    
    // MARK: fetchProfileImageURL
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeBaseProfilePublicDataRequest(for: username) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        task = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let userResult = try decoder.decode(UserResult.self, from: data)
                    
                    self.avatarURL = userResult.profileImage.small
                    
                    guard let avatarURL = self.avatarURL else {
                        print("failed get avatarURL", #file, #function, #line)
                        return
                    }
                    
                    completion(.success(avatarURL))
                    self.task = nil
                } catch {
                    print("failed profile image data decoding", #file, #function, #line)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: makeBaseProfilePublicDataRequest
    private func makeBaseProfilePublicDataRequest(for username: String) -> URLRequest? {
        let profileBaseURL =  URL(string: "users/\(username)", relativeTo: Constants.defaultBaseURL)
        
        guard let url = profileBaseURL else {
            assertionFailure("failed to create profileBaseURL")
            return nil
        }
        
        guard let authToken = OAuth2TokenStorage().token else {
            assertionFailure("failed to get authToken")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
