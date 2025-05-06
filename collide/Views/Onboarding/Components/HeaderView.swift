import SwiftUI

struct HeaderView: View {
    let title: String
    let backAction: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Button(action: backAction) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
            }
        }
        .padding(.bottom, 10)
    }
} 