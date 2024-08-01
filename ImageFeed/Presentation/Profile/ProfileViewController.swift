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
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        setupButton()
        
        guard let profile = profileService.profile else {
            print("no profile data found", #file, #function, #line)
            return
        }
        
        updateProfileDetails(profile: profile)
    }
    
    deinit {
        guard let profileImageServiceObserver else {
            return
        }
        
        NotificationCenter.default.removeObserver(profileImageServiceObserver)
    }
}

private extension ProfileViewController {
    // MARK: SETUP BUTTONS
    private func setupButton() {
        profileView.exitButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    @objc private func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
    }
    
    // MARK: - updateProfileDetails
    private func updateProfileDetails(profile: Profile) {
        let profileData = ProfileModel(
            name: profile.name,
            nick: profile.loginName,
            status: profile.bio
        )
        
        profileView.setupProfile(with: profileData)
    }
    
    // MARK: - setupMockUser
    private func setupMockUser() {
        let profileData = ProfileModel(
            name: "Екатерина Новикова",
            nick: "@ekaterina_nov",
            status: "Hello, world!"
        )
        profileView.setupProfile(with: profileData)
        
        let image = UIImage(named: "mockUser")
        profileView.setupMockAvatar(with: image)
    }
    
    // MARK: - updateAvatar
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileView.setupAvatar(from: url)
    }
}
