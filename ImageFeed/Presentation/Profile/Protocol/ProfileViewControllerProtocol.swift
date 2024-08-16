//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.08.2024.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func setAvatarByURL(_ url: URL)
    func setProfileData(with profileData: ProfileModel)
    func setMockUser(with data: ProfileModel, image: UIImage?)
}
