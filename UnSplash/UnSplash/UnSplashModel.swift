//
//  UnSplashModel.swift
//  UnSplash
//
//  Created by Lalitha Korlapu on 14/04/24.
//

import Foundation
import UIKit

struct UnsplashImage: Identifiable {
    let id = UUID()
    let url: URL
    var image: UIImage? = nil
}

struct UnsplashPhoto: Decodable {
    let urls: UnsplashPhotoURLs
}

struct UnsplashPhotoURLs: Decodable {
    let regular: URL
}
