import SwiftUI

struct GenderView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HeaderView(title: "Select Gender") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .personalDetails
                }
            }
            
            Text("How do you identify?")
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .padding(.bottom, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2), spacing: 15) {
                ForEach(viewModel.genderOptions, id: \.self) { option in
                    let isSelected = viewModel.gender == option
                    
                    Text(option)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill((isSelected ? Color.blue : Color.gray).opacity(isSelected ? 0.2 : 0.1))
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                viewModel.gender = option
                                viewModel.currentView = .personalDetails
                            }
                        }
                }
            }
        }
    }
} 