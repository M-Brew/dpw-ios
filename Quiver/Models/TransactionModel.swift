//
//  TransactionModel.swift
//  Quiver
//
//  Created by Michael on 12/01/2026.
//

import Foundation

struct TransactionModel: Identifiable, Codable, Hashable {
    let id: String
    let senderUserId: String
    let senderWalletId: String
    let senderWalletCode: String
    let senderWalletUserName: String
    let senderWalletUserImage: String?
    let senderWalletStatus: String
    let receiverUserId: String
    let receiverWalletId: String
    let receiverWalletCode: String
    let receiverWalletUserName: String
    let receiverWalletUserImage: String?
    let receiverWalletStatus: String
    let amount: Double
    let currency: String
    let type: String
    let status: String
    let description: String?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id", senderUserId, senderWalletId, senderWalletCode,
            senderWalletUserName, senderWalletUserImage, senderWalletStatus,
             receiverUserId, receiverWalletId, receiverWalletCode,
            receiverWalletUserName, receiverWalletUserImage,
            receiverWalletStatus, amount, currency, type, status, description,
            createdAt, updatedAt
    }
}
