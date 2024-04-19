//
//  UnSplashViewModel.swift
//  UnSplash
//
//  Created by Lalitha Korlapu on 14/04/24.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
    @Published var images: [(UIImage, UnsplashImage)] = []
    @Published var showError: Bool = false
    var errorMessage: String = ""
    
    private let baseURL = "https://api.unsplash.com/photos/random"
    private let accessKey = "Yme6ZcumIXpWryQ0DPc249CE0ua2Mxh66Y-4W2gPAAc"
    @Published var photos: [UnsplashImage] = []
            
    func fetchImageURLs() {
            let accessKey = "Yme6ZcumIXpWryQ0DPc249CE0ua2Mxh66Y-4W2gPAAc"
            let urlString = "https://api.unsplash.com/photos/random?count=10000&client_id=\(accessKey)"
            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching image URLs: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                    let results = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                    for imageUrl in results {
                        if let imageData = try? Data(contentsOf: imageUrl.urls.regular) {
                            if let image = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    self.images.append((image, UnsplashImage(url: imageUrl.urls.regular)))
                                   // self.photos = decodedResponse.map { Photo(url: $0.urls.regular) }
                                }
                            }
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
    
    func loadImage(for photo: UnsplashImage, img: UIImage) {
        guard img.size == .zero else { return }

        URLSession.shared.dataTask(with: photo.url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image, for: photo.url)
                    DispatchQueue.main.async {
                        if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                            self.photos[index].image = image
                        }
                    }
                }
            }.resume()
        }
}
