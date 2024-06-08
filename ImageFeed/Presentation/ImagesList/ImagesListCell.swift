//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Roman Romanov on 06.06.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - PROPERTIES
    static let reuseIdentifier = "ImagesListCell"
    
    private let contentCellView: UIView = {
        var view = UIView()
        
        return view
    }()
    
    private let postImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    private let likeButton: UIButton = {
        var button = UIButton()
        let image = UIImage(named: "HeartNoActive")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 42), forImageIn: .normal)
        
        return button
    }()
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP LAYOUT
    private func setupLayout() {
        [
            contentCellView,
            postImageView,
            descriptionLabel,
            likeButton,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            contentCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            contentCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            contentCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            postImageView.topAnchor.constraint(equalTo: contentCellView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor),
            postImageView.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor),
            
            likeButton.topAnchor.constraint(equalTo: postImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor, constant: inset / 2),
            descriptionLabel.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: -inset),
            descriptionLabel.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: -inset / 2)
        ])
    }
}

extension ImagesListCell {
    // MARK: - FUNCTIONS
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        descriptionLabel.text = ""
        likeButton.imageView?.image = UIImage(named: "HeartNoActive")
    }
    
    func setupCell() {
        postImageView.image = UIImage(named: "7")
        descriptionLabel.text = "8 июня 2024"
        likeButton.imageView?.image = UIImage(named: "HeartActive")
    }
}
