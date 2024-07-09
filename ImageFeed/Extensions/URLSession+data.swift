//
//  URLSession+data.swift.swift
//  ImageFeed
//
//  Created by Roman Romanov on 06.07.2024.
//

import Foundation

enum NetworkError: Error {
    case codeError
    case badRequestError
    case unauthorizedError
    case notAuthorizedError
    case forbiddenError
    case notFoundError
    case internalServerError
}

extension URLSession {
    private enum HTTPStatus: Int {
        case badRequest = 400
        case notAuthorized = 401
        case forbidden = 403
        case notFound = 404
        case internalServerError = 500
    }
    
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        Task {
            do {
                let data = try await self.fetchAsync(request: request)
                fulfillCompletionOnTheMainThread(.success(data))
            } catch {
                print(error, #file, #function, #line)
                fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
    }
    
    func fetchAsync(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode < 200 || response.statusCode >= 300
        {
            let statusCode = response.statusCode
            throw throwNetworkError(for: statusCode)
        }
        
        return data
    }
    
    func throwNetworkError(for statusCode: Int) -> NetworkError {
        if let httpStatus = HTTPStatus(rawValue: statusCode) {
            switch httpStatus {
            case .badRequest:
                return NetworkError.badRequestError
            case .notAuthorized:
                return NetworkError.notAuthorizedError
            case .forbidden:
                return NetworkError.forbiddenError
            case .notFound:
                return NetworkError.notFoundError
            case .internalServerError:
                return NetworkError.internalServerError
            }
        }
        
        return NetworkError.codeError
    }
}
