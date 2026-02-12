//
//  AuthService.swift
//  Quiver
//
//  Created by Michael Brew on 14/08/2025.
//

import Foundation

class AuthService {
    let keychainManager = KeychainManager()
    let baseURL = "\(AppConfig.baseURL)/api/auth"

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
            let (data, response) = try await URLSession.shared.upload(
                for: request,
                from: encodedPayload
            )
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }

            switch response.statusCode {
            case 201:
                let decodedData = try JSONDecoder().decode(
                    AuthData.self,
                    from: data
                )
                return decodedData
            case 400...409 | 500:
                let errorMessage = try JSONDecoder().decode(
                    AuthErrorData.self,
                    from: data
                )
                throw AuthError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
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
            let (data, response) = try await URLSession.shared.upload(
                for: request,
                from: encodedPayload
            )
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    AuthData.self,
                    from: data
                )
                return decodedData
            case 400...409 | 500:
                let errorMessage = try JSONDecoder().decode(
                    AuthErrorData.self,
                    from: data
                )
                throw AuthError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw AuthError.decodingFailed(decodingError)
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
            let (_, response) = try await URLSession.shared.upload(
                for: request,
                from: encodedPayload
            )
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }

            switch response.statusCode {
            case 204:
                return true
            case 400...409 | 500:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch {
            throw AuthError.unknownError
        }
    }

    func emailVerificationRequest() async throws -> Bool {
        let networkService: NetworkService = {
            let requestInterceptor = AuthRequestInterceptor()
            let responseInterceptor = AuthResponseInterceptor()
            let networkService = NetworkService(
                requestInterceptors: [requestInterceptor],
                responseInterceptors: [responseInterceptor]
            )
            return networkService
        }()
        
        guard
            let url = URL(string: "\(self.baseURL)/email-verification-request")
        else {
            throw AuthError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(keychainManager.retrieveJWT(service: "com.Quiver.aTService") ?? "")",
            forHTTPHeaderField: "Authorization"
        )

        do {
            let (_, response) = try await networkService.perform(request)
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }

            switch response.statusCode {
            case 200:
                return true
            case 400...409 | 500:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch {
            throw AuthError.unknownError
        }
    }

    func verifyEmail(payload: VerifyEmailPayload) async throws -> Bool {
        let networkService: NetworkService = {
            let requestInterceptor = AuthRequestInterceptor()
            let responseInterceptor = AuthResponseInterceptor()
            let networkService = NetworkService(
                requestInterceptors: [requestInterceptor],
                responseInterceptors: [responseInterceptor]
            )
            return networkService
        }()
        
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw AuthError.invalidPayload
        }

        guard let url = URL(string: "\(self.baseURL)/verify-email") else {
            throw AuthError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = encodedPayload
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(keychainManager.retrieveJWT(service: "com.Quiver.aTService") ?? "")",
            forHTTPHeaderField: "Authorization"
        )

        do {
            let (_, response) = try await networkService.perform(request)
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }

            switch response.statusCode {
            case 200:
                return true
            case 400...409 | 500:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch {
            throw AuthError.unknownError
        }
    }
    
    func updateToken(payload: UpdateTokenPayload) async throws
        -> UpdateTokenData
    {
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw AuthError.invalidPayload
        }

        guard let url = URL(string: "\(self.baseURL)/token") else {
            throw AuthError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.upload(
                for: request,
                from: encodedPayload
            )
            guard let response = response as? HTTPURLResponse else {
                throw AuthError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    UpdateTokenData.self,
                    from: data
                )
                return decodedData
            case 400...409 | 500:
                let errorMessage = try JSONDecoder().decode(
                    AuthErrorData.self,
                    from: data
                )
                throw AuthError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
            default:
                throw AuthError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw AuthError.decodingFailed(decodingError)
        }
    }
}

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

struct VerifyEmailPayload: Codable {
    let code: String
}

struct UpdateTokenPayload: Codable {
    let token: String
}

struct AuthData: Codable {
    let accessToken: String
    let refreshToken: String
}

struct AuthErrorData: Codable {
    let error: String
}

struct UpdateTokenData: Codable {
    let accessToken: String
}

enum AuthError: Error {
    case invalidPayload
    case invalidURL
    case requestFailed(statusCode: Int, errorMessage: String? = "")
    case decodingFailed(Error)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidPayload:
            return "Invalid payload"
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let statusCode, let errorMessage):
            switch statusCode {
            case 400:
                return errorMessage ?? "Invalid credentials"
            case 401:
                return errorMessage ?? "Unauthorized"
            case 404:
                return errorMessage ?? "Not found"
            default:
                return "An error occurred. Please try again later"
            }
        case .decodingFailed(let error):
            return "Data decoding failed: \(error)"
        case .unknownError:
            return "An error occurred. Please try again later"
        }
    }
}
