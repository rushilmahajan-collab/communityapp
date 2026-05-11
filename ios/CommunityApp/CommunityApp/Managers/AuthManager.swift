import Foundation
import AuthenticationServices

@MainActor
class AuthManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
  @Published var isLoggedIn = false
  @Published var currentUser: User?
  @Published var isLoading = false
  @Published var errorMessage: String?

  let apiClient = APIClient()

  func register(firstName: String, email: String, password: String, city: String) async {
    isLoading = true
    errorMessage = nil

    do {
      let response = try await apiClient.post(
        endpoint: "/api/auth/register",
        body: [
          "first_name": firstName,
          "email": email,
          "password": password,
          "city": city,
        ]
      ) as? [String: Any]

      if let userData = response?["user"] as? [String: Any],
        let token = response?["token"] as? String {
        let user = User(
          id: userData["id"] as? String ?? "",
          firstName: userData["first_name"] as? String ?? "",
          email: userData["email"] as? String ?? "",
          city: userData["city"] as? String ?? ""
        )
        currentUser = user
        KeychainManager.saveToken(token)
        isLoggedIn = true
      }
    } catch {
      errorMessage = "Registration failed: \(error.localizedDescription)"
    }

    isLoading = false
  }

  func login(email: String, password: String) async {
    isLoading = true
    errorMessage = nil

    do {
      let response = try await apiClient.post(
        endpoint: "/api/auth/login",
        body: ["email": email, "password": password]
      ) as? [String: Any]

      if let userData = response?["user"] as? [String: Any],
        let token = response?["token"] as? String {
        let user = User(
          id: userData["id"] as? String ?? "",
          firstName: userData["first_name"] as? String ?? "",
          email: userData["email"] as? String ?? "",
          city: userData["city"] as? String ?? ""
        )
        currentUser = user
        KeychainManager.saveToken(token)
        isLoggedIn = true
      }
    } catch {
      errorMessage = "Login failed: \(error.localizedDescription)"
    }

    isLoading = false
  }

  func logout() {
    KeychainManager.deleteToken()
    currentUser = nil
    isLoggedIn = false
  }

  func checkAuthStatus() async {
    if KeychainManager.getToken() != nil {
      do {
        if let userData = try await apiClient.get(endpoint: "/api/auth/me") as? [String: Any] {
          let user = User(
            id: userData["id"] as? String ?? "",
            firstName: userData["first_name"] as? String ?? "",
            email: userData["email"] as? String ?? "",
            city: userData["city"] as? String ?? ""
          )
          currentUser = user
          isLoggedIn = true
        }
      } catch {
        logout()
      }
    }
  }

  func signInWithApple() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]

    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.performRequests()
  }

  func signInWithGoogle() {
    // Create a demo user for Google Sign In
    // In production, this would use Google's OAuth SDK
    Task {
      await signInWithOAuth(
        provider: "google",
        providerID: "demo-google-\(UUID().uuidString)",
        email: "user@gmail.com",
        firstName: "Google User",
        idToken: nil
      )
    }
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      let userID = appleIDCredential.user
      let email = appleIDCredential.email ?? ""
      let firstName = appleIDCredential.fullName?.givenName ?? "User"

      Task {
        await signInWithOAuth(
          provider: "apple",
          providerID: userID,
          email: email,
          firstName: firstName,
          idToken: appleIDCredential.identityToken
        )
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    errorMessage = "Apple Sign In failed: \(error.localizedDescription)"
  }

  func saveQuizResponses(_ responses: [Int: String]) async {
    do {
      _ = try await apiClient.post(
        endpoint: "/api/users/quiz",
        body: ["responses": responses]
      )
    } catch {
      errorMessage = "Failed to save quiz responses"
    }
  }

  private func signInWithOAuth(
    provider: String,
    providerID: String,
    email: String,
    firstName: String,
    idToken: Data?
  ) async {
    isLoading = true
    errorMessage = nil

    do {
      var body: [String: Any] = [
        "provider": provider,
        "provider_id": providerID,
        "email": email,
        "first_name": firstName,
      ]

      if let token = idToken {
        body["id_token"] = token.base64EncodedString()
      }

      let response = try await apiClient.post(
        endpoint: "/api/auth/oauth",
        body: body
      ) as? [String: Any]

      if let userData = response?["user"] as? [String: Any],
        let token = response?["token"] as? String {
        let user = User(
          id: userData["id"] as? String ?? "",
          firstName: userData["first_name"] as? String ?? "",
          email: userData["email"] as? String ?? "",
          city: userData["city"] as? String ?? ""
        )
        currentUser = user
        KeychainManager.saveToken(token)
        isLoggedIn = true
      }
    } catch {
      errorMessage = "OAuth sign-in failed: \(error.localizedDescription)"
    }

    isLoading = false
  }
}
