import SwiftUI

struct Home: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                VStack {
                    header
                    
                    Spacer()
                    
                    content
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    viewModel.fetchUsers()
                }
            }
        }
    }
}

private extension Home {
    var backgroundGradient: some View {
        LinearGradient(colors: [.clear, .blue.opacity(0.4), .green.opacity(0.4)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
    
    var header: some View {
        HStack {
            Text("COLLIDE.")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .padding(.horizontal)
            Spacer()
        }
    }
    
    @ViewBuilder
    var content: some View {
        if let error = viewModel.errorMessage {
            errorView
        } else if viewModel.users.isEmpty {
            emptyView
        } else {
            cardStack
        }
    }
    
    var errorView: some View {
        VStack(spacing: 12) {
            Image(systemName: viewModel.errorIcon)
                .font(.system(size: 36))
                .foregroundColor(.yellow)
            
            Text("Oops! Something went wrong.")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
            
            Text(viewModel.errorMessage ?? "Unknown error")
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
    
    var emptyView: some View {
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
    }
    
    var cardStack: some View {
        ZStack {
            ForEach(viewModel.users.prefix(5).reversed()) { user in
                ProfileCard(user: user, onRemove: {
                    withAnimation {
                        viewModel.users.removeAll { $0.id == user.id }
                    }
                })
            }
        }
        .padding(.horizontal)
    }
}
