import SwiftUI

struct WelcomeView: View {
  @EnvironmentObject var authManager: AuthManager
  @State private var showLogin = false

  var body: some View {
    VStack(spacing: 40) {
      Spacer()

      VStack(spacing: 16) {
        Text("Close the app.")
          .font(.system(size: 32, weight: .bold, design: .default))
          .foregroundColor(.gray900)

        Text("Open your world.")
          .font(.system(size: 32, weight: .bold, design: .default))
          .foregroundColor(.primary)
      }

      VStack(spacing: 12) {
        Text("A countercultural app that brings people back to genuine human connection. No feeds, no likes, no engagement tricks—just real people meeting in real places.")
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(.gray700)
          .lineLimit(nil)
      }
      .padding(.horizontal)

      Spacer()

      VStack(spacing: 12) {
        NavigationLink(destination: RegisterView()) {
          Text("Join the movement")
            .font(.system(size: 16, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.earth)
            .foregroundColor(.white)
            .cornerRadius(12)
        }

        Button(action: { showLogin = true }) {
          Text("I already have an account")
            .font(.system(size: 16, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .foregroundColor(.earth)
            .cornerRadius(12)
            .border(Color.earth, width: 1)
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 40)
    }
    .navigationDestination(isPresented: $showLogin) {
      LoginView()
    }
  }
}

#Preview {
  NavigationStack {
    WelcomeView()
      .environmentObject(AuthManager())
  }
}
