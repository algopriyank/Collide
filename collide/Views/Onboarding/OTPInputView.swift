import SwiftUI

struct OTPInputView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(title: "Enter OTP") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .phone
                }
            }
            
            VStack(spacing: 6) {
                HStack(spacing: 12) {
                    ForEach(0..<6) { i in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 40, height: 55)
                            
                            Text(i < viewModel.otp.count ? String(viewModel.otp[viewModel.otp.index(viewModel.otp.startIndex, offsetBy: i)]) : "")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                Text("We've sent an OTP to \(viewModel.phoneNumber)")
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
                            viewModel.processOTPKeypad(value: keyValue)
                        }
                    }
                }
            }
            
            Button(action: {
                withAnimation(.bouncy) {
                    viewModel.currentView = .personalDetails
                }
            }) {
                Text("Verify")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .otp))
            .opacity(viewModel.isContinueEnabled(for: .otp) ? 1 : 0.5)
            .contentShape(Rectangle())
            .padding(.top)
        }
    }
} 