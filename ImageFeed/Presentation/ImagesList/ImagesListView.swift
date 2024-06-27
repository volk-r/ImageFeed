//
//  MovieQuizView.swift
//  ImageFeed
//
//  Created by Roman Romanov on 06.06.2024.
//

import UIKit

final class ImagesListView: UIView {
    // MARK: PROPERTIES
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColorSettings.backgroundColor
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
        
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        
        return tableView
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
    
    private func setupLayout() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
