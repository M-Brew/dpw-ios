//
//  TransactionsView.swift
//  Quiver
//
//  Created by Michael Brew on 10/09/2025.
//

import SwiftUI

enum TransactionDestination: Hashable {
    case transaction(transactionId: String)
}

struct TransactionsView: View {
    @AppStorage("userId") private var userId = ""
    let transactionService = TransactionsService()

    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

    @State private var transactions: [TransactionModel] = [
        TransactionModel(
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
    ]

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Transactions")
                    .font(.title)
                Divider()
                    .padding(.bottom)
                if loading {
                    Spacer()
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    if transactions.isEmpty {
                        Spacer()
                        Text(
                            "You have no recorded transactions"
                        )
                        .font(.subheadline)
                        .fontWeight(.ultraLight)
                        .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(transactions) { transaction in
                                    NavigationLink(
                                        value: TransactionDestination.transaction(transactionId: transaction.id)
//                                            destination: TransactionDetailsView(transactionId: transaction.id)
                                    ) {
                                        TransactionItem(
                                            transactionId: transaction.id,
                                            userRole: transaction.senderUserId
                                                == userId ? "SENDER" : "RECEIVER",
                                            name: transaction.senderUserId == userId
                                                ? transaction.receiverWalletUserName
                                                : transaction
                                                    .senderWalletUserName,
                                            imageUrl: transaction.senderUserId
                                                == userId
                                                ? (transaction.senderWalletUserImage
                                                    ?? "")
                                                : (transaction
                                                    .receiverWalletUserImage ?? ""),
                                            date: transaction.createdAt,
                                            amount: transaction.amount,
                                            status: transaction.status
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                loading.toggle()
                await handleGetMyTransactions()
                loading.toggle()
            }
        }
        .navigationDestination(for: TransactionDestination.self) {
            destination in
            switch destination {
            case .transaction(let transactionId):
                TransactionDetailsView(transactionId: transactionId)
            }
        }
    }

    func handleGetMyTransactions() async {
        do {
            let data: [TransactionModel] =
                try await transactionService.getMyTransactions()

            transactions = data
            print(data)
        } catch let apiError as TransactionError {
            errorMessage =
                apiError.errorDescription ?? "An unexpected error occurred"
            print("error: \(apiError)")
            showError = true
        } catch {
            errorMessage = "An unexpected error occurred"
            showError = true
        }
    }

}

#Preview {
    TransactionsView()
}
