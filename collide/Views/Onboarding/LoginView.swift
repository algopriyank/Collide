import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 15) {
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .phone
                    }
                } label: {
                    Text("Continue with Phone")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .email
                    }
                } label: {
                    Text("Continue with Email")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 15) {
                    Button {
                        withAnimation(.bouncy) {
                            viewModel.currentView = .nextView
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("G")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundColor(.blue)
                            Text("Google")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            Capsule()
                                .stroke(Color.blue, lineWidth: 1.5)
                        )
                    }
                    
                    Button {
                        withAnimation(.bouncy) {
                            viewModel.currentView = .nextView
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "applelogo")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                            Text("Apple")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            Capsule()
                                .stroke(Color.primary, lineWidth: 1.5)
                        )
                    }
                }
            }
        }
    } 
