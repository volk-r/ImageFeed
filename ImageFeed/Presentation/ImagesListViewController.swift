//
//  ViewController.swift
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
    }
    
    // MARK: - SETUP
}

// MARK: UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
}
