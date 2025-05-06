import SwiftUI

struct BioTagsView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    let allTags = [
        "AI", "code", "football", "tv", "games", "music",
        "PSP", "cricket", "driving", "Meme Dealer", "Bookworm",
        "Fitness Freak", "Party Animal", "Traveller", "Reader"
    ]
    
    var body: some View {
        let rows = [GridItem(.fixed(36)), GridItem(.fixed(36)), GridItem(.fixed(36))]
        
        return VStack(spacing: 20) {
            HeaderView(title: "📝 Bio & Tags") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .photos
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Write a little something about you")
                    .font(.headline)
                
                Text("Love chai, memes & road trips.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                TextField("Type your bio here...", text: $viewModel.bio, axis: .vertical)
                    .lineLimit(3...4)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose your tags")
                    .font(.headline)
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 10) {
                        ForEach(allTags, id: \.self) { tag in
                            Button {
                                viewModel.toggleTag(tag)
                            } label: {
                                Text(tag)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.primary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(viewModel.selectedTags.contains(tag) ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Button {
                withAnimation(.bouncy) {
                    viewModel.currentView = .interests
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
