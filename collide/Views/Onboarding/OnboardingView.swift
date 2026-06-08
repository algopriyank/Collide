import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme

    @State private var username = ""

    private let newKansasRegular = "NewKansas-Regular"
    private let newKansasExtraSwash = "NewKansasExtraSwash-LightItalic"

    private func currentStageIndex(for view: CurrentView) -> Int {
        switch view {
        case .welcome:
            return -1
        case .login, .phone, .otp, .email, .nextView:
            return 0
        case .personalDetails, .genders:
            return 1
        case .preferences:
            return 2
        case .college:
            return 3
        case .photos:
            return 4
        case .BioInterests:
            return 5
        case .funQuestions:
            return 6
        case .finalScreen:
            return 7
        }
    }

    private func currentTitle(for view: CurrentView) -> String? {
        switch view {
        case .welcome:
            return nil
        case .login:
            return "Login or Sign up"
        case .nextView:
            return "Welcome"
        case .phone:
            return "Enter Phone Number"
        case .otp:
            return "Enter OTP"
        case .email:
            return "Enter Email"
        case .personalDetails:
            return "Personal Details"
        case .genders:
            return "Select Gender"
        case .preferences:
            return "❤️ Preferences"
        case .college:
            return "🎓 College Details"
        case .photos:
            return "📸 Upload Photos"
        case .BioInterests:
            return "📝 Your Bio & Interests"
        case .funQuestions:
            return "Fun Questions"
        case .finalScreen:
            return nil
        }
    }

    private func goBack() {
        withAnimation(.bouncy) {
            switch viewModel.currentView {
            case .welcome:
                break
            case .login:
                viewModel.currentView = .welcome
            case .nextView:
                viewModel.currentView = .login
            case .phone:
                viewModel.currentView = .login
            case .otp:
                viewModel.currentView = .phone
            case .email:
                viewModel.currentView = .login
            case .personalDetails:
                viewModel.currentView = .email
            case .genders:
                viewModel.currentView = .personalDetails
            case .preferences:
                viewModel.currentView = .personalDetails
            case .college:
                viewModel.currentView = .preferences
            case .photos:
                viewModel.currentView = .college
            case .BioInterests:
                viewModel.currentView = .photos
            case .funQuestions:
                viewModel.currentView = .BioInterests
            case .finalScreen:
                viewModel.currentView = .funQuestions
            }
        }
    }

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
                
                // MARK: Logo & Back Button Header
                HStack {
                    Text("Collide.")
                        .font(.custom(newKansasExtraSwash, size: 32))
                    Spacer()
                    if viewModel.currentView != .welcome && viewModel.currentView != .finalScreen {
                        Button(action: goBack) {
                            Image(systemName: "chevron.backward")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(8)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                // MARK: Progress Bar
                if viewModel.currentView != .welcome {
                    let currentStage = currentStageIndex(for: viewModel.currentView)
                    HStack(spacing: 6) {
                        ForEach(0..<8) { index in
                            Capsule()
                                .fill(index <= currentStage ? Color.blue : Color.gray.opacity(0.2))
                                .frame(height: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                } else {
                    Spacer().frame(height: 14)
                }
                
                // MARK: Hero Card

                LoopingVideoView(videoName: "romcom_loop")
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 32,
                            style: .continuous
                        )
                    )
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .padding(.horizontal, 18)
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 12,
                        y: 4
                    )

                // MARK: Dynamic Title Below Video
                if viewModel.currentView != .welcome, let title = currentTitle(for: viewModel.currentView) {
                    HStack {
                        Text(title)
                            .font(.custom(newKansasRegular, size: 28))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 18)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
                    .id("title_\(viewModel.currentView)")
                }

                Spacer() // Pushes content to the bottom

                // MARK: Dynamic Onboarding Content
                VStack(spacing: 0) {
                    if viewModel.currentView == .welcome {
                        welcomeDetailsView
                    } else {
                        TrayContentView(viewModel: viewModel)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            viewModel.onCloseTray = {
                withAnimation(.bouncy) {
                    viewModel.currentView = .welcome
                }
            }
        }
    }

    private var welcomeDetailsView: some View {
        VStack(spacing: 0) {
            Spacer()
            // MARK: Headline
            Text("Meet the person \nyou'll tell your \nfriends about.")
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
//                .frame(height: 40)

            // MARK: CTA
            Button {
                withAnimation(.bouncy) {
                    viewModel.currentView = .login
                }
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
                    withAnimation(.bouncy) {
                        viewModel.currentView = .login
                    }
                }
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        ))
    }
    }


#Preview {
    OnboardingView(viewModel: AuthViewModel())
}
