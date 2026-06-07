import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme

    @State private var show = false
    @State private var username = ""

    private let newKansasRegular = "NewKansas-Regular"
    private let newKansasExtraSwash = "NewKansasExtraSwash-LightItalic"

    var body: some View {
        ZStack {

            // MARK: Background

            (colorScheme == .dark
                    ? Color.black
                    : Color(red: 0.96, green: 0.94, blue: 0.88))
                    .ignoresSafeArea()

                LinearGradient(
                    colors: colorScheme == .dark
                    ? [
                        .yellow.opacity(0.5),
                        .white.opacity(0.5)
                    ]
                    : [
                        .yellow.opacity(0.15),
                        .green.opacity(0.12),
                        .clear
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                
                // MARK: Logo
                VStack {
                    HStack {
                        Text("Collide.")
                            .font(.custom(newKansasExtraSwash, size: 32))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                
                // MARK: Hero Card

                LoopingVideoView(videoName: "romcom_loop")
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 32,
                            style: .continuous
                        )
                    )
                    .padding(.top)
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .padding(.horizontal, 18)
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 12,
                        y: 4
                    )

                Spacer()
                    .frame(height: 48)

                // MARK: Headline

                Text("Meet the person you'll tell your friends about.")
                    .font(.custom(newKansasRegular, size: 38))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-4)
                    .padding(.horizontal, 18)

                Spacer()
                    .frame(height: 20)

                Text("College dating that feels like\nsomething out of a rom-com.")
                    .font(.custom(newKansasRegular, size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Spacer()
                    .frame(height: 40)

                // MARK: CTA
                Spacer()
                Button {
                    show = true
                } label: {
                    HStack(spacing: 8) {

                        Text("Start your story")

                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(
                        colorScheme == .dark ? .white : .black
                    )
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .background(
                    RoundedRectangle(
                        cornerRadius: 24,
                        style: .continuous
                    )
                    .fill(Color.black.opacity(0.08))
                )
                .padding(.horizontal, 24)

                Spacer()
                    .frame(height: 24)

                // MARK: Sign In

                HStack(spacing: 4) {

                    Text("Already have an account?")
                        .foregroundStyle(.secondary)

                    Button("Sign In") {
                        show = true
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                }

                Spacer()
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
