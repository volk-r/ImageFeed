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
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
        
        updateAvatar()
        
        setupButton()
        
        guard let profile = profileService.profile else {
            print("no profile data found", #file, #function, #line)
            return
        }
        
        updateProfileDetails(profile: profile)
    }
}

private extension ProfileViewController {
    // MARK: SETUP BUTTONS
    private func setupButton() {
        profileView.exitButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    // MARK: LOGOUT
    @objc private func didTapLogoutButton() {
        let alert = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            buttonText: "Да",
            cancelButtonText: "Нет"
        ) {
            ProfileLogoutService.shared.logout()
        }
        
        alertPresenter.callAlert(with: alert)
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
    @objc private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileView.setupAvatar(from: url)
    }
}
