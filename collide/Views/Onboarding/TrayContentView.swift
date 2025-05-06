import SwiftUI

struct TrayContentView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                switch viewModel.currentView {
                case .login:
                    LoginView(viewModel: viewModel)
                case .nextView:
                    NextCustomView(viewModel: viewModel)
                case .phone:
                    PhoneInputView(viewModel: viewModel)
                case .email:
                    EmailLoginView(viewModel: viewModel)
                case .otp:
                    OTPInputView(viewModel: viewModel)
                case .personalDetails:
                    PersonalDetailsView(viewModel: viewModel)
                case .genders:
                    GenderView(viewModel: viewModel)
                case .preferences:
                    PreferencesView(viewModel: viewModel)
                case .college:
                    CollegeView(viewModel: viewModel)
                case .photos:
                    PhotosView(viewModel: viewModel)
                case .BioInterests:
                    BioInterestsView(viewModel: viewModel)
                case .funQuestions:
                FunQuestionsView(viewModel: viewModel)
                case .finalScreen:
                    FinalScreenView(viewModel: viewModel)
                }
            }
            .compositingGroup()
        }
        .padding(20)
    }
}

// Other view structures that need to be defined
struct NextCustomView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HeaderView(title: "Welcome") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .login
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("This is the next view")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("You've successfully logged in with Google/Apple.")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
