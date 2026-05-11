import SwiftUI

struct MainTabView: View {
  @EnvironmentObject var authManager: AuthManager

  var body: some View {
    TabView {
      ExploreView()
        .tabItem {
          Label("Explore", systemImage: "map")
        }

      MyGroupsView()
        .tabItem {
          Label("My Groups", systemImage: "person.3")
        }

      ProfileView()
        .tabItem {
          Label("Profile", systemImage: "person.crop.circle")
        }
    }
    .tint(Color.earth)
  }
}

#Preview {
  MainTabView()
    .environmentObject(AuthManager())
}
