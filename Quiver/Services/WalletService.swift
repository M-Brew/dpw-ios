//
//  WalletService.swift
//  Quiver
//
//  Created by Michael Brew on 20/08/2025.
//

import Foundation

struct WalletData: Codable {
    let _id: String
    let user: String
    let currency: String
    let balance: Double
    let createdAt: String
}

struct WalletErrorData: Codable {
    let error: String
}

enum WalletError: Error {
    case invalidURL
    case requestFailed(statusCode: Int, errorMessage: String? = "")
    case decodingFailed(Error)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let statusCode, let errorMessage):
            switch statusCode {
            case 400...499:
                return errorMessage ?? "Invalid credentials"
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

class WalletService {
    let keychainManager = KeychainManager()
    let baseURL = "http://localhost:8080/api/wallet"

    func createWallet() async throws -> WalletData {
        let url = URL(string: "\(baseURL)/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(keychainManager.retrieveJWT(service: "com.Quiver.aTService") ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw WalletError.unknownError
            }

            switch response.statusCode {
            case 201:
                let decodedData = try JSONDecoder().decode(
                    WalletData.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    AuthErrorData.self,
                    from: data
                )
                throw WalletError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
            default:
                throw WalletError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw WalletError.decodingFailed(decodingError)
        }
    }
    
    func getWallet() async throws -> WalletData {
        let url = URL(string: "\(baseURL)/\(UserDefaults.standard.string(forKey: "userId") ?? "")")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(keychainManager.retrieveJWT(service: "com.Quiver.aTService") ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw WalletError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    WalletData.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    AuthErrorData.self,
                    from: data
                )
                throw WalletError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
            default:
                throw WalletError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw WalletError.decodingFailed(decodingError)
        }
    }
}
