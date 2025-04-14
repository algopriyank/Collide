import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            Messages()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }.symbolEffect(.bounce)
            
            Events()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            Matches()
                .tabItem {
                    Label("Matches", systemImage: "heart")
                }
            
            Profile()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(.pink.opacity(0.8)) // Accent color for selected tab
    }
}
#Preview {
    NavBar()
}
