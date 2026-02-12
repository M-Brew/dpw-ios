//
//  WalletViewModel.swift
//  Quiver
//
//  Created by Michael on 06/01/2026.
//

import Foundation

class WalletViewModel {
    let walletService = WalletService()
    
    func getUserWallet() async throws -> WalletModel {
        let data: WalletModel = try await walletService.getMyWallet()
        
        return data
    }
    
    func searchContact(searchText: String) async throws -> [ContactModel] {
        let data: [ContactModel] = try await walletService.searchContact(searchText: searchText)
        
        return data
    }
    
    func addContact(walletId: String, contactCode: String) async throws -> WalletModel {
        let addContactPayload: AddContactPayload = AddContactPayload(walletId: walletId, contactCode: contactCode)
        let data: WalletModel = try await walletService.addContact(payload: addContactPayload)
        
        return data
    }
    
    func removeContact(walletId: String, contactCode: String) async throws -> WalletModel {
        let addContactPayload: AddContactPayload = AddContactPayload(walletId: walletId, contactCode: contactCode)
        let data: WalletModel = try await walletService.removeContact(payload: addContactPayload)
        
        return data
    }
}
