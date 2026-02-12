//
//  TransactionDetailsView.swift
//  Quiver
//
//  Created by Michael on 16/01/2026.
//

import SwiftUI

struct TransactionDetailsView: View {
    let transactionId: String
    let transactionService = TransactionsService()

    @State private var transaction: TransactionModel? = TransactionModel(
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
    let status = "success"

    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            if let transaction {
                ScrollView {
                    VStack {
                        Text("Total Amount")
                            .font(
                                .system(size: 16, weight: .medium, design: .rounded)
                            )
                            .foregroundStyle(Color.gray)
                        Text(
                            transaction.amount,
                            format: .currency(
                                code: Locale.current.currency?.identifier
                                    ?? "USD"
                            )
                        )
                        .font(.largeTitle)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                        Text(transaction.status == "SUCCESS" ? "Success" : "Failed")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundStyle(status == "success" ? .black : .white)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(
                                    transaction.status == "SUCCESS"
                                        ? Color(
                                            red: 202 / 255,
                                            green: 220 / 255,
                                            blue: 174 / 255
                                        )
                                        : Color(
                                            red: 128 / 255,
                                            green: 5 / 255,
                                            blue: 23 / 255
                                        )
                                )
                            )
                    }
                    .padding(.bottom)
                    VStack {
                        Text("SENDER")
                            .font(
                                .system(size: 10, weight: .light, design: .rounded)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(transaction.senderWalletUserName)
                                Text(transaction.senderWalletCode)
                                    .font(.subheadline)
                                    .fontWeight(.ultraLight)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(
                                    dateAndTime(
                                        isoDateString: transaction.createdAt
                                    ).date
                                )
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.regular)
                                Text(
                                    dateAndTime(
                                        isoDateString: transaction.createdAt
                                    ).time
                                )
                                .foregroundStyle(Color.gray)
                                .font(.caption)
                                .fontWeight(.regular)
                            }
                        }
                        Divider()
                            .padding(.vertical, 20)

                        Text("RECEIPIENT")
                            .font(
                                .system(size: 10, weight: .light, design: .rounded)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(transaction.receiverWalletUserName)
                                Text(transaction.receiverWalletCode)
                                    .font(.subheadline)
                                    .fontWeight(.ultraLight)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(
                                    dateAndTime(
                                        isoDateString: transaction.updatedAt
                                    ).date
                                )
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.regular)
                                Text(
                                    dateAndTime(
                                        isoDateString: transaction.updatedAt
                                    ).time
                                )
                                .foregroundStyle(Color.gray)
                                .font(.caption)
                                .fontWeight(.regular)
                            }
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 0.5)
                    )
                    .padding(.vertical, 5)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Transaction Details")
                            .font(.title3)
                            .padding(.bottom)
                        HStack {
                            Text("Transaction ID")
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Text("# \(transaction.id)")
                                .font(
                                    .system(
                                        size: 14,
                                        weight: .regular,
                                        design: .rounded
                                    )
                                )
                        }
                        Divider()
                        HStack {
                            Text("Amount")
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Text(
                                transaction.amount,
                                format: .currency(
                                    code: Locale.current.currency?.identifier
                                        ?? "USD"
                                )
                            )
                            .font(
                                .system(
                                    size: 14,
                                    weight: .regular,
                                    design: .rounded
                                )
                            )
                        }
                        Divider()
                        HStack {
                            Text("Fee")
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Text(
                                transaction.amount * 0.01,
                                format: .currency(
                                    code: Locale.current.currency?.identifier
                                        ?? "USD"
                                )
                            )
                            .font(
                                .system(
                                    size: 14,
                                    weight: .regular,
                                    design: .rounded
                                )
                            )
                        }
                        Divider()
                        HStack {
                            Text("Total Amount")
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Text(
                                transaction.amount + transaction.amount * 0.01,
                                format: .currency(
                                    code: Locale.current.currency?.identifier
                                        ?? "USD"
                                )
                            )
                            .font(
                                .system(
                                    size: 14,
                                    weight: .regular,
                                    design: .rounded
                                )
                            )
                        }
                        Text("Note")
                            .foregroundStyle(Color.gray)
                            .padding(.top)
                        Text(transaction.description ?? "")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .regular,
                                    design: .rounded
                                )
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray, lineWidth: 0.2)
                            )
                    }
                    .padding(.vertical)
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .navigationTitle(Text("Transaction Details"))
        .onAppear {
            Task {
                loading.toggle()
                await handleGetTransaction(transactionId: transactionId)
                loading.toggle()
            }
        }
    }

    func handleGetTransaction(transactionId: String) async {
        do {
            let data: TransactionModel =
                try await transactionService.getTransaction(
                    transactionId: transactionId
                )

            transaction = data
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
    TransactionDetailsView(transactionId: "")
}
