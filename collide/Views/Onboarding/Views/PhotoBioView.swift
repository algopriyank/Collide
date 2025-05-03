//
//  PhotoBioView.swift
//  collide
//
//  Created by Priyank Sharma on 22/04/25.
//

import SwiftUI
import PhotosUI

struct PhotoBioView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var bioText: String = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Complete Your Profile")
                .font(.title)
                .bold()
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Select a Profile Photo")
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        viewModel.photos = [image]
                    }
                }
            }
            
            TextField("Write a short bio...", text: $viewModel.bio)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Finish") {
                Task {
                    do {
                        try await viewModel.saveProfile()
                        viewModel.currentStep += 1
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    PhotoBioView()
}
