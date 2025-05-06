//
//  collideApp.swift
//  collide
//
//  Created by Priyank Sharma on 07/04/25.
//

import SwiftUI

@main
struct collideApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.onboardingComplete {
                NavBar()
            } else {
                OnboardingView(viewModel: authViewModel)
            }
        }
    }
}
