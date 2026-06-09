import SwiftUI

struct PreferencesView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showInterestedInTray = false
    @State private var showLookingForTray = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 10)
            
            // INTERESTED IN SELECTION BUTTON
            VStack(alignment: .leading, spacing: 8) {
                Text("Interested In")
                    .font(.custom("NewKansas-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Button {
                    showInterestedInTray = true
                } label: {
                    HStack {
                        Text(viewModel.interestedIn.isEmpty ? "Who are you interested in?" : viewModel.interestedIn)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(viewModel.interestedIn.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            // LOOKING FOR SELECTION BUTTON
            VStack(alignment: .leading, spacing: 8) {
                Text("Looking For")
                    .font(.custom("NewKansas-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Button {
                    showLookingForTray = true
                } label: {
                    HStack {
                        Text(viewModel.lookingFor.isEmpty ? "What are you looking for?" : viewModel.lookingFor)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(viewModel.lookingFor.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            Spacer()
            
            // CONTINUE BUTTON
            Button {
                withAnimation(.bouncy) {
                    viewModel.currentView = .college
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .preferences))
            .opacity(viewModel.isContinueEnabled(for: .preferences) ? 1 : 0.5)
            .padding(.top)
        }
        .sheet(isPresented: $showInterestedInTray) {
            InterestedInTrayView(viewModel: viewModel, isPresented: $showInterestedInTray)
                .presentationDetents([.height(660)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showLookingForTray) {
            LookingForTrayView(viewModel: viewModel, isPresented: $showLookingForTray)
                .presentationDetents([.height(660)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Selection Card View
struct SelectionCardView: View {
    let title: String
    let isSelected: Bool
    let imageName: String?
    let placeholderIcon: String
    let height: CGFloat
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            if let imageName = imageName {
                // Free-flowing image layout without any outer card box
                VStack(spacing: 10) {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2.5)
                        )
                        .frame(maxHeight: .infinity)
                    
                    Text(title)
                        .font(.custom("NewKansas-Regular", size: 15))
                        .bold(isSelected)
                        .foregroundColor(isSelected ? .blue : .primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 4)
                }
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .scaleEffect(isSelected ? 1.04 : 1.0)
                .animation(.snappy, value: isSelected)
            } else {
                // Fallback boxed card layout when there is no image
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.04))
                        
                        Image(systemName: placeholderIcon)
                            .font(.title3)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .padding([.top, .horizontal], 8)
                    
                    Text(title)
                        .font(.custom("NewKansas-Regular", size: 15))
                        .bold(isSelected)
                        .foregroundColor(isSelected ? .blue : .primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                }
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: isSelected ? 2.5 : 1)
                )
                .shadow(color: Color.black.opacity(isSelected ? 0.05 : 0.02), radius: 6, x: 0, y: 3)
                .scaleEffect(isSelected ? 1.02 : 1.0)
                .animation(.snappy, value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Interested In Tray View
struct InterestedInTrayView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    private let options = [
        "Straight",
        "Bisexual",
        "Homosexual Gay",
        "Homosexual Lesbian",
        "Pansexual",
        "Asexual"
    ]
    
    private func imageName(for option: String) -> String {
        switch option {
        case "Straight": return "straight"
        case "Bisexual": return "bisexual"
        case "Homosexual Gay": return "homosexualGay"
        case "Homosexual Lesbian": return "homosexualLesbian"
        case "Pansexual": return "pansexual"
        case "Asexual": return "asexual"
        default: return ""
        }
    }
    
    private func icon(for option: String) -> String {
        return "person.fill"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 8)
            
            Text("Interested In")
                .font(.custom("NewKansas-Regular", size: 24))
                .foregroundColor(.primary)
                .padding(.top, 10)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(options, id: \.self) { option in
                    let isSelected = viewModel.interestedIn == option
                    SelectionCardView(
                        title: option,
                        isSelected: isSelected,
                        imageName: imageName(for: option),
                        placeholderIcon: icon(for: option),
                        height: 160
                    ) {
                        withAnimation(.snappy) {
                            viewModel.interestedIn = option
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                isPresented = false
            } label: {
                HStack(spacing: 8) {
                    Text("Done")
                    Image(systemName: "checkmark")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                )
            }
            .disabled(viewModel.interestedIn.isEmpty)
            .opacity(viewModel.interestedIn.isEmpty ? 0.5 : 1)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(
            (colorScheme == .dark
                    ? Color.black
                    : Color(red: 0.96, green: 0.94, blue: 0.88))
            .ignoresSafeArea()
        )
    }
}

// MARK: - Looking For Tray View
struct LookingForTrayView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    private let options = [
        "Serious relationship",
        "Just vibing",
        "Casual hookups",
        "Friends only",
        "Party partner",
        "Exploring"
    ]
    
    private func imageName(for option: String) -> String {
        switch option {
        case "Serious relationship": return "seriousRelationship"
        case "Just vibing": return "justVibing"
        case "Casual hookups": return "CasualHookups"
        case "Friends only": return "friendsOnly"
        case "Party partner": return "partyPartner"
        case "Exploring": return "exploring"
        default: return ""
        }
    }
    
    private func icon(for option: String) -> String {
        switch option {
        case "Serious relationship": return "heart.fill"
        case "Just vibing": return "sparkles"
        case "Casual hookups": return "bolt.fill"
        case "Friends only": return "person.2.fill"
        case "Party partner": return "wineglass.fill"
        default: return "safari.fill"
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 8)
            
            Text("Looking For")
                .font(.custom("NewKansas-Regular", size: 24))
                .foregroundColor(.primary)
                .padding(.top, 10)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 14) {
                ForEach(options, id: \.self) { option in
                    let isSelected = viewModel.lookingFor == option
                    SelectionCardView(
                        title: option,
                        isSelected: isSelected,
                        imageName: imageName(for: option),
                        placeholderIcon: icon(for: option),
                        height: 150
                    ) {
                        withAnimation(.snappy) {
                            viewModel.lookingFor = option
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                isPresented = false
            } label: {
                HStack(spacing: 8) {
                    Text("Done")
                    Image(systemName: "checkmark")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                )
            }
            .disabled(viewModel.lookingFor.isEmpty)
            .opacity(viewModel.lookingFor.isEmpty ? 0.5 : 1)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(
            (colorScheme == .dark
                    ? Color.black
                    : Color(red: 0.96, green: 0.94, blue: 0.88))
            .ignoresSafeArea()
        )
    }
}