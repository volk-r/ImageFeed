//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.08.2024.
//

import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - PROPERTIES
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    
    init(view: ProfileViewControllerProtocol?) {
        self.view = view
    }
    
    // MARK: - viewDidLoad
    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
        
        updateAvatar()
        
        guard let profile = profileService.profile else {
            print("no profile data found", #file, #function, #line)
            return
        }
        
        updateProfileDetails(profile: profile)
    }
    
    // MARK: - updateAvatar
    @objc func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setAvatarByURL(url)
    }
    
    // MARK: - updateProfileDetails
    func updateProfileDetails(profile: Profile) {
        let profileData = ProfileModel(
            name: profile.name,
            nick: profile.loginName,
            status: profile.bio
        )
        
        view?.setProfileData(with: profileData)
    }
    
    // MARK: - didTapLogoutButton
    func didTapLogoutButton() {
        let alert = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            buttonText: "Да",
            cancelButtonText: "Нет"
        ) {
            ProfileLogoutService.shared.logout()
        }
        
        view?.alertPresenter.callAlert(with: alert)
    }
    
    // MARK: - setupMockUser
    private func setupMockUser() {
        let profileData = ProfileModel(
            name: "Екатерина Новикова",
            nick: "@ekaterina_nov",
            status: "Hello, world!"
        )
        
        view?.setMockUser(with: profileData)
    }
}
