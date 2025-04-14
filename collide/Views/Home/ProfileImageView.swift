//
//  ProfileImageView.swift
//  collide
//
//  Created by Priyank Sharma on 10/04/25.
//


import SwiftUI

struct ProfileImageView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image("test-image-10")
                    .resizable()
                    .scaledToFill()
            @unknown default:
                Color.gray.opacity(0.2)
            }
        }
        .frame(width: 320, height: 460)
        .clipped()
        .drawingGroup() // 🧠 GPU offload
    }
}
