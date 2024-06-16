//
//  SingleImageView.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.06.2024.
//

import UIKit

final class SingleImageView: UIView {
    // MARK: PROPERTIES
    private var singleImageViewModel: SingleImageModel
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    // MARK: INIT
    init(model: SingleImageModel) {
        singleImageViewModel = model
        super.init(frame: .zero)
        backgroundColor = AppColorSettings.backgroundColor
        
        setupLayout()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP LAYOUT
    private func setupLayout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - SETUP DATA
    private func setupContent() {
        imageView.image = UIImage(named: singleImageViewModel.image)
    }
}
