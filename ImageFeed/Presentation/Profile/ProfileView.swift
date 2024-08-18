//
//  ProfileView.swift
//  ImageFeed
//
//  Created by Roman Romanov on 13.06.2024.
//

import UIKit
import Kingfisher

final class ProfileView: UIView {
    // MARK: PROPERTIES
    private let inset: CGFloat = 8
    
    private let defaultAvatar: UIImage? = UIImage(
        systemName: "person.crop.circle.fill"
    )?.withTintColor(
        AppColorSettings.ypWhite
    ).resized(
        to: CGSize(width: 70, height: 70)
    )
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = inset
        
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .regular)
        label.textColor = AppColorSettings.ypWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var nickLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColorSettings.ypGrey
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColorSettings.ypWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var exitButton: UIButton = {
        var button = UIButton()
        let image = UIImage(systemName: "ipad.and.arrow.forward")
        button.imageView?.tintColor = UIColor(hexString: "E47370")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24), forImageIn: .normal)
        
        button.accessibilityIdentifier = "ExitButton"
        
        return button
    }()
    
    // MARK: INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColorSettings.backgroundColor
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP LAYOUT
    private func setupLayout() {
        // profile
        [
            nameLabel,
            nickLabel,
            statusLabel,
        ].forEach {
            profileStackView.addArrangedSubview($0)
        }
        
        [
            profileImageView,
            profileStackView,
            exitButton,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: inset * 4),
            profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: inset * 2),
            
            profileStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: inset),
            profileStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: inset * 2),
            
            exitButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 55),
            exitButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -inset * 3),
        ])
    }
}

extension ProfileView {
    // MARK: - FUNCTIONS
    func setUnknownProfile() {
        profileImageView.image = defaultAvatar
        nameLabel.text = ""
        nickLabel.text = ""
        statusLabel.text = ""
    }
    
    func setupProfile(with profileData: ProfileModel) {
        profileImageView.image = defaultAvatar
        nameLabel.text = profileData.name
        nickLabel.text = profileData.nick
        statusLabel.text = profileData.status
    }
    
    func setupMockAvatar(with image: UIImage?) {
        profileImageView.image = image?.resized(to: CGSize(width: 70, height: 70))
    }
    
    func setupAvatar(from url: URL) {
        ImageCache.default.clearCache()
        
        profileImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 15)
        
        profileImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .fromMemoryCacheOrRefresh
            ]
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                profileImageView.image = value.image.resized(to: CGSize(width: 70, height: 70))
                profileImageView.layer.cornerRadius = 30
            case .failure(let error):
                print("failed update avatar: \(error.errorCode) \(error.localizedDescription)", #file, #function, #line)
            }
        }
    }
}
