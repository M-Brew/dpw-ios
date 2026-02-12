//
//  TransactionSuccessfulView.swift
//  Quiver
//
//  Created by Michael on 03/02/2026.
//

import SwiftUI

struct TransactionSuccessfulView: View {
    @Environment(NavigationManager.self) private var navManager
    
    let transaction: TransactionModel

    var body: some View {
        VStack {
            Text("Transaction Successful")
                .font(.title2)
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(Font.system(size: 128))
                .padding(.bottom)
            Text(
                transaction.amount,
                format: .currency(
                    code: Locale.current.currency?.identifier
                        ?? "USD"
                )
            )
            .font(.largeTitle)
            Text("Sent To")
                .font(.subheadline)
                .fontWeight(.light)
                .padding(.vertical)
            Text(transaction.receiverWalletUserName)
                .font(.title3)
            Text(transaction.receiverWalletCode)
                .font(.subheadline)
                .fontWeight(.ultraLight)
            Spacer()
            Button {
                navManager.popToRoot()
            } label: {
                Text("Close")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled(true)
    }
}

#Preview {
    TransactionSuccessfulView(
        transaction: TransactionModel(
            id: "696513de7a3fce3ade687b61",
            senderUserId: "6964cd455cbca9dddea2a694",
            senderWalletId: "6964ce6c7114840935ecffdb",
            senderWalletCode: "GFZGbYJVN0Xn",
            senderWalletUserName: "Michael Brew",
            senderWalletUserImage: "",
            senderWalletStatus: "active",
            receiverUserId: "6964d04b5cbca9dddea2a6a1",
            receiverWalletId: "6964d1e67114840935ecffec",
            receiverWalletCode: "QEKHspQzUxUD",
            receiverWalletUserName: "Elvis Thompson",
            receiverWalletUserImage: "",
            receiverWalletStatus: "active",
            amount: 20,
            currency: "GHS",
            type: "P2P",
            status: "SUCCESS",
            description: "For the beer!",
            createdAt: "2026-01-12T15:31:42.201Z",
            updatedAt: "2026-01-12T15:31:42.225Z"
        )
    )
    .environment(NavigationManager())
}
