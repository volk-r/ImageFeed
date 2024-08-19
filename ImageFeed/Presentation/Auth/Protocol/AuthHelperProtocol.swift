//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Roman Romanov on 15.08.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
