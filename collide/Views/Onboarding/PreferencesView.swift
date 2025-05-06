import SwiftUI

struct PreferencesView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("❤️ Preferences")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .personalDetails
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Interested In")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(["Men", "Women", "Everyone", "Custom"], id: \.self) { option in
                        Text(option)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.interestedIn == option ? Color.blue : Color.gray.opacity(0.1))
                            )
                            .foregroundColor(viewModel.interestedIn == option ? .white : .primary)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    viewModel.interestedIn = option
                                }
                            }
                    }
                }
                
                Text("Looking For")
                    .font(.headline)
                    .padding(.top)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach([
                        "Serious relationship",
                        "Just vibing",
                        "Casual hookups",
                        "Friends only",
                        "Party partner",
                        "Exploring"
                    ], id: \.self) { option in
                        Text(option)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.lookingFor == option ? Color.blue : Color.gray.opacity(0.1))
                            )
                            .foregroundColor(viewModel.lookingFor == option ? .white : .primary)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    viewModel.lookingFor = option
                                }
                            }
                    }
                }
            }
            
            Button {
                withAnimation(.bouncy) {
                    viewModel.currentView = .college
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top)
        }
    }
} 