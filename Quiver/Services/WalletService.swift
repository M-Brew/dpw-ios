//
//  WalletService.swift
//  Quiver
//
//  Created by Michael Brew on 20/08/2025.
//

import Foundation

struct WalletErrorData: Codable {
    let error: String
}

struct AddContactPayload: Codable {
    let walletId: String
    let contactCode: String
}

enum WalletError: Error {
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

class WalletService {
    let keychainManager = KeychainManager()
    let baseURL = "\(AppConfig.baseURL)/api/wallets"

    func createWallet() async throws -> WalletModel {
        let url = URL(string: "\(baseURL)/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                throw WalletError.unknownError
            }

            switch response.statusCode {
            case 201:
                let decodedData = try JSONDecoder().decode(
                    WalletModel.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    WalletErrorData.self,
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
    
    func getMyWallet() async throws -> WalletModel {
        let url = URL(string: "\(baseURL)/my-wallet")!
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
                throw WalletError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    WalletModel.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    WalletErrorData.self,
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
    
    func searchContact(searchText: String) async throws -> [ContactModel] {
        let url = URL(string: "\(baseURL)/wallet/\(searchText)")!
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
                throw WalletError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    [ContactModel].self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    WalletErrorData.self,
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
    
    func addContact(payload: AddContactPayload) async throws -> WalletModel {
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw WalletError.invalidPayload
        }
        
        let url = URL(string: "\(baseURL)/add-contact")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
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
                throw WalletError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    WalletModel.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    WalletErrorData.self,
                    from: data
                )
                print("errorMessage: \(errorMessage)")
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
    
    func removeContact(payload: AddContactPayload) async throws -> WalletModel {
        guard let encodedPayload = try? JSONEncoder().encode(payload) else {
            throw WalletError.invalidPayload
        }
        
        let url = URL(string: "\(baseURL)/remove-contact")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
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
                throw WalletError.unknownError
            }

            switch response.statusCode {
            case 200:
                let decodedData = try JSONDecoder().decode(
                    WalletModel.self,
                    from: data
                )
                return decodedData
            case 400...499:
                let errorMessage = try JSONDecoder().decode(
                    WalletErrorData.self,
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
