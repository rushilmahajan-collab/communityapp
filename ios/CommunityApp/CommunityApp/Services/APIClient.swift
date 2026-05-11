import Foundation

class APIClient {
  let baseURL = "http://localhost:3000"

  func get(endpoint: String) async throws -> Any {
    guard let url = URL(string: baseURL + endpoint) else {
      throw APIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if let token = KeychainManager.getToken() {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }

    guard 200...299 ~= httpResponse.statusCode else {
      throw APIError.httpError(httpResponse.statusCode)
    }

    return try JSONSerialization.jsonObject(with: data)
  }

  func post(endpoint: String, body: [String: Any]) async throws -> Any {
    guard let url = URL(string: baseURL + endpoint) else {
      throw APIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if let token = KeychainManager.getToken() {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }

    guard 200...299 ~= httpResponse.statusCode else {
      throw APIError.httpError(httpResponse.statusCode)
    }

    return try JSONSerialization.jsonObject(with: data)
  }

  func put(endpoint: String, body: [String: Any]) async throws -> Any {
    guard let url = URL(string: baseURL + endpoint) else {
      throw APIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if let token = KeychainManager.getToken() {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }

    guard 200...299 ~= httpResponse.statusCode else {
      throw APIError.httpError(httpResponse.statusCode)
    }

    return try JSONSerialization.jsonObject(with: data)
  }

  func delete(endpoint: String) async throws -> Any {
    guard let url = URL(string: baseURL + endpoint) else {
      throw APIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if let token = KeychainManager.getToken() {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }

    guard 200...299 ~= httpResponse.statusCode else {
      throw APIError.httpError(httpResponse.statusCode)
    }

    return try JSONSerialization.jsonObject(with: data)
  }
}

enum APIError: Error {
  case invalidURL
  case invalidResponse
  case httpError(Int)
  case decodingError(Error)
}
