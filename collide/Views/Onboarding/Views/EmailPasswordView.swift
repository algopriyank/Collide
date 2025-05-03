//
//  EmailPasswordView.swift
//  collide
//
//  Created by Priyank Sharma on 22/04/25.
//

import SwiftUI

struct EmailPasswordView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Collide!")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Next") {
                Task {
                    do {
                        try await viewModel.signUp()
                        viewModel.currentStep += 1
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    EmailPasswordView(viewModel: OnboardingViewModel())
}
