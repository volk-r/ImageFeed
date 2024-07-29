//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Roman Romanov on 27.07.2024.
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

// MARK: ImagesListServiceError
enum ImagesListServiceError: Error {
    case invalidRequest
}

// MARK: ImagesListServiceProtocol
protocol ImagesListServiceProtocol {
    var lastLoadedPage: Int? { get }
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
}

final class ImagesListService: ImagesListServiceProtocol {
    // MARK: PROPERTIES
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private (set) var lastLoadedPage: Int?
    
    private let urlSession = URLSession.shared
    private var task: Task<(), Never>?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private init() {
        
    }

    // MARK: fetchPhotosNextPage
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(pageNumber: nextPage.description) else {
            print("failed to makePhotosRequest: \(ImagesListServiceError.invalidRequest)", #file, #function, #line)
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                DispatchQueue.main.async {
                    photoResult.forEach {
                        self.photos.append(
                            Photo(
                                id: $0.id,
                                size: CGSize(width: $0.width, height: $0.height),
                                createdAt: $0.createdAt?.convertISOStringToDate,
                                welcomeDescription: $0.welcomeDescription,
                                thumbImageURL: $0.urls.thumb,
                                largeImageURL: $0.urls.full,
                                isLiked: $0.isLiked
                            )
                        )
                    }
                    
                    self.task = nil
                    self.lastLoadedPage = nextPage
                    
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["photos": self.photos]
                        )
                }
            case .failure(let error):
                print("failed to get photos: \(error.localizedDescription)", #file, #function, #line)
            }
        }
    }
    
    // MARK: makePhotosRequest
    private func makePhotosRequest(pageNumber: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.defaultBaseURL.absoluteString) else {
            assertionFailure("failed to create URLComponents")
            return nil
        }
        
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: pageNumber),
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("failed to create URL from URLComponents")
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
