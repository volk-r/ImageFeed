//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Roman Romanov on 14.07.2024.
//

import Foundation

// MARK: struct Profile

struct Profile {
    let username: String
    let name: String
    let bio: String
}

// MARK: struct ProfileResult
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

// MARK: ProfileServiceError
enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    // MARK: PROPERTIES
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: Task<(), Never>?
    
    private(set) var profile: Profile?
    
    private init() {
        
    }
    
    // MARK: fetchProfile
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeBaseProfileDataRequest(authToken: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        task = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    
                    self.profile = Profile(
                        username: profileResult.username,
                        name: "\(profileResult.firstName) \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines),
                        bio: profileResult.bio ?? ""
                    )
                    
                    guard let profileData = self.profile else {
                        print("failed get profileData", #file, #function, #line)
                        return
                    }
                    
                    completion(.success(profileData))
                    self.task = nil
                } catch {
                    print("failed profile data decoding", #file, #function, #line)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: makeBaseProfileDataRequest
    private func makeBaseProfileDataRequest(authToken: String) -> URLRequest? {
        let profileBaseURL =  URL(string: "me", relativeTo: Constants.defaultBaseURL)
        
        guard let url = profileBaseURL else {
            assertionFailure("Failed to create URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
