import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            Messages()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
            
            Events()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ProfileCardDetail(user: UserModel.mock)
                .tabItem {
                    Label("Details", systemImage: "heart")
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
