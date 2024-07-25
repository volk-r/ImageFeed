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

// MARK: ProfileServiceError
enum ProfileServiceError: Error {
    case invalidRequest
}

// MARK: ProfileServiceProtocol
protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

// MARK: ProfileService
final class ProfileService: ProfileServiceProtocol {
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
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profileResult):
                self.profile = Profile(result: profileResult)
                
                guard let profileData = self.profile else {
                    print("failed to get profileData", #file, #function, #line)
                    return
                }
                
                completion(.success(profileData))
                self.task = nil
            case .failure(let error):
                print("failed to get profileData: \(error.localizedDescription)", #file, #function, #line)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: makeBaseProfileDataRequest
    private func makeBaseProfileDataRequest(authToken: String) -> URLRequest? {
        let profileBaseURL =  URL(string: "me", relativeTo: Constants.defaultBaseURL)
        
        guard let url = profileBaseURL else {
            assertionFailure("failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
