//
//  AuthService.swift
//  Quiver
//
//  Created by Michael Brew on 14/08/2025.
//

import Foundation

struct SignUpPayload: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let password: String
}

struct SignInPayload: Codable {
    let email: String
    let password: String
}

struct SignOutPayload: Codable {
    let token: String
}

struct AuthData: Codable {
    let accessToken: String
    let refreshToken: String
}

enum AuthError: Error {
    case invalidPayload
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidPayload:
            return "Invalid payload"
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let statusCode):
            switch statusCode {
            case 400:
                return "Invalid credentials"
            case 401:
                return "Unauthorized"
            case 404:
                return "Not found"
            default:
                return "Request failed with status code: \(statusCode)"
            }
        case .decodingFailed(let error):
            return "Data decoding failed: \(error)"
        case .unknownError:
            return "An error occurred. Please try again later"
        }
    }
}

class AuthService {
    let baseURL = "http://localhost:8080/api/auth"
    
    func signUp(payload: SignUpPayload) async throws -> AuthData {
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw AuthError.invalidPayload
        }
        
        guard let url = URL(string: "\(self.baseURL)/sign-up") else {
            throw AuthError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: encodedPayload)
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }
            
            switch response.statusCode {
            case 201:
                let decodedData = try JSONDecoder().decode(AuthData.self, from: data)
                return decodedData
            case 400:
                throw AuthError.requestFailed(statusCode: 400)
            case 401:
                throw AuthError.requestFailed(statusCode: 401)
            case 500:
                throw AuthError.requestFailed(statusCode: 500)
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw AuthError.decodingFailed(decodingError)
        }
    }
    
    func signIn(payload: SignInPayload) async throws -> AuthData {
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw AuthError.invalidPayload
        }
        
        guard let url = URL(string: "\(self.baseURL)/sign-in") else {
            throw AuthError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: encodedPayload)
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }
            
            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(AuthData.self, from: data)
                return decodedData
            case 400:
                throw AuthError.requestFailed(statusCode: 400)
            case 401:
                throw AuthError.requestFailed(statusCode: 401)
            case 404:
                throw AuthError.requestFailed(statusCode: 404)
            case 500:
                throw AuthError.requestFailed(statusCode: 500)
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw AuthError.decodingFailed(decodingError)
//        } catch {
//            print("here")
//            throw AuthError.unknownError
        }
    }
    
    func signOut(payload: SignOutPayload) async throws -> Bool {
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw AuthError.invalidPayload
        }
        
        guard let url = URL(string: "\(self.baseURL)/sign-out") else {
            throw AuthError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.upload(for: request, from: encodedPayload)
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }
            
            switch response.statusCode {
            case 204:
                return true
            case 400:
                throw AuthError.requestFailed(statusCode: 400)
            case 404:
                throw AuthError.requestFailed(statusCode: 404)
            case 500:
                throw AuthError.requestFailed(statusCode: 500)
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch {
            throw AuthError.unknownError
        }
    }
}
