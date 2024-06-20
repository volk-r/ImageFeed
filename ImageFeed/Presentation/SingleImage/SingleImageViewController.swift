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

extension SingleImageViewController {
    // MARK: SETUP BUTTONS
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
    
    // MARK: OTHER FUNCTIONS
    func updateMinZoomScaleForSize(_ size: CGSize) {
        guard let singleImageView else { return }
        
        let widthScale = size.width / singleImageView.imageView.bounds.width
        let heightScale = size.height / singleImageView.imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        singleImageView.scrollView.minimumZoomScale = minScale
        singleImageView.scrollView.zoomScale = minScale
    }
}

// MARK: UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView?.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    func updateConstraintsForSize(_ size: CGSize) {
        guard let singleImageView else { return }
        
        let yOffset = max(0, (size.height - singleImageView.imageView.frame.height) / 2)
        singleImageView.imageViewTopConstraint.constant = yOffset
        singleImageView.imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - singleImageView.imageView.frame.width) / 2)
        singleImageView.imageViewLeadingConstraint.constant = xOffset
        singleImageView.imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
}
