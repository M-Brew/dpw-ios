//
//  TransactionsService.swift
//  Quiver
//
//  Created by Michael on 12/01/2026.
//

import Foundation

struct P2PTransactionPayload: Codable {
    let senderUserId: String
    let senderWalletId: String
    let receiverUserId: String
    let receiverWalletId: String
    let amount: Double
    let type: String
    let note: String
}

enum TransactionError: Error {
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

struct TransactionErrorData: Codable {
    let error: String
}

class TransactionsService {
    let keychainManager = KeychainManager()
    let baseURL = "\(AppConfig.baseURL)/api/transactions"
    
    func p2pTransaction(payload: P2PTransactionPayload) async throws -> TransactionModel {
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw TransactionError.invalidPayload
        }
        print("payload: \(String(data: encodedPayload, encoding: .utf8) ?? "<nil>")")
        
        let url = URL(string: "\(baseURL)/p2p-transfer")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(keychainManager.retrieveJWT(service: "com.Quiver.aTService") ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        request.httpBody = encodedPayload
        
        let networkService: NetworkService = {
            let requestInterceptor = AuthRequestInterceptor()
            let responseInterceptor = AuthResponseInterceptor()
            let networkService = NetworkService(
                requestInterceptors: [requestInterceptor],
                responseInterceptors: [responseInterceptor]
            )
            return networkService
        }()
        
        do {
            let (data, response) = try await networkService.perform(request)
            guard let response = response as? HTTPURLResponse else {
                throw TransactionError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    TransactionModel.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    TransactionErrorData.self,
                    from: data
                )
                print("errorMessage: \(errorMessage)")
                throw TransactionError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
            default:
                throw TransactionError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw TransactionError.decodingFailed(decodingError)
        }
    }
    
    func getTransaction(transactionId: String) async throws -> TransactionModel {
        let url = URL(string: "\(baseURL)/\(transactionId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(keychainManager.retrieveJWT(service: "com.Quiver.aTService") ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        let networkService: NetworkService = {
            let requestInterceptor = AuthRequestInterceptor()
            let responseInterceptor = AuthResponseInterceptor()
            let networkService = NetworkService(
                requestInterceptors: [requestInterceptor],
                responseInterceptors: [responseInterceptor]
            )
            return networkService
        }()
        
        do {
            let (data, response) = try await networkService.perform(request)
            guard let response = response as? HTTPURLResponse else {
                throw TransactionError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    TransactionModel.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    TransactionErrorData.self,
                    from: data
                )
                throw TransactionError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
            default:
                throw TransactionError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw TransactionError.decodingFailed(decodingError)
        }
    }
    
    func getMyTransactions() async throws -> [TransactionModel] {
        let url = URL(string: "\(baseURL)/my-transactions")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(keychainManager.retrieveJWT(service: "com.Quiver.aTService") ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        let networkService: NetworkService = {
            let requestInterceptor = AuthRequestInterceptor()
            let responseInterceptor = AuthResponseInterceptor()
            let networkService = NetworkService(
                requestInterceptors: [requestInterceptor],
                responseInterceptors: [responseInterceptor]
            )
            return networkService
        }()
        
        do {
            let (data, response) = try await networkService.perform(request)
            guard let response = response as? HTTPURLResponse else {
                throw TransactionError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    [TransactionModel].self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    TransactionErrorData.self,
                    from: data
                )
                throw TransactionError.requestFailed(
                    statusCode: response.statusCode,
                    errorMessage: errorMessage.error
                )
            default:
                throw TransactionError.requestFailed(statusCode: response.statusCode)
            }
        } catch let decodingError as DecodingError {
            throw TransactionError.decodingFailed(decodingError)
        }
    }
}
