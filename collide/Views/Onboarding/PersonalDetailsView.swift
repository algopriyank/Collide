import SwiftUI

struct PersonalDetailsView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(title: "Personal Details") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .email
                }
            }
            
            // Modified TextField with focus state and fixed padding/styling
            TextField("Full Name", text: $viewModel.name)
                .focused($isNameFocused)
                .padding()
                .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                .autocorrectionDisabled()
                .textContentType(.name)
            
            DatePicker("Date of Birth", selection: $viewModel.dob, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Gender & Pronouns side by side
            HStack(spacing: 12) {
                // GENDER
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .genders
                    }
                } label: {
                    HStack {
                        Text(viewModel.gender.isEmpty ? "Gender" : viewModel.gender)
                            .foregroundColor(viewModel.gender.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(height: 82) // Match the Picker height
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .sheet(isPresented: $viewModel.showGenderPicker) {
                    VStack {
                        Text("Select Gender")
                            .font(.headline)
                            .padding()
                        Picker("Gender", selection: $viewModel.gender) {
                            ForEach(viewModel.genderOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .labelsHidden()
                        .padding()
                        Button("Done") {
                            viewModel.showGenderPicker = false
                        }
                        .padding(.top)
                    }
                    .presentationDetents([.medium])
                }
                
                // PRONOUNS
                Picker("Pronouns", selection: $viewModel.selectedPronoun) {
                    ForEach(viewModel.pronounOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .frame(height: 82)
                .clipped()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button(action: {
                withAnimation(.bouncy) {
                    viewModel.currentView = .preferences
                }
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .personalDetails))
            .opacity(viewModel.isContinueEnabled(for: .personalDetails) ? 1 : 0.5)
            .contentShape(Rectangle())
            .padding(.top)
        }
    }
} 