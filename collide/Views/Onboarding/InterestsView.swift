import SwiftUI

struct InterestsView: View {
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
        
        return VStack(alignment: .leading, spacing: 20) {
            HeaderView(title: "What are you into?") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .bioTags
                }
            }
            
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
            
            Button {
                withAnimation(.bouncy) {
                    viewModel.currentView = .funQuestions
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(viewModel.isContinueEnabled(for: .interests) ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isContinueEnabled(for: .interests))
            .padding(.top)
        }
    }
} 