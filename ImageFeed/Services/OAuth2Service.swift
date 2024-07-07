//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Roman Romanov on 06.07.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    // MARK: - NetworkClient
//    private let networkClient: NetworkRouting = NetworkClient()
    
    private init() {
        
    }
    
    func fetchOAuthToken(code: String, completion: Result<String, Error>) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print(#file, #function, #line)
            preconditionFailure("Unable to construct OAuth token request")
            return
        }
        
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let oAuthTokenData = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = oAuthTokenData.accessToken
                    
                    let tokenStorage = OAuth2TokenStorage()
                    tokenStorage.token = accessToken
                    
                    completion(.success(accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
//        Task {
//            do {
//                let data = try await networkClient.fetchAsync(request: request)
//                // TODO:
//                let oAuthTokenData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
//                completion(.success(oAuthTokenData.accessToken))
//            } catch {
//                print(error, #file, #function, #line)
//            }
//        }
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURLString) else {
            print("failed created URLComponents")
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
            print("failed created url from components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
