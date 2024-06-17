//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.06.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Lifecycle
    
    private var imagesListView: SingleImageView?
    
    init(model: SingleImageModel) {
        super.init(nibName: nil, bundle: nil)
        imagesListView = SingleImageView(model: model)
        view = imagesListView
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        imagesListView?.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
}
