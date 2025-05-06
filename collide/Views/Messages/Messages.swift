//
//  Messages.swift
//  collide
//
//  Created by Priyank Sharma on 10/04/25.
//

import SwiftUI

struct Messages: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            Text("💬 Messages Screen")
                .font(.largeTitle)
                .padding()
            
            Button("Reset Onboarding") {
                UserDefaults.standard.set(false, forKey: "onboardingComplete")
                authViewModel.onboardingComplete = false
            }
        }
    }
}

#Preview {
    Messages()
}
