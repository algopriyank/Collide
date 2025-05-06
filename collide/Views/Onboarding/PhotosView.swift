import SwiftUI

struct PhotosView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        let boxSize: CGFloat = 100
        let spacing: CGFloat = 10
        
        let columns = Array(repeating: GridItem(.fixed(boxSize), spacing: spacing), count: 3)
        
        return VStack(spacing: 20) {
            HStack {
                Text("📸 Upload Photos")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .college
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(0..<6, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: boxSize, height: boxSize)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.selectedImages[index] != nil ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                        
                        if let image = viewModel.selectedImages[index] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: boxSize, height: boxSize)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        
                        if viewModel.selectedImages[index] != nil {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        viewModel.removeImage(at: index)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .background(Color.black.opacity(0.6))
                                            .clipShape(Circle())
                                    }
                                }
                                Spacer()
                            }
                            .frame(width: boxSize, height: boxSize)
                            .padding(6)
                        }
                    }
                    .onTapGesture {
                        if viewModel.selectedImages[index] == nil {
                            viewModel.selectImage(at: index)
                        }
                    }
                }
            }
            
            Button {
                withAnimation(.bouncy) {
                    viewModel.currentView = .bioTags
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(viewModel.isContinueEnabled(for: .photos) ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .photos))
        }
        .sheet(isPresented: $viewModel.showingImagePicker, onDismiss: {
            viewModel.applySelectedImage()
        }) {
            ImagePicker(image: $viewModel.tempImage)
        }
    }
} 