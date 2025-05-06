import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var show = false
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [.clear, .cyan.opacity(0.24), .green.opacity(0.24)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Image inside RoundedRectangle
                Image("loginBackground5")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.horizontal, 24)
                
                // Text below image
                Text("Welcome to Collide")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Text("This app is basically Jim looking at Pam.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    show.toggle()
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 24)
                }
                .padding()
            }
        }
        .systemTrayView($show) {
            TrayContentView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.onCloseTray = {
                show = false
            }
        }
    }
}

#Preview {
    OnboardingView(viewModel: AuthViewModel())
}
