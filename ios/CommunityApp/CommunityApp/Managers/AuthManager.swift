import Foundation

@MainActor
class AuthManager: ObservableObject {
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
          city: userData["city"] as? String ?? "",
          verificationStatus: .pending
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
          city: userData["city"] as? String ?? "",
          verificationStatus: VerificationStatus(rawValue: userData["verification_status"] as? String ?? "pending") ?? .pending
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
            city: userData["city"] as? String ?? "",
            verificationStatus: VerificationStatus(rawValue: userData["verification_status"] as? String ?? "pending") ?? .pending
          )
          currentUser = user
          isLoggedIn = true
        }
      } catch {
        logout()
      }
    }
  }
}
