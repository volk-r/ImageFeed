//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.06.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    // MARK: - PROPERTIES
    private lazy var singleImageView = SingleImageView()
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    private var singleImageModel: SingleImageModel?
    
    // MARK: - Lifecycle
    init(model: SingleImageModel) {
        super.init(nibName: nil, bundle: nil)
        view = singleImageView
        singleImageModel = model
        
        singleImageView.scrollView.delegate = self
        
        setupButton()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SingleImageViewController {
    // MARK: - SETUP DATA
    private func setupContent() {
        guard let singleImageModel, let imageUrl = URL(string: singleImageModel.image) else {
            print("failed create image URL from: \(singleImageModel?.image ?? "")", #file, #function, #line)
            return
        }

        UIBlockingProgressHUD.show()
        
        singleImageView.imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                singleImageView.imageView.image = imageResult.image
            case .failure:
                print("failed to load image URL from: \(imageUrl)", #file, #function, #line)
                callAlert()
            }
        }
    }
    
    private func callAlert() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось загрузить картинку",
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            guard let self = self else { return }
            
            self.setupContent()
        }
        
        alertPresenter.callAlert(with: alert)
    }
    
    // MARK: SETUP BUTTONS
    private func setupButton() {
        singleImageView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        singleImageView.shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapShareButton() {
        let shareContent: [Any] = singleImageView.getContentForSharing()
        
        let activityController = UIActivityViewController(
            activityItems: shareContent,
            applicationActivities: nil
        )
        
        self.present(activityController, animated: true, completion: nil)
    }
}

// MARK: UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView.getImageForSingleImageView()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        singleImageView.updateConstraintsForView(view)
    }
}
