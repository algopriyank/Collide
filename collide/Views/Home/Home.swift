import SwiftUI

struct Home: View {
    @StateObject private var viewModel = HomeViewModel()
    @Namespace private var zoomNamespace
    @State private var selectedUser: UserModel?
    
    var body: some View {
        NavigationStack {
            ZStack {
                    // 🌈 Gradient Background
                LinearGradient(colors: [.clear, .blue.opacity(0.4), .green.opacity(0.4)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack {
                        // 🧭 Header
                    HStack {
                        Text("COLLIDE.")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    Spacer()
                    
                        // 🚨 Error View
                    if let error = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: viewModel.errorIcon)
                                .font(.system(size: 36))
                                .foregroundColor(.yellow)
                            
                            Text("Oops! Something went wrong.")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Retry") {
                                viewModel.fetchUsers()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.white)
                        }
                        .padding()
                    }
                    
                        // 🔄 Empty State
                    else if viewModel.users.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            
                            Text("No profiles left to show.")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("Come back later for more suggestions 💫")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Button("Reload") {
                                viewModel.fetchUsers()
                            }
                            .buttonStyle(.bordered)
                            .tint(.white)
                        }
                        .padding()
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                    }
                    
                        // 🃏 Cards
                    else {
                        ZStack {
                            ForEach(viewModel.users.prefix(2).reversed()) { user in
                                DraggableCardView(user: user,
                                                  onRemove: {
                                    withAnimation {
                                        viewModel.users.removeAll { $0.id == user.id }
                                    }
                                },
                                                  namespace: zoomNamespace,
                                                  selectedUser: $selectedUser)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    viewModel.fetchUsers()
                }
                
                    // 👤 Zoomed Detail View
                if let user = selectedUser {
                    UserDetailView(user: user, namespace: zoomNamespace) {
                        selectedUser = nil
                    }
                    .navigationTransition(.zoom(sourceID: "\(user.id)", in: zoomNamespace))
                    .zIndex(1)
                }
            }
        }
    }
}

#Preview {
    Home()
}
