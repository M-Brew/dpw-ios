//
//  NetworkService.swift
//  Quiver
//
//  Created by Michael on 17/12/2025.
//

import Foundation
import SwiftUI

protocol RequestInterceptor {
    func adapt(_ request: URLRequest) throws -> URLRequest
}

class AuthRequestInterceptor: RequestInterceptor {
    let keychainManager = KeychainManager()

    func adapt(_ request: URLRequest) throws -> URLRequest {
        var adaptedRequest = request
        if let token = keychainManager.retrieveJWT(
            service: "com.Quiver.aTService"
        ) {
            adaptedRequest.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }
        return adaptedRequest
    }
}

protocol ResponseInterceptor {
    func intercept(_ data: Data, _ response: URLResponse) throws
}

class AuthResponseInterceptor: ResponseInterceptor {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    func intercept(_ data: Data, _ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkInterceptorError.invalidResponse
        }
        print(httpResponse.statusCode)

        let requestURLString = httpResponse.url?.absoluteString

        if (httpResponse.statusCode == 401 || httpResponse.statusCode == 403)
            && requestURLString == "\(AppConfig.baseURL)/api/auth/token"
        {
            isLoggedIn = false
            throw NetworkInterceptorError.missingOrInvalidToken(
                statusCode: httpResponse.statusCode
            )
        }

        if httpResponse.statusCode == 403 {
            throw NetworkInterceptorError.expiredToken
        }

        guard (200...299).contains(httpResponse.statusCode) || httpResponse.statusCode == 400 else {
            throw NetworkInterceptorError.unknownError
        }
    }
}

class NetworkService {
    let session: URLSession
    let requestInterceptors: [RequestInterceptor]
    let responseInterceptors: [ResponseInterceptor]

    let keychainManager = KeychainManager()
    let authService = AuthService()

    init(
        requestInterceptors: [RequestInterceptor],
        responseInterceptors: [ResponseInterceptor]
    ) {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
    }

    func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await _perform(request)
        } catch NetworkInterceptorError.expiredToken {
            do {
                guard
                    let refreshToken = keychainManager.retrieveJWT(
                        service: "com.Quiver.rTService"
                    )
                else {
                    throw NetworkInterceptorError.tokenNotFound
                }

                let data = try await authService.updateToken(
                    payload: UpdateTokenPayload(token: refreshToken)
                )

                let accessTokenStatus = keychainManager.saveJWT(
                    jwt: data.accessToken,
                    service: "com.Quiver.aTService"
                )
                if accessTokenStatus == errSecSuccess {
                    print("Access token saved successfully.")
                } else {
                    print("Error saving access token: \(accessTokenStatus)")
                }

                return try await _perform(request)

            } catch {
                throw NetworkInterceptorError.expiredToken
            }
        }
    }

    private func _perform(_ request: URLRequest) async throws -> (
        Data, URLResponse
    ) {
        var adaptedRequest = request
        for interceptor in self.requestInterceptors {
            adaptedRequest = try interceptor.adapt(adaptedRequest)
        }
        print("Request: \(adaptedRequest)")

        let (data, response) = try await session.data(for: adaptedRequest)

        for interceptor in self.responseInterceptors {
            try interceptor.intercept(data, response)
        }
        
        print("status: \((response as! HTTPURLResponse).statusCode)")
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        if let dict = json as? [String: Any] {
            print("data: \(dict)")
        } else if let array = json as? [[String: Any]] {
            print("data: \(array)")
        }
        
        return (data, response)
    }
}

enum NetworkInterceptorError: Error {
    case invalidResponse
    case missingOrInvalidToken(statusCode: Int)
    case expiredToken
    case tokenNotFound
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .missingOrInvalidToken(let statusCode):
            switch statusCode {
            case 401:
                return "Missing token"
            case 403:
                return "Invalid token"
            default:
                return "An error occurred. Please try again later"
            }
        case .expiredToken:
            return "Expired token"
        case .tokenNotFound:
            return "Token not found"
        case .unknownError:
            return "An error occurred. Please try again later"
        }
    }
}
