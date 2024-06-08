//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 01.06.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: PROPERTIES
    
    private let imagesListView = ImagesListView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = imagesListView
        
        imagesListView.tableView.dataSource = self
        imagesListView.tableView.delegate = self
        
        imagesListView.tableView.rowHeight = 200
    }
    
    // MARK: - SETUP
}

// MARK: UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell)
        
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell) {
        cell.setupCell()
    }
}

// MARK: UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
