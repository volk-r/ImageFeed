//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Roman Romanov on 06.07.2024.
//

import Foundation

// MARK: OAuthTokenResponseBody

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

// MARK: AuthServiceError

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    // MARK: PROPERTIES
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private var task: Task<(), Never>?
    private var lastCode: String?
    
    private init() {
        
    }
    
    // MARK: fetchOAuthToken
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let oAuthTokenData = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(oAuthTokenData.accessToken))
                    self.task = nil
                    self.lastCode = nil
                } catch {
                    print("failed data decoding", #file, #function, #line)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: makeOAuthTokenRequest
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURLString) else {
            assertionFailure("Failed to create URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
