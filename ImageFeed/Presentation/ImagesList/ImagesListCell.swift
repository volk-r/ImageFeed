//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Roman Romanov on 06.06.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    // MARK: - PROPERTIES
    static let reuseIdentifier = "ImagesListCell"
    
    weak var imagesListCellDelegate: ImagesListCellDelegate?
       
    private var indexPathCell = IndexPath()
    
    private lazy var postImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        var button = UIButton()
        let image = UIImage(systemName: "suit.heart.fill")
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .white
        button.alpha = 0.5
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24), forImageIn: .normal)
        
        return button
    }()
    
    private lazy var placeholderImage: UIImage? = {
        UIImage(named: "images_list_placeholder")
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
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset / 2),
            
            likeButton.topAnchor.constraint(equalTo: postImageView.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: -10.5),
            
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
        
        postImageView.kf.cancelDownloadTask()
        
        postImageView.image = nil
        descriptionLabel.text = ""
        likeButton.imageView?.tintColor = .white
        likeButton.alpha = 0.5
    }
    
    func setupCell(with cellData: ImagesListCellModel) {
        guard let imageUrl = URL(string: cellData.imageURL) else {
            print("failed create image URL from: \(cellData.imageURL)", #file, #function, #line)
            return
        }
        
        postImageView.kf.indicatorType = .activity
        postImageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                postImageView.image = value.image
            case .failure(let error):
                print("failed upload photo: \(error.errorCode) \(error.localizedDescription)", #file, #function, #line)
            }
        }
        
        descriptionLabel.text = cellData.date
        
        setIsLiked(cellData.isLiked)
    }
    
    func setIndexPath(_ indexPath: IndexPath) {
        indexPathCell = indexPath
    }
    
    private func addGesture() {
        let postImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageViewOpened))
        postImageView.addGestureRecognizer(postImageViewTapGesture)
        
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    @objc private func postImageViewOpened() {
        imagesListCellDelegate?.openImage(indexPath: indexPathCell)
    }
    
    @objc private func likeButtonClicked() {
        imagesListCellDelegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.imageView?.tintColor = isLiked
            ? UIColor(hexString: "F56B6C")
            : .white
        likeButton.alpha = isLiked ? 1 : 0.5
    }
}
