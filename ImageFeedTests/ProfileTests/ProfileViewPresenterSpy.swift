//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Roman Romanov on 17.08.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        
    }
    
    func didTapLogoutButton() {
        
    }
}
