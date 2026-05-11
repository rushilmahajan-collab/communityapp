import SwiftUI

struct LoginView: View {
  @EnvironmentObject var authManager: AuthManager
  @State private var email = ""
  @State private var password = ""

  var body: some View {
    VStack(spacing: 40) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Welcome back")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.gray900)

        Text("Sign in to your account")
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.gray600)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: 12) {
        TextField("Email", text: $email)
          .font(.system(size: 16, weight: .regular))
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)

        SecureField("Password", text: $password)
          .font(.system(size: 16, weight: .regular))
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)
      }

      Spacer()

      VStack(spacing: 12) {
        Button(action: {
          Task {
            await authManager.login(email: email, password: password)
          }
        }) {
          if authManager.isLoading {
            ProgressView()
              .tint(.white)
          } else {
            Text("Sign In")
              .font(.system(size: 16, weight: .semibold))
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.earth)
        .foregroundColor(.white)
        .cornerRadius(12)
        .disabled(authManager.isLoading)

        if let errorMessage = authManager.errorMessage {
          Text(errorMessage)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.red)
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 40)
    .navigationTitle("Sign In")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    LoginView()
      .environmentObject(AuthManager())
  }
}
