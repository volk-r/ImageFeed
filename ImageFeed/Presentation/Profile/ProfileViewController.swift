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
    
    private let customGradient = CustomGradient()
    private var animationLayers = Set<CALayer>()
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        
        addGradients()
        
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
        removeGradients()
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
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileView.setupAvatar(from: url)
    }
    
    
    func addGradients() {
        let avatarGradient = customGradient.getGradient(
            size: CGSize(
                width: 70,
                height: 70
            ),
            cornerRadius: profileView.profileImageView.layer.cornerRadius)
        profileView.profileImageView.layer.addSublayer(avatarGradient)
        animationLayers.insert(avatarGradient)
        
        let nameLabelGradient = customGradient.getGradient(size: CGSize(
            width: 300,
            height: 30
        ))
        profileView.nameLabel.layer.addSublayer(nameLabelGradient)
        animationLayers.insert(nameLabelGradient)
        
        let statusLabelGradient = customGradient.getGradient(size: CGSize(
            width: 250,
            height: 18
        ))
        profileView.statusLabel.layer.addSublayer(statusLabelGradient)
        animationLayers.insert(statusLabelGradient)
        
        let nickLabelGradient = customGradient.getGradient(size: CGSize(
            width: 280,
            height: 18
        ))
        profileView.nickLabel.layer.addSublayer(nickLabelGradient)
        animationLayers.insert(nickLabelGradient)
    }
    
    func removeGradients() {
        for gradient in self.animationLayers {
            gradient.removeFromSuperlayer()
        }
    }
}
