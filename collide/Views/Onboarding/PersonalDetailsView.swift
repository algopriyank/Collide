import SwiftUI

struct PersonalDetailsView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var isNameFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showGenderTray = false
    @State private var showPronounsTray = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Full Name TextField
            TextField("Full Name", text: $viewModel.name)
                .focused($isNameFocused)
                .padding()
                .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                .autocorrectionDisabled()
                .textContentType(.name)
            
            // Birthday Text Input (replacing the date picker)
            TextField("DD/MM/YYYY", text: Binding(
                get: { viewModel.birthdayText },
                set: { newValue in
                    viewModel.birthdayText = formatBirthdayString(newValue)
                }
            ))
            .keyboardType(.numberPad)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            
            // Your date of birth is always private lock badge
            HStack(spacing: 6) {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.gray)
                Text("Your date of birth is always private")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 10)
            
            // Gender & Pronouns buttons side by side opening sheets
            HStack(spacing: 12) {
                // GENDER
                Button {
                    showGenderTray = true
                } label: {
                    HStack {
                        Text(viewModel.gender.isEmpty ? "Gender" : viewModel.gender)
                            .foregroundColor(viewModel.gender.isEmpty ? .gray : .primary)
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
                
                // PRONOUNS
                Button {
                    showPronounsTray = true
                } label: {
                    HStack {
                        Text(viewModel.selectedPronoun.isEmpty ? "Pronouns" : viewModel.selectedPronoun)
                            .foregroundColor(viewModel.selectedPronoun.isEmpty ? .gray : .primary)
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
            
            // Continue button
            Button(action: {
                withAnimation(.bouncy) {
                    viewModel.currentView = .preferences
                }
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .personalDetails))
            .opacity(viewModel.isContinueEnabled(for: .personalDetails) ? 1 : 0.5)
            .contentShape(Rectangle())
            .padding(.top)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .sheet(isPresented: $showGenderTray) {
            GenderTrayView(viewModel: viewModel, isPresented: $showGenderTray)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showPronounsTray) {
            PronounsTrayView(viewModel: viewModel, isPresented: $showPronounsTray)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }
    
    // Auto formats text input to DD/MM/YYYY format
    private func formatBirthdayString(_ input: String) -> String {
        let clean = input.filter { $0.isNumber }
        var formatted = ""
        for (index, char) in clean.enumerated() {
            if index == 2 {
                formatted.append("/")
            } else if index == 4 {
                formatted.append("/")
            }
            formatted.append(char)
        }
        return String(formatted.prefix(10))
    }
}

// MARK: - Gender Tray Bottom Sheet
struct GenderTrayView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
                .frame(height: 8)
            
            VStack(spacing: 12) {
                ForEach(viewModel.genderOptions, id: \.self) { option in
                    let isSelected = viewModel.gender == option
                    Button {
                        withAnimation(.bouncy(duration: 0.25)) {
                            viewModel.gender = option
                        }
                    } label: {
                        Text(option)
                            .font(.custom("NewKansas-Regular", size: 20))
                            .foregroundColor(.primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(
                                isSelected ? Capsule().fill(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)) : nil
                            )
                    }
                }
            }
            .padding(.vertical, 10)
            
            Button {
                isPresented = false
            } label: {
                HStack(spacing: 8) {
                    Text("Continue")
                    Image(systemName: "arrow.right")
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
            .disabled(viewModel.gender.isEmpty)
            .opacity(viewModel.gender.isEmpty ? 0.5 : 1)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity)
        .background(
            (colorScheme == .dark
                    ? Color.black
                    : Color(red: 0.96, green: 0.94, blue: 0.88))
            .ignoresSafeArea()
        )
    }
}

// MARK: - Pronouns Tray Bottom Sheet
struct PronounsTrayView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
                .frame(height: 8)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(viewModel.pronounOptions, id: \.self) { option in
                        let isSelected = viewModel.selectedPronoun == option
                        Button {
                            withAnimation(.bouncy(duration: 0.25)) {
                                viewModel.selectedPronoun = option
                            }
                        } label: {
                            Text(option)
                                .font(.custom("NewKansas-Regular", size: 18))
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                                .background(
                                    isSelected ? Capsule().fill(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)) : nil
                                )
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            
//            Spacer()
            
            Button {
                isPresented = false
            } label: {
                HStack(spacing: 8) {
                    Text("Continue")
                    Image(systemName: "arrow.right")
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
            .disabled(viewModel.selectedPronoun.isEmpty)
            .opacity(viewModel.selectedPronoun.isEmpty ? 0.5 : 1)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity)
        .background(
            (colorScheme == .dark
                    ? Color.black
                    : Color(red: 0.96, green: 0.94, blue: 0.88))
            .ignoresSafeArea()
        )
    }
}
