//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Roman Romanov on 17.08.2024.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    var alertPresenter: AlertPresenterProtocol { get }
    func fetchPhotosNextPage()
    func updateTableViewAnimated()
    func performPhotoUpdates()
    func performBatchUpdates(indexPaths: [IndexPath])
    func openImageByIndexPath(_ indexPath: IndexPath)
}
