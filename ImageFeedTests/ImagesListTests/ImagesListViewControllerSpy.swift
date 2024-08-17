//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Roman Romanov on 17.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListViewPresenterProtocol)?
    
    var alertPresenter: any ImageFeed.AlertPresenterProtocol = AlertPresenterSpy()
    
    var fetchPhotosNextPageCalled: Bool = false
    var performBatchUpdatesCalled: Bool = false
    var performPhotoUpdatesCalled: Bool = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func updateTableViewAnimated() {
        
    }
    
    func performPhotoUpdates() {
        performPhotoUpdatesCalled = true
    }
    
    func performBatchUpdates(indexPaths: [IndexPath]) {
        performBatchUpdatesCalled = true
    }
    
    func openImageByIndexPath(_ indexPath: IndexPath) {
        
    }
}
