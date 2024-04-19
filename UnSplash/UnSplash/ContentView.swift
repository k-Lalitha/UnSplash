//
//  ContentView.swift
//  UnSplash
//
//  Created by Lalitha Korlapu on 14/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var imageLoader = ImageLoader()
    let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(imageLoader.images, id: \.0) { image in
                    if image.0.size != .zero {
                        Image(uiImage: image.0)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .onAppear {
                                // Load image asynchronously when it appears
                                if imageLoader.images.last?.0 == image.0 {
                                    imageLoader.fetchImageURLs()
                                }
                            }
                    } else {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .onAppear {
                                imageLoader.loadImage(for: image.1, img: image.0)
                            }
                    }
                }
            }
            .padding()
        }
        .alert(isPresented: $imageLoader.showError) {
            Alert(title: Text("Error"), message: Text(imageLoader.errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            // Load initial batch of images
            imageLoader.fetchImageURLs()
        }
    }
}

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()

    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    func setImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url as NSURL)
    }
}
