//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Romanov on 17.08.2024.
//

import Foundation
import UIKit

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    // MARK: - PROPERTIES
    weak var view: ImagesListViewControllerProtocol?
    
    init(view: ImagesListViewControllerProtocol?) {
        self.view = view
    }
    
    // MARK: - viewDidLoad
    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        view?.fetchPhotosNextPage()
    }
    
    // MARK: - updateTableViewAnimated
    @objc func updateTableViewAnimated() {
        view?.updateTableViewAnimated()
    }
    
    // MARK: - updatePhotoList
    func updatePhotoList(prevPhotoCount: Int, newPhotoCount: Int) {
        view?.performPhotoUpdates()
        
        if prevPhotoCount != newPhotoCount {
            let indexPaths = (prevPhotoCount ..< newPhotoCount).map { i in
                IndexPath(row: i, section: 0)
            }
            
            view?.performBatchUpdates(indexPaths: indexPaths)
        }
    }
    
    // MARK: - callLikeAlert
    func callAlert(indexPath: IndexPath) {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось загрузить картинку",
            buttonText: "Попробовать еще раз?",
            cancelButtonText: "Не надо"
        ) { [weak self] in
            guard let self = self else { return }
            
            self.view?.openImageByIndexPath(indexPath)
        }
        
        view?.alertPresenter.callAlert(with: alert)
    }
    
    // MARK: - callLikeAlert
    func callLikeAlert(isLiked: Bool) {
        let message = isLiked ? "снять" : "поставить"
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось \(message) лайк",
            buttonText: "Попробовать позже",
            cancelButtonText: nil
        ) {
        }
        
        view?.alertPresenter.callAlert(with: alert)
    }
}
