//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.06.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - PROPERTIES
    private var singleImageView: SingleImageView?
    
    // MARK: - Lifecycle
    init(model: SingleImageModel) {
        super.init(nibName: nil, bundle: nil)
        singleImageView = SingleImageView(model: model)
        view = singleImageView
        singleImageView?.scrollView.delegate = self
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: FUNCTIONS

extension SingleImageViewController {
    private func setupButton() {
        singleImageView?.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        singleImageView?.shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapShareButton() {
        guard 
            let singleImageView,
            let image = singleImageView.imageView.image
        else {
            return
        }
        
        let shareText = "This is my favorite image"
        let shareContent: [Any] = [shareText, image]
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
        return singleImageView?.imageView
    }
}
