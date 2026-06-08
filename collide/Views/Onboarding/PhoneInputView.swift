import SwiftUI

struct PhoneInputView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            Text(viewModel.phoneNumber)
                .font(.custom("NewKansas-Regular", size: 36))
                .contentTransition(.numericText())
                .frame(height: 44)
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
                    .padding(.vertical, 14)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .phone))
            .opacity(viewModel.isContinueEnabled(for: .phone) ? 1 : 0.5)
            .contentShape(Rectangle())
            .padding(.top, 8)
        }
    }
} 