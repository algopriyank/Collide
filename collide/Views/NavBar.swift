import SwiftUI

struct NavBar: View {
    @State private var selectedTab = 2 // Index or tag for Home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Messages()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
                .tag(0)
            
            Events()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
                .tag(1)
            
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(2)
            
            UserCardDetail(user: UserModel.mock)
                .tabItem {
                    Label("Details", systemImage: "heart")
                }
                .tag(3)
            
            ProfileView(user: UserModel.mock)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .tint(.indigo)
    }
}

#Preview {
    NavBar()
}
