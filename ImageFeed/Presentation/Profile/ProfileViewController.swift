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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        
        setupMockUser()
    }
    
    // MARK: - SETUP
    
}

extension ProfileViewController {
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
