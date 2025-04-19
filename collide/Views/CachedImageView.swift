//
//  CachedImageView.swift
//  collide
//
//  Created by Priyank Sharma on 14/04/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    @State private var image: Image?
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
            } else {
                Color.gray.opacity(0.3)
                if isLoading {
                    ProgressView()
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard !isLoading else { return }
        isLoading = true
        
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let uiImage = UIImage(data: cachedResponse.data) {
            self.image = Image(uiImage: uiImage)
            self.isLoading = false
        } else {
            URLSession.shared.dataTask(with: request) { data, response, _ in
                guard
                    let data = data,
                    let response = response,
                    let uiImage = UIImage(data: data)
                else { return }
                
                let cachedData = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: request)
                
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                    self.isLoading = false
                }
            }.resume()
        }
    }
}
