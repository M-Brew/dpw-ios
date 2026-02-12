//
//  WalletManager.swift
//  Quiver
//
//  Created by Michael on 05/02/2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
class WalletManager {
    var wallet: WalletModel? {
        didSet { saveToDisk() }
    }
    
    var isLoading = false
    var errorMessage: String?

    init() {
        self.wallet = loadFromDisk()
    }

    @MainActor
    func fetchWallet() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let walletService = WalletService()
            let data: WalletModel = try await walletService.getMyWallet()
            
            self.wallet = data
        } catch {
            self.errorMessage = "Failed to load wallet"
        }
    }

    private let storageKey = "app_wallet_data"

    private func saveToDisk() {
        if let wallet = wallet, let encoded = try? JSONEncoder().encode(wallet) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadFromDisk() -> WalletModel? {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode(WalletModel.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    func clearData() {
        wallet = nil
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
