//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.08.2024.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    var alertPresenter: AlertPresenterProtocol { get }
    func setAvatarByURL(_ url: URL)
    func setProfileData(with profileData: ProfileModel)
    func setMockUser(with data: ProfileModel)
}
