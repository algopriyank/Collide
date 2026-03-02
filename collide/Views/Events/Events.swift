//
//  Events.swift
//  collide
//
//  Created by Priyank Sharma on 10/04/25.
//

import SwiftUI

struct Events: View {
    
    @StateObject private var authViewModel = AuthViewModel() // This is for the reset onboarding button
    var body: some View {
        Text("🎉 Events Screen")
            .font(.largeTitle)
            .padding()

        Button("Reset Onboarding") {
            UserDefaults.standard.set(false, forKey: "onboardingComplete")
            authViewModel.onboardingComplete = false
        }
    }
}
#Preview {
    Events()
}
