import SwiftUI

struct ProfileCardDetail: View {
    let user: UserModel
    
    var photoUrl: String {
        user.photos?.first?.photoUrl ?? ""
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                if let url = URL(string: photoUrl) {
                    CachedAsyncImage(url: url)
                        .scaledToFill()
                        .overlay {
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("\(user.name), \(user.age)")
                            .font(.title)
                            .bold()
                        Spacer()
                        Image(systemName: user.verified ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .foregroundColor(user.verified ? .green : .red)
                    }
                    
                    Text(user.college)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.gray.opacity(0.2)))
                    
                    Text(user.bio ?? "No bio available.")
                        .font(.body)
                        .padding(.top, 4)
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<3) { index in
                            VStack(alignment: .leading, spacing: 8) {
                                Image("name10")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 420)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Text("Barbie quote \(index + 1)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 4)
                            }
                            .frame(width: 300)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .ignoresSafeArea(edges: .top)
            .toolbar {
                Button {
                        // Add dismiss action
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}
