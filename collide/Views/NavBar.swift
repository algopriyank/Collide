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
            
            ProfileView(user: UserModel.mock)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(.indigo) // Accent color for selected tab
    }
}

#Preview {
    NavBar()
}
