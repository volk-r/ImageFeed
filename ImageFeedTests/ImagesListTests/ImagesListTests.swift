//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Roman Romanov on 17.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        viewController.viewDidLoad()
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertNotNil(presenter.view)
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsFetchPhotosNextPage() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        presenter.viewDidLoad()
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertNotNil(presenter.view)
        XCTAssertTrue(viewController.fetchPhotosNextPageCalled)
    }
    
    func testViewControllerCallsUpdatePhotoList() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        viewController.updateTableViewAnimated()
        // then
        XCTAssertTrue(presenter.updatePhotoListCalled)
    }
    
    func testViewControllerCallsPerformBatchUpdates() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        presenter.updatePhotoList(prevPhotoCount: 0, newPhotoCount: 1)
        // then
        XCTAssertTrue(viewController.performPhotoUpdatesCalled)
        XCTAssertTrue(viewController.performBatchUpdatesCalled)
    }
    
    func testViewControllerCallsPerformBatchUpdatesSame() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        presenter.updatePhotoList(prevPhotoCount: 1, newPhotoCount: 1)
        // then
        XCTAssertTrue(viewController.performPhotoUpdatesCalled)
        XCTAssertFalse(viewController.performBatchUpdatesCalled)
    }
}
