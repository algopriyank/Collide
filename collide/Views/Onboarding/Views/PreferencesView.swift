//
//  PreferencesView.swift
//  collide
//
//  Created by Priyank Sharma on 22/04/25.
//

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    let genders = ["Male", "Female", "Non-binary", "Other"]
    let preferences = ["Men", "Women", "Everyone"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Preferences")
                .font(.title)
                .bold()
            
            Picker("Gender", selection: $viewModel.gender) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Interested in", selection: $viewModel.preference) {
                ForEach(preferences, id: \.self) { preference in
                    Text(preference)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
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
    PreferencesView()
}
