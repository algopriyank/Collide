//
//  FinalScreenView.swift
//  logintest
//
//  Created by Priyank Sharma on 05/05/25.
//

import SwiftUI

struct FinalScreenView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
                // Title
            VStack(spacing: 8) {
                Text("🚀 You're all set!")
                    .font(.largeTitle.bold())
                
                Text("Here’s a sneak peek of your profile")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
                // Profile Preview Card (mock)
            ProfileCardView(viewModel: viewModel)
                .padding(.horizontal)
            
            Spacer()
            
                // CTA Button
            Button(action: {
                withAnimation(.bouncy) {
                    viewModel.onboardingComplete = true
                }
            }) {
                Text("Let’s Collide 🚀")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ProfileCardView: View {
    let viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                // Placeholder image or user's first photo
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(3/4, contentMode: .fit)
                .overlay(
                    Text("📸")
                        .font(.system(size: 40))
                        .opacity(0.3)
                )
                .cornerRadius(12)
            
                // Name, Age
            Text("\(viewModel.name), 18)")
                .font(.title2.bold())
            
                // Bio or Fun Answer
            if let funAnswer = viewModel.funQuestionAnswers.values.first(where: { !$0.isEmpty }) {
                Text("“\(funAnswer)”")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 4)
    }
}
