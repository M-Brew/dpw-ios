//
//  TransactionViewModel.swift
//  Quiver
//
//  Created by Michael on 15/01/2026.
//

import Foundation

class TransactionViewModel {
    let transactionService = TransactionsService()
    
    func getMyTransactions() async throws -> [TransactionModel] {
        let data: [TransactionModel] = try await transactionService.getMyTransactions()
        
        return data
    }
    
    func getTransaction(transactionId: String) async throws -> TransactionModel {
        let data: TransactionModel = try await transactionService.getTransaction(transactionId: transactionId)
        
        return data
    }
    
    func makeP2PTransaction(payload: P2PTransactionPayload) async throws -> TransactionModel {
        let data: TransactionModel = try await transactionService.p2pTransaction(payload: payload)        
        return data
    }
}
