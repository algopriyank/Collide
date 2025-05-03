//
//  OnboardingViewModel.swift
//  collide
//
//  Created by Priyank Sharma on 22/04/25.
//

import SwiftUI
import Supabase

class OnboardingViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var age: Int?
    @Published var gender: String = ""
    @Published var preference: String = ""
    @Published var interests: [String] = []
    @Published var bio: String = ""
    @Published var photos: [UIImage] = []
    
    @Published var currentStep: Int = 0
    
        // Supabase client instance
    private let client = SupabaseClient(
        supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
        supabaseKey: "YOUR_SUPABASE_ANON_KEY"
    )
    
        // Sign up user with email and password
    func signUp() async throws {
        try await client.auth.signUp(
            email: email,
            password: password
        )
    }
    
        // Save user profile data to Supabase
    func saveProfile() async throws {
        guard let user = try await client.auth.session.user else { return }
        
        let profileData: [String: Any] = [
            "id": user.id,
            "name": name,
            "age": age ?? 0,
            "gender": gender,
            "preference": preference,
            "interests": interests,
            "bio": bio
            // Handle photo upload separately
        ]
        
        try await client
            .from("profiles")
            .insert(profileData)
            .execute()
    }
}
