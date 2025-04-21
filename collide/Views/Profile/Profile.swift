//
//  Profile.swift
//  collide
//
//  Created by Priyank Sharma on 10/04/25.
//
import SwiftUI

struct ProfileView: View {
    let user: UserModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                    // Profile Avatar
                if let avatarUrl = user.avatar, let url = URL(string: avatarUrl) {
                    CachedAsyncImage(url: url)
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                }
                
                    // Name, Age & Verification
                HStack(spacing: 8) {
                    Text("\(user.name), \(user.age)")
                        .font(.title)
                        .bold()
                    Image(systemName: user.verified ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .foregroundColor(user.verified ? .green : .red)
                }
                
                    // College
                Text(user.college)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.gray.opacity(0.2)))
                
                    // Bio
                Text(user.bio ?? "No bio available.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Divider()
                
                    // Photo Gallery
                if let photos = user.photos, !photos.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(photos) { photo in
                                if let url = URL(string: photo.photoUrl) {
                                    CachedAsyncImage(url: url)
                                        .scaledToFill()
                                        .frame(width: 200, height: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(
                colors: [.clear, .blue.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    ProfileView(user: UserModel.mock)
}
