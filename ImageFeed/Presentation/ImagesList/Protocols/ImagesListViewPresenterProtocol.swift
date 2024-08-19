//
//  ImagesListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Roman Romanov on 17.08.2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func updatePhotoList(prevPhotoCount: Int, newPhotoCount: Int)
    func callAlert(indexPath: IndexPath)
    func callLikeAlert(isLiked: Bool)
}
