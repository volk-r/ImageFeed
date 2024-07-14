//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 13.06.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: PROPERTIES
    private lazy var profileView = ProfileView()
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        
        guard let profile = profileService.profile else {
            print("no profile data found", #file, #function, #line)
            return
        }
        
        updateProfileDetails(profile: profile)
    }
}

// MARK: - SETUP
extension ProfileViewController {
    // MARK: - updateProfileDetails
    private func updateProfileDetails(profile: Profile) {
        // TODO: image
        let profileData = ProfileModel(
            image: UIImage(),
            name: profile.name,
            nick: profile.loginName,
            status: profile.bio
        )
        
        profileView.setupProfile(with: profileData)
    }
    
    // MARK: - setupMockUser
    private func setupMockUser() {
        let image = UIImage(named: "mockUser")
        
        let profileData = ProfileModel(
            image: image ?? UIImage(),
            name: "Екатерина Новикова",
            nick: "@ekaterina_nov",
            status: "Hello, world!"
        )
        
        profileView.setupProfile(with: profileData)
    }
}
