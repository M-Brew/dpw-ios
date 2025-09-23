//
//  APIService.swift
//  Quiver
//
//  Created by Michael Brew on 26/08/2025.
//

import Foundation
import JWTDecode

protocol RequestInterceptor {
    func intercept(_ request: URLRequest) async throws -> URLRequest
}

struct AuthInterceptor: RequestInterceptor {
    
    func intercept(_ request: URLRequest) async throws -> URLRequest {
        var authRequest = request
        
        let keychainManager = KeychainManager()
        let accessToken: String? = keychainManager.retrieveJWT(service: "com.Quiver.aTService")
//        let refreshToken: String = keychainManager.retrieveJWT(service: "com.Quiver.rTService") ?? ""
        
        if accessToken != nil {
            let tokenPayload = try decode(jwt: accessToken!)
//            let userId = tokenPayload["id"].string ?? ""
            
            // Add authorization header
            authRequest.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
            return authRequest
        }
        return authRequest
    }
}

class NetworkClient {
    let session: URLSession
    let requestInterceptors: [RequestInterceptor]

    init(session: URLSession = .shared, requestInterceptors: [RequestInterceptor] = []) {
        self.session = session
        self.requestInterceptors = requestInterceptors
    }

    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        var interceptedRequest = request
        for interceptor in requestInterceptors {
            interceptedRequest = try await interceptor.intercept(interceptedRequest)
        }
        return try await session.data(for: interceptedRequest)
    }
}

