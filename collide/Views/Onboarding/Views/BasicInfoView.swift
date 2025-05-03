//
//  BasicInfoView.swift
//  collide
//
//  Created by Priyank Sharma on 22/04/25.
//

import SwiftUI

struct BasicInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tell us about yourself")
                .font(.title)
                .bold()
            
            TextField("Name", text: $viewModel.name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            TextField("Age", value: $viewModel.age, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
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
    BasicInfoView()
}
