import SwiftUI

struct TrayContentView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                switch viewModel.currentView {
                case .actions:
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
                case .bioTags:
                    BioTagsView(viewModel: viewModel)
                case .interests:
                    InterestsView(viewModel: viewModel)
                case .funQuestions:
                FunQuestionsView(viewModel: viewModel)
                case .finalScreen:
                    FinalScreenView(viewModel: viewModel)
                case .periods:
                    PeriodView(viewModel: viewModel)
                case .keypad:
                    KeypadView(viewModel: viewModel)
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
                    viewModel.currentView = .actions
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

struct KeypadView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HeaderView(title: "Custom Duration") {
                withAnimation(.bouncy) { viewModel.currentView = .periods }
            }
            
            VStack(spacing: 6) {
                Text(viewModel.duration.isEmpty ? "0" : viewModel.duration)
                    .font(.system(size: 60, weight: .black))
                    .contentTransition(.numericText())
                
                Text("Days")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical, 20)
            
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
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            viewModel.processDurationKeypad(value: keyValue)
                        }
                    }
                }
            }
        }
    }
}

struct PeriodView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HeaderView(title: "Choose Period") {
                withAnimation(.bouncy) { viewModel.currentView = .actions }
            }
            
            Text("Choose the period you want\nto get subscribed.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .padding(.bottom, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 3), spacing: 15) {
                ForEach(periods) { period in
                    let isSelected = viewModel.selectedPeriod?.id == period.id
                    
                    VStack(spacing: 6) {
                        Text(period.title)
                            .font(period.value == 0 ? .title3 : .title2)
                            .fontWeight(.semibold)
                        
                        if period.value != 0 {
                            Text(period.value == 1 ? "Month" : "Months")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill((isSelected ? Color.blue : Color.gray).opacity(isSelected ? 0.2 : 0.1))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            if period.value == 0 {
                                viewModel.currentView = .keypad
                            } else {
                                viewModel.selectedPeriod = isSelected ? nil : period
                            }
                        }
                    }
                }
            }
        }
    }
} 
