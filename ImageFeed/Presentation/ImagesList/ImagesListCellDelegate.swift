//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Roman Romanov on 16.06.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func openImage(indexPath: IndexPath)
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
