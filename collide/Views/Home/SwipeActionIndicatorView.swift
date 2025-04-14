//
//  SwipeActionIndicatorView.swift
//  collide
//
//  Created by Priyank Sharma on 10/04/25.
//


import SwiftUI
import SwiftUI

struct SwipeActionIndicatorView: View {
    @Binding var xOffset: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.clear, xOffset > 0 ? .green.opacity(0.5) : .red.opacity(0.5)],
                    startPoint: xOffset > 0 ? .leading : .trailing,
                    endPoint: xOffset > 0 ? .trailing : .leading
                )
            )
            .opacity(min(abs(xOffset / SizeConstants.screenCutoff), 1.0))
    }
}