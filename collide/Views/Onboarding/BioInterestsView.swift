import SwiftUI

struct BioInterestsView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    let interests = [
        "Hip-hop", "Indie", "EDM", "Netflix", "Anime", "K-Dramas",
        "Coding", "Painting", "Reading", "Gym", "Hiking", "Tech fests",
        "Chill", "House parties", "Ragers"
    ]
    
    var body: some View {
        let rows = [
            GridItem(.fixed(40)),
            GridItem(.fixed(40)),
            GridItem(.fixed(40))
        ]
        
        VStack(alignment: .leading, spacing: 20) {
            HeaderView(title: "📝 Your Bio & Interests") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .photos
                }
            }
            
                // Bio Input
            VStack(alignment: .leading, spacing: 12) {
                Text("Write a little something about you")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text("Love chai, memes & road trips.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.horizontal)
                
                TextField("Type your bio here...", text: $viewModel.bio, axis: .vertical)
                    .lineLimit(3...4)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
            
                // Interest Picker
            VStack(alignment: .leading, spacing: 12) {
                Text("Pick 5+ interests")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: 12) {
                        ForEach(interests, id: \.self) { interest in
                            Button {
                                viewModel.toggleInterest(interest)
                            } label: {
                                Text(interest)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.primary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(viewModel.selectedInterests.contains(interest) ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 140)
            }
            
                // Continue Button
            Button {
                withAnimation(.bouncy) {
                    viewModel.currentView = .funQuestions
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(viewModel.isContinueEnabled(for: .funQuestions) ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .funQuestions))
            .padding(.horizontal)
            .padding(.top)
        }
    }
}
