//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 13.06.2024.
//

import UIKit

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    // MARK: PROPERTIES
    private lazy var profileView = ProfileView()
    
    lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = profileView
        
        presenter = ProfileViewPresenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        setupButton()
    }
}

extension ProfileViewController {
    // MARK: setAvatarByURL
    func setAvatarByURL(_ url: URL) {
        profileView.setupAvatar(from: url)
    }
    // MARK: setProfileData
    func setProfileData(with profileData: ProfileModel) {
        profileView.setupProfile(with: profileData)
    }
    // MARK: setMockUser
    func setMockUser(with data: ProfileModel) {
        profileView.setupProfile(with: data)
        profileView.setupMockAvatar()
    }
}

private extension ProfileViewController {
    // MARK: SETUP BUTTONS
    private func setupButton() {
        profileView.exitButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    // MARK: LOGOUT
    @objc private func didTapLogoutButton() {
        presenter?.didTapLogoutButton()
    }
}
