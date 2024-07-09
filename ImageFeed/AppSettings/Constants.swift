//
//  Constants.swift
//  ImageFeed
//
//  Created by Roman Romanov on 29.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "T70Hfvt7ytwPCArDEU_gT6oQktnZPGjaaKC2I7Cz7cQ"
    static let secretKey = "c0X_myfTGwj8so4FaMKuXQYZm7fgmmQHsV2mNhnMwXg"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}
