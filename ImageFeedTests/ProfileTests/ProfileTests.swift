//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Roman Romanov on 17.08.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        presenter.viewDidLoad()
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        presenter.updateAvatar()
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
    
    func testCallsUpdateProfileDetails() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        let profileData = Profile(
            result: ProfileResult(
                username: "Екатерина Новикова",
                firstName: "Екатерина",
                lastName: nil,
                bio: "Hello, world!"
            )
        )
        presenter.updateProfileDetails(profile: profileData)
        // then
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(viewController.setProfileDataCalled)
    }
}
