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
    
    var imageViewBottomConstraint: NSLayoutConstraint!
    var imageViewLeadingConstraint: NSLayoutConstraint!
    var imageViewTopConstraint: NSLayoutConstraint!
    var imageViewTrailingConstraint: NSLayoutConstraint!
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.minimumZoomScale = 0.2
        scrollView.maximumZoomScale = 1.25
        
        return scrollView
    }()
    
    let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let backButton: UIButton = {
        var button = UIButton()
        let image = UIImage(named: "Backward")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 44), forImageIn: .normal)
        
        return button
    }()
    
    let shareButton: UIButton = {
        var button = UIButton()
        let image = UIImage(named: "Sharing")
        button.setImage(image, for: .normal)
        
        return button
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
        [
            imageView,
            backButton,
            shareButton,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([
            imageViewTopConstraint,
            imageViewLeadingConstraint,
            imageViewTrailingConstraint,
            imageViewBottomConstraint,
            
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 9),
            
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: - SETUP DATA
    private func setupContent() {
        imageView.image = UIImage(named: singleImageViewModel.image)
    }
}
