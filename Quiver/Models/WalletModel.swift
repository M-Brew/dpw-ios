//
//  WalletModel.swift
//  Quiver
//
//  Created by Michael on 16/12/2025.
//

import Foundation

struct ContactModel: Identifiable, Codable {
    let id: String
    let walletId: String
    let code: String
    let userName: String
    let userImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", walletId, code, userName, userImage
    }
}

struct WalletModel: Identifiable, Codable {
    let id: String
    let userId: String
    let userName: String
    let userImage: String?
    let code: String
    let balance: Double
    let currency: String
    let status: String
    let contacts: [ContactModel]
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", userId, userName, userImage, code, balance, currency, status, contacts, createdAt, updatedAt
    }
}
