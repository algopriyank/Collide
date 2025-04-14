import SwiftUI

struct DraggableCardView: View {
    let user: UserModel
    var onRemove: () -> Void
    
    let namespace: Namespace.ID
    @Binding var selectedUser: UserModel?
    
    @State private var offset: CGSize = .zero
    @State private var isGone = false
    
    var body: some View {
        let photoUrl = user.photos?.first?.photoUrl ?? ""
        
        Button {
            selectedUser = user
        } label: {
            ZStack(alignment: .bottomLeading) {
                if let url = URL(string: photoUrl) {
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
                                .frame(width: 320, height: 460)
                                .clipped()
                                .cornerRadius(25)
                                .matchedTransitionSource(id: "\(user.id)", in: namespace)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 6) {
                                        Spacer()
                                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                                       startPoint: .center,
                                                       endPoint: .bottom)
                                        .frame(height: 120)
                                        .cornerRadius(25)
                                        .overlay(
                                            VStack(alignment: .leading, spacing: 6) {
                                                HStack {
                                                    Text("\(user.name), \(user.age)")
                                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: user.verified ? "checkmark.seal.fill" : "xmark.seal.fill")
                                                        .foregroundColor(user.verified ? .green : .red)
                                                }
                                                
                                                Text(user.college)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                                .padding()
                                        )
                                    }
                                )
                            
                        case .failure:
                            Image("test-image-10")
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(25)
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .frame(width: 320, height: 460)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 10)
            .offset(offset)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .scaleEffect(isGone ? 0.8 : 1)
            .opacity(isGone ? 0 : 1)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        if abs(offset.width) > 120 {
                            withAnimation(.easeInOut) {
                                isGone = true
                                offset.width > 0
                                ? (offset = CGSize(width: 1000, height: 0))
                                : (offset = CGSize(width: -1000, height: 0))
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onRemove()
                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                    }
            )
            .animation(.spring(), value: offset)
        }
        .buttonStyle(.plain)
    }
}

import SwiftUI

struct UserDetailView: View {
    let user: UserModel
    let namespace: Namespace.ID
    let onClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    if let url = URL(string: user.photos?.first?.photoUrl ?? "") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 600)
                                    .clipped()
                                    .matchedTransitionSource(id: "\(user.id)", in: namespace)
                            default:
                                Color.gray.frame(height: 600)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(user.name), \(user.age)")
                            .font(.largeTitle)
                            .bold()
                        
                        Text(user.college)
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text(user.bio ?? "No bio available.")
                            .font(.body)
                            .padding(.top, 4)
                    }
                    .padding()
                }
            }
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
            
            Button(action: {
                onClose()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
                    .clipShape(Circle())
            }
            .padding()
            .padding(.top, 40)
        }
    }
}
