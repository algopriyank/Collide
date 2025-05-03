//
//  InterestsView.swift
//  collide
//
//  Created by Priyank Sharma on 22/04/25.
//

import SwiftUI

struct InterestsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    let allInterests = ["Music", "Sports", "Travel", "Reading", "Cooking", "Movies"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Interests")
                .font(.title)
                .bold()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(allInterests, id: \.self) { interest in
                        Button(action: {
                            if viewModel.interests.contains(interest) {
                                viewModel.interests.removeAll { $0 == interest }
                            } else {
                                viewModel.interests.append(interest)
                            }
                        }) {
                            Text(interest)
                                .padding()
                                .background(viewModel.interests.contains(interest) ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            Button("Next") {
                viewModel.currentStep += 1
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }
}


#Preview {
    InterestsView()
}
