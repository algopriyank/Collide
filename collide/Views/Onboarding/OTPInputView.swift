import SwiftUI

struct OTPInputView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    ForEach(0..<6) { i in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 38, height: 50)
                            
                            Text(i < viewModel.otp.count ? String(viewModel.otp[viewModel.otp.index(viewModel.otp.startIndex, offsetBy: i)]) : "")
                                .font(.custom("NewKansas-Regular", size: 24))
                        }
                    }
                }
                
                Text("We've sent an OTP to \(viewModel.phoneNumber)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                ForEach(keypadValues) { keyValue in
                    Group {
                        if keyValue.isBack {
                            Image(systemName: keyValue.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                        } else {
                            Text(keyValue.title)
                                .font(.custom("NewKansas-Regular", size: 24))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
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
                    .padding(.vertical, 14)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .otp))
            .opacity(viewModel.isContinueEnabled(for: .otp) ? 1 : 0.5)
            .contentShape(Rectangle())
            .padding(.top, 8)
        }
    }
} 