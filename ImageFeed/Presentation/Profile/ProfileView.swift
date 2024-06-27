//
//  ProfileView.swift
//  ImageFeed
//
//  Created by Roman Romanov on 13.06.2024.
//

import UIKit

final class ProfileView: UIView {
    // MARK: PROPERTIES
    private let inset: CGFloat = 8
    
    lazy private var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = inset
        
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .regular)
        label.textColor = AppColorSettings.ypWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    private let nickLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColorSettings.ypGrey
        label.numberOfLines = 0
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColorSettings.ypWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    private let exitButton: UIButton = {
        var button = UIButton()
        let image = UIImage(systemName: "ipad.and.arrow.forward")
        button.imageView?.tintColor = UIColor(hexString: "E47370")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24), forImageIn: .normal)
        
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
        let image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(AppColorSettings.ypWhite)
        profileImageView.image = image?.resized(to: CGSize(width: 70, height: 70))
        nameLabel.text = ""
        nickLabel.text = ""
        statusLabel.text = ""
    }
    
    func setupProfile(with profileData: ProfileModel) {
        profileImageView.image = profileData.image.resized(to: CGSize(width: 70, height: 70))
        nameLabel.text = profileData.name
        nickLabel.text = profileData.nick
        statusLabel.text = profileData.status
    }
}
