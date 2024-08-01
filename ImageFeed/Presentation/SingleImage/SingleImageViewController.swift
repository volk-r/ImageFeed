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
    lazy var singleImageView = SingleImageView()
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = singleImageView

        singleImageView.scrollView.delegate = self

        setupButton()
    }
}

// MARK: SETUP BUTTONS
extension SingleImageViewController {
    private func setupButton() {
        singleImageView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        singleImageView.shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShareButton() {
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
