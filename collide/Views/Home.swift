import SwiftUI

struct Home: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
                // 🌈 Gradient Background
            LinearGradient(colors: [.indigo.opacity(0.4), .pink.opacity(0.4)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                    // 🧭 Header
                HStack {
                    Text("COLLIDE.")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                    Spacer()
                }
                Spacer()
                
                    //Check for error - error handling
                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")     //if found -> print error
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                else if viewModel.users.isEmpty {     //if loading -> show loading...
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                else {    //if no error -> DraggableCardView
                    ZStack {
                        ForEach(viewModel.users.prefix(2).reversed()) { user in
                            DraggableCardView(user: user) {
                                withAnimation {
                                    viewModel.users.removeAll { $0.id == user.id }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .transition(.scale)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

    //MARK: - Draggable Card (move to new file) - TODO

struct DraggableCardView: View {
    let user: UserModel
    var onRemove: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var isGone = false
    @State private var isImageLoaded = false
    
    var body: some View {
        let photoUrl = user.photos?.first?.photoUrl ?? ""
        if !photoUrl.isEmpty {
            print("📷 Using URL for \(user.name): \(photoUrl)")
        } else {
            print("❌ No photo URL found for \(user.name)")
        }
        
        return ZStack(alignment: .bottomLeading) {
                // 🖼 Image Layer
            ZStack {
                if let url = URL(string: photoUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.3)
                                ProgressView()
                            }
                            .frame(width: 320, height: 460)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 320, height: 460)
                                .clipped()
                                .drawingGroup()
//                                .onAppear {
//                                    withAnimation(.easeIn(duration: 0.25)) {
//                                        isImageLoaded = true
//                                    }
//                                }
                            
//                            if !isImageLoaded {
//                                Color.black.opacity(0.3)
//                                ProgressView()
//                            }
                            
                        case .failure:
                            Image("test-image-10")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 320, height: 460)
                                .clipped()
                        @unknown default:
                            Color.gray.opacity(0.2)
                        }
                    }
                } else {
                    Image("test-image-10")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 320, height: 460)
                        .clipped()
                }
            }
            
                // ✅ Add Swipe Indicator *on top of image*
            SwipeActionIndicatorView(xOffset: $offset.width)
                .cornerRadius(25)
                .frame(width: 320, height: 460)
            
                // 🌈 Gradient Overlay
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(1)]),
                           startPoint: .center,
                           endPoint: .bottom)
            .frame(width: 320, height: 460)
            
                // 🧑‍🦱 User Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(user.name), \(user.age)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    if user.verified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.headline)
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.seal.fill")
                            .foregroundColor(.red)
                    }
                }
                
                Text(user.college)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .frame(width: 320, height: 460)
        .background(Color.black.opacity(isImageLoaded ? 0.05 : 0.5))
        .cornerRadius(25)
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
}
struct SwipeActionIndicatorView: View {
    @Binding var xOffset: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.clear, xOffset > 0 ? .green.opacity(0.5) : .red.opacity(0.5)],
                    startPoint: xOffset > 0 ? .leading : .trailing,
                    endPoint: xOffset > 0 ? .trailing : .leading
                )
            )
            .opacity(min(abs(xOffset / SizeConstants.screenCutoff), 1.0))
    }
}

struct SizeConstants {
    static var screenCutoff: CGFloat {
        (UIScreen.main.bounds.width / 2) * 0.8
    }
    
    static var cardWidth: CGFloat {
        UIScreen.main.bounds.width - 20
    }
    
    static var cardHeight: CGFloat {
        UIScreen.main.bounds.height / 1.45
    }
}

#Preview {
    Home()
}
