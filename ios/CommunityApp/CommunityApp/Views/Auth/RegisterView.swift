import SwiftUI

struct RegisterView: View {
  @EnvironmentObject var authManager: AuthManager
  @State private var firstName = ""
  @State private var email = ""
  @State private var password = ""
  @State private var city = ""
  @State private var showQuiz = false
  @State private var errorMessage = ""

  var body: some View {
    VStack(spacing: 24) {
      Button(action: { /* back */ }) {
        HStack {
          Image(systemName: "chevron.left")
          Text("Back")
        }
        .foregroundColor(.earth)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: 8) {
        Text("Create your account")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.gray900)
          .frame(maxWidth: .infinity, alignment: .leading)

        Text("Tell us a bit about yourself")
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.gray600)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      VStack(spacing: 16) {
        TextField("First name", text: $firstName)
          .font(.system(size: 16, weight: .regular))
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)

        TextField("Email", text: $email)
          .font(.system(size: 16, weight: .regular))
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)
          .keyboardType(.emailAddress)

        SecureField("Password", text: $password)
          .font(.system(size: 16, weight: .regular))
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)

        TextField("City", text: $city)
          .font(.system(size: 16, weight: .regular))
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color.gray100)
          .cornerRadius(8)
      }

      if !errorMessage.isEmpty {
        Text(errorMessage)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.red)
      }

      Spacer()

      Button(action: {
        if firstName.isEmpty || email.isEmpty || password.isEmpty || city.isEmpty {
          errorMessage = "Please fill in all fields"
        } else {
          showQuiz = true
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

      NavigationLink(destination: QuizView(firstName: firstName, email: email, password: password, city: city), isActive: $showQuiz) {
        EmptyView()
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 40)
  }
}

#Preview {
  NavigationStack {
    RegisterView()
      .environmentObject(AuthManager())
  }
}
