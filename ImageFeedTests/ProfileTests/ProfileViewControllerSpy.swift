//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Roman Romanov on 17.08.2024.
//

import Foundation
import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    lazy var alertPresenter: ImageFeed.AlertPresenterProtocol = AlertPresenterSpy()
    
    var setProfileDataCalled: Bool = false
    
    func setAvatarByURL(_ url: URL) {
        
    }
    
    func setProfileData(with profileData: ImageFeed.ProfileModel) {
        setProfileDataCalled = true
    }
    
    func setMockUser(with data: ImageFeed.ProfileModel) {
        
    }
}
