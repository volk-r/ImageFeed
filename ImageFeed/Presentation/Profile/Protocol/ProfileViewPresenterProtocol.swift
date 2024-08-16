//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.08.2024.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetails(profile: Profile)
    func didTapLogoutButton(alertPresenter: AlertPresenterProtocol)
}
