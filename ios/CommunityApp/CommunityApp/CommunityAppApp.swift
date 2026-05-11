import SwiftUI

@main
struct CommunityAppApp: App {
  @StateObject private var authManager = AuthManager()

  var body: some Scene {
    WindowGroup {
      if authManager.isLoggedIn {
        MainTabView()
          .environmentObject(authManager)
      } else {
        WelcomeView()
          .environmentObject(authManager)
      }
    }
  }
}
