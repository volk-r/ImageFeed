//
//  UIImage+Extensions.swift
//  ImageFeed
//
//  Created by Roman Romanov on 13.06.2024.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
