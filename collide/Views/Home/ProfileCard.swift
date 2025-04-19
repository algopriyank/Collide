//
//  drag-2.swift
//  collide
//
//  Created by Priyank Sharma on 15/04/25.
//
import SwiftUI

struct ProfileCard: View {
    @State private var offset: CGSize = .zero
    @State private var isGone = false
    
    let user: UserModel
    var onRemove: () -> Void
    let namespace: Namespace.ID
    
    var body: some View {
        cardContent
            .buttonStyle(.plain)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 10)
            .offset(offset)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .scaleEffect(isGone ? 0.8 : 1)
            .opacity(isGone ? 0 : 1)
            .gesture(dragGesture)
            .animation(.spring(), value: offset)
    }
    
    private var photoUrl: String {
        user.photos?.first?.photoUrl ?? ""
    }
    
    private var cardContent: some View {
        ZStack {
            if let url = URL(string: photoUrl) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .matchedTransitionSource(id: user, in: namespace)
                    .frame(width: 360, height: 540)
                    .cornerRadius(24)
                
                infoOverlay
                    .frame(width: 360, height: 540)
                    .cornerRadius(24)
                
                VStack {
                    Spacer()
                    infoText
                        .padding()
                }
                .frame(width: 360, height: 540)
                .cornerRadius(24)
            }
        }
    }
    
    private var infoOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
            startPoint: .center,
            endPoint: .bottom
        )
    }
    
    private var infoText: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(user.name), \(user.age)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: user.verified ? "checkmark.seal.fill" : "xmark.seal.fill")
                    .font(.title3)
                    .foregroundColor(user.verified ? .green : .red)
            }
            
            Text(user.college)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var dragGesture: some Gesture {
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
    }
}
