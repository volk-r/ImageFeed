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
    
    weak var imagesListCellDelegate: ImagesListCellDelegate?
       
    private var indexPathCell = IndexPath()
    
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
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 44), forImageIn: .normal)
        
        return button
    }()
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupLayout()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP LAYOUT
    private func setupLayout() {
        [
            postImageView,
            descriptionLabel,
            likeButton,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset / 4),
            
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
    
    func setupCell(with cellData: ImagesListCellModel) {
        postImageView.image = cellData.image
        descriptionLabel.text = cellData.date
        
        let likeImageName = cellData.isLiked ? "HeartActive" : "HeartNoActive"
        likeButton.imageView?.image = UIImage(named: likeImageName)
    }
    
    func setIndexPath(_ indexPath: IndexPath) {
        indexPathCell = indexPath
    }
    
    private func addGesture() {
        let postImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageViewOpened))
        postImageView.addGestureRecognizer(postImageViewTapGesture)
    }
    
    @objc private func postImageViewOpened() {
        imagesListCellDelegate?.openImage(indexPath: indexPathCell)
    }
}
