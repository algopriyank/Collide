import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(title: "Login or Sign up") {
                viewModel.closeTray()
            }
            
            VStack(spacing: 15) {
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .phone
                    }
                } label: {
                    Text("Continue with Phone")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .email
                    }
                } label: {
                    Text("Continue with Email")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 15) {
                    Button {
                        withAnimation(.bouncy) {
                            viewModel.currentView = .nextView
                        }
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                            Text("Google")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                    }
                    
                    Button {
                        withAnimation(.bouncy) {
                            viewModel.currentView = .nextView
                        }
                    } label: {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Apple")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }
} 
