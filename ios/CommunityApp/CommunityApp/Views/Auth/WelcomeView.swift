import SwiftUI
import AuthenticationServices

struct WelcomeView: View {
  @EnvironmentObject var authManager: AuthManager
  @State private var showLogin = false
  @State private var showAppleSignIn = false

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

        Button(action: {
          authManager.signInWithApple()
        }) {
          HStack(spacing: 8) {
            Image(systemName: "apple.logo")
            Text("Sign in with Apple")
          }
          .font(.system(size: 16, weight: .semibold))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
          .background(Color.gray900)
          .foregroundColor(.white)
          .cornerRadius(12)
        }

        Button(action: {
          authManager.signInWithGoogle()
        }) {
          HStack(spacing: 8) {
            Image(systemName: "g.circle.fill")
            Text("Sign in with Google")
          }
          .font(.system(size: 16, weight: .semibold))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
          .background(Color.white)
          .foregroundColor(.gray900)
          .cornerRadius(12)
          .border(Color.gray200, width: 1)
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
    .signInWithAppleButtonStyle(.white)
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AppleSignInSuccess"))) { _ in
      // Apple sign-in successful, AuthManager handles navigation
    }
  }
}

#Preview {
  NavigationStack {
    WelcomeView()
      .environmentObject(AuthManager())
  }
}
