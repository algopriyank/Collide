import SwiftUI

struct EmailLoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(title: "Enter Email") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .actions
                    viewModel.resetEmailLogin()
                }
            }
            
            VStack(spacing: 14) {
                TextField("you@example.com", text: $viewModel.email)
                    .focused($isEmailFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                
                if viewModel.emailLoginStarted {
                    SecureField("Enter Password", text: $viewModel.password)
                        .focused($isPasswordFocused)
                        .textContentType(.password)
                        .padding()
                        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }
            }
            
            Button(action: {
                withAnimation(.bouncy) {
                    if viewModel.emailLoginStarted {
                        viewModel.currentView = .personalDetails
                    } else {
                        viewModel.emailLoginStarted = true
                    }
                }
            }) {
                Text(viewModel.emailLoginStarted ? "Login" : "Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .email))
            .opacity(viewModel.isContinueEnabled(for: .email) ? 1 : 0.5)
            .contentShape(Rectangle())
            .padding(.top)
        }
    }
} 