//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Roman Romanov on 06.07.2024.
//

import Foundation

// MARK: AuthServiceError
enum AuthServiceError: Error {
    case invalidRequest
    case invalidCode
}

// MARK: OAuth2ServiceProtocol
protocol OAuth2ServiceProtocol {
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: ProfileService
final class OAuth2Service: OAuth2ServiceProtocol {
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
            completion(.failure(AuthServiceError.invalidCode))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let oAuthTokenData):
                completion(.success(oAuthTokenData.accessToken))
                self.task = nil
                self.lastCode = nil
            case .failure(let error):
                print("failed to get accessToken: \(error.localizedDescription)", #file, #function, #line)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: makeOAuthTokenRequest
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURLString) else {
            assertionFailure("failed to create URLComponents")
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
            assertionFailure("failed to create URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
