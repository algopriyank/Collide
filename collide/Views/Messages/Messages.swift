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
        NavigationStack {
            VStack {
                Text("💬 Messages Screen")
                    .font(.largeTitle)
                    .padding()
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline) // optional
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(authViewModel.name.isEmpty ? "You" : authViewModel.name)
                }
            }
        }
        
    }
}

#Preview {
    Messages()
}
