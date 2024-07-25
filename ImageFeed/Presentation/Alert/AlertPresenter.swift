//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Roman Romanov on 18.07.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
        
    func callAlert(with model: AlertModel) {
        guard let delegate else { return }
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction (title: model.buttonText, style: .default) { _ in
            if let completion = model.completion {
                completion()
            }
        }
        
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "alert"
        delegate.present(alert, animated: true, completion: nil)
    }
}
