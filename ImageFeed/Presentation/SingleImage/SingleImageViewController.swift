//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.06.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Lifecycle
    
    init(model: SingleImageModel) {
        super.init(nibName: nil, bundle: nil)
        view = SingleImageView(model: model)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
