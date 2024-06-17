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
        imageView.contentMode = .scaleAspectFill
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
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 9),
        ])
    }
    
    // MARK: - SETUP DATA
    private func setupContent() {
        imageView.image = UIImage(named: singleImageViewModel.image)
    }
}
