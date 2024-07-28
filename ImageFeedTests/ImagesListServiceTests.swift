//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Roman Romanov on 28.07.2024.
//

import XCTest
@testable import ImageFeed

final class ImageFeedTests: XCTestCase {
    func testFetchPhotos() {
        let service: ImagesListServiceProtocol = ImagesListService.shared
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { _ in
                    expectation.fulfill()
                }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
