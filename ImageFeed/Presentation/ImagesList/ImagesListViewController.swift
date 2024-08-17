//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 01.06.2024.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    // MARK: PROPERTIES
    private lazy var imagesListView = ImagesListView()
    
    var presenter: ImagesListViewPresenterProtocol?
    
    lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    private let imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    
    private var photos: [Photo] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = imagesListView
        
        imagesListView.tableView.dataSource = self
        imagesListView.tableView.delegate = self
        
        imagesListView.tableView.rowHeight = 200
        
        presenter = ImagesListViewPresenter(view: self)
        presenter?.viewDidLoad()
    }
}

extension ImagesListViewController {
    // MARK: updateTableViewAnimated
    func updateTableViewAnimated() {
        let prevPhotoCount = photos.count
        let newPhotoCount = imagesListService.photos.count
        
        presenter?.updatePhotoList(prevPhotoCount: prevPhotoCount, newPhotoCount: newPhotoCount)
    }
    
    // MARK: performPhotoUpdates
    func performPhotoUpdates() {
        photos = imagesListService.photos
    }
    
    // MARK: performBatchUpdates
    func performBatchUpdates(indexPaths: [IndexPath]) {
        imagesListView.tableView.performBatchUpdates {
            imagesListView.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    // MARK: performBatchUpdates
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: openImageByIndexPath
    func openImageByIndexPath(_ indexPath: IndexPath) {
        openImage(indexPath: indexPath)
    }
}

// MARK: UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let currentRow = photos[indexPath.row]
        
        let cellData = ImagesListCellModel(
            imageURL: currentRow.thumbImageURL,
            date: DateFormatterService.shared.stringFromDate(currentRow.createdAt) ?? "",
            isLiked: currentRow.isLiked
        )
        
        cell.setupCell(with: cellData)
        cell.imagesListCellDelegate = self
        cell.setIndexPath(indexPath)
        
        imagesListView.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageViewWidth = tableView.bounds.width
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            fetchPhotosNextPage()
        }
    }
}

// MARK: ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func openImage(indexPath: IndexPath) {
        let imageName = imagesListService.photos[indexPath.row].largeImageURL
        let singleImageVC = SingleImageViewController()
        singleImageVC.modalPresentationStyle = .fullScreen
        
        guard let imageUrl = URL(string: imageName) else {
            print("failed create image URL from: \(imageName)", #file, #function, #line)
            return
        }

        UIBlockingProgressHUD.show()
        
        singleImageVC.singleImageView.imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                singleImageVC.singleImageView.imageView.image = imageResult.image
                present(singleImageVC, animated: true)
            case .failure:
                print("failed to load image URL from: \(imageUrl)", #file, #function, #line)
                presenter?.callAlert(indexPath: indexPath)
            }
        }
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = imagesListView.tableView.indexPath(for: cell) else {
            return
        }
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
            case .failure(let error):
                let message = photo.isLiked ? "dislike" : "like"
                print("failed to \(message) photo: \(error.localizedDescription)", #file, #function, #line)
                presenter?.callLikeAlert(isLiked: photo.isLiked)
            }
        }
    }
}
