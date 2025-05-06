import SwiftUI

struct PhoneInputView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(title: "Enter Phone Number") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .actions
                }
            }
            
            VStack(spacing: 6) {
                Text(viewModel.phoneNumber.isEmpty ? "Enter Number" : viewModel.phoneNumber)
                    .font(.system(size: 40, weight: .bold))
                    .contentTransition(.numericText())
                    .frame(height: 50)
                
                Text("We'll send you an OTP to verify")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 3), spacing: 15) {
                ForEach(keypadValues) { keyValue in
                    Group {
                        if keyValue.isBack {
                            Image(systemName: keyValue.title)
                        } else {
                            Text(keyValue.title)
                        }
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            viewModel.processPhoneKeypad(value: keyValue)
                        }
                    }
                }
            }
            
            Button(action: {
                withAnimation(.bouncy) {
                    viewModel.currentView = .otp
                }
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .phone))
            .opacity(viewModel.isContinueEnabled(for: .phone) ? 1 : 0.5)
            .contentShape(Rectangle())
            .padding(.top)
        }
    }
} 