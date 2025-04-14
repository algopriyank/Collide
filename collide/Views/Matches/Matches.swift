//
//  Matches.swift
//  collide
//
//  Created by Priyank Sharma on 10/04/25.
//

import SwiftUI

struct Matches: View {
    var body: some View {
        
        
        ZStack {
            
            // 🌈 Gradient Background
            LinearGradient(colors: [.clear, .blue.opacity(0.4), .green.opacity(0.4)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            Text("❤️ Matches Screen")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    Matches()
}
