import Foundation

class KeychainManager {
  static let tokenKey = "communityapp.auth.token"

  static func saveToken(_ token: String) {
    let data = token.data(using: .utf8)
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: tokenKey,
      kSecValueData as String: data as Any,
    ]

    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
  }

  static func getToken() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: tokenKey,
      kSecReturnData as String: true,
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess, let data = result as? Data else {
      return nil
    }

    return String(data: data, encoding: .utf8)
  }

  static func deleteToken() {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: tokenKey,
    ]

    SecItemDelete(query as CFDictionary)
  }
}
