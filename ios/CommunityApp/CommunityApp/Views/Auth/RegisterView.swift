import SwiftUI

struct RegisterView: View {
  @EnvironmentObject var authManager: AuthManager
  @State private var step = 1
  @State private var firstName = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  @State private var city = ""
  @State private var errorMessage = ""

  var body: some View {
    ZStack {
      if step == 1 {
        RegisterStep1View(
          firstName: $firstName,
          step: $step,
          errorMessage: $errorMessage
        )
      } else if step == 2 {
        RegisterStep2View(
          email: $email,
          password: $password,
          confirmPassword: $confirmPassword,
          step: $step,
          errorMessage: $errorMessage
        )
      } else if step == 3 {
        RegisterStep3View(
          city: $city,
          step: $step,
          errorMessage: $errorMessage
        )
      } else if step == 4 {
        RegisterStep4View(
          firstName: firstName,
          email: email,
          password: password,
          city: city
        )
      }
    }
    .navigationBarBackButtonHidden(step > 1)
  }
}

struct RegisterStep1View: View {
  @Binding var firstName: String
  @Binding var step: Int
  @Binding var errorMessage: String

  var body: some View {
    VStack(spacing: 40) {
      VStack(alignment: .leading, spacing: 8) {
        Text("What's your first name?")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.gray900)

        Text("We only ask for first names. Real people, no profiles.")
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.gray600)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      TextField("First name", text: $firstName)
        .font(.system(size: 16, weight: .regular))
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.gray100)
        .cornerRadius(8)

      Spacer()

      Button(action: {
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
          errorMessage = "Please enter your first name"
        } else {
          step = 2
        }
      }) {
        Text("Next")
          .font(.system(size: 16, weight: .semibold))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
          .background(Color.earth)
          .foregroundColor(.white)
          .cornerRadius(12)
      }

      if !errorMessage.isEmpty {
        Text(errorMessage)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.red)
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 40)
  }
}

struct RegisterStep2View: View {
  @Binding var email: String
  @Binding var password: String
  @Binding var confirmPassword: String
  @Binding var step: Int
  @Binding var errorMessage: String

  var body: some View {
    VStack(spacing: 40) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Create your account")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.gray900)

        Text("Email and password to stay secure")
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

        SecureField("Password (8+ characters)", text: $password)
          .font(.system(size: 16, weight: .regular))
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)

        SecureField("Confirm password", text: $confirmPassword)
          .font(.system(size: 16, weight: .regular))
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)
      }

      Spacer()

      VStack(spacing: 12) {
        Button(action: {
          if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in all fields"
          } else if password != confirmPassword {
            errorMessage = "Passwords don't match"
          } else if password.count < 8 {
            errorMessage = "Password must be at least 8 characters"
          } else {
            step = 3
          }
        }) {
          Text("Next")
            .font(.system(size: 16, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.earth)
            .foregroundColor(.white)
            .cornerRadius(12)
        }

        if !errorMessage.isEmpty {
          Text(errorMessage)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.red)
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 40)
  }
}

struct RegisterStep3View: View {
  @Binding var city: String
  @Binding var step: Int
  @Binding var errorMessage: String

  var body: some View {
    VStack(spacing: 40) {
      VStack(alignment: .leading, spacing: 8) {
        Text("What city are you in?")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.gray900)

        Text("We use this to find groups near you"
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.gray600)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      TextField("City name", text: $city)
        .font(.system(size: 16, weight: .regular))
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.gray100)
        .cornerRadius(8)

      Spacer()

      Button(action: {
        if city.trimmingCharacters(in: .whitespaces).isEmpty {
          errorMessage = "Please enter your city"
        } else {
          step = 4
        }
      }) {
        Text("Next")
          .font(.system(size: 16, weight: .semibold))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
          .background(Color.earth)
          .foregroundColor(.white)
          .cornerRadius(12)
      }

      if !errorMessage.isEmpty {
        Text(errorMessage)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.red)
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 40)
  }
}

struct RegisterStep4View: View {
  @EnvironmentObject var authManager: AuthManager
  let firstName: String
  let email: String
  let password: String
  let city: String

  var body: some View {
    VStack(spacing: 20) {
      Text("Creating your account...")
        .font(.system(size: 24, weight: .semibold))
        .foregroundColor(.gray900)

      ProgressView()
        .tint(Color.earth)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
    .onAppear {
      Task {
        await authManager.register(
          firstName: firstName,
          email: email,
          password: password,
          city: city
        )
      }
    }
  }
}

#Preview {
  NavigationStack {
    RegisterView()
      .environmentObject(AuthManager())
  }
}
