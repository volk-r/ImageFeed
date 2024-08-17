//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Roman Romanov on 17.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var updatePhotoListCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updatePhotoList(prevPhotoCount: Int, newPhotoCount: Int) {
        updatePhotoListCalled = true
    }
    
    func callAlert(indexPath: IndexPath) {
        
    }
    
    func callLikeAlert(isLiked: Bool) {
        
    }
}
