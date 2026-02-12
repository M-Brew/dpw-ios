//
//  PaymentSummaryView.swift
//  Quiver
//
//  Created by Michael on 19/01/2026.
//

import SwiftUI

struct PaymentSummaryView: View {
    @Environment(NavigationManager.self) private var navManager

    let wallet: WalletModel
    let contact: ContactModel
    let amount: String
    let note: String?

    @State private var model = TransactionViewModel()
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var errors: [String: String]?
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text("Send")
                    .font(
                        .system(size: 14, weight: .ultraLight, design: .rounded)
                    )
                Text(
                    Double(amount) ?? 0,
                    format: .currency(
                        code: Locale.current.currency?.identifier
                            ?? "USD"
                    )
                )
                .font(.largeTitle)
                Text("To:")
                    .font(
                        .system(size: 14, weight: .ultraLight, design: .rounded)
                    )
                VStack {
                    if contact.userImage == nil {
                        InitialsAvatar(
                            name: contact.userName,
                            size: 50,
                            font: .title2
                        )
                    } else {
                        AsyncImage(
                            url: URL(
                                string: contact.userImage
                                    ?? "placeholder"
                            )
                        ) { image in
                            image
                                .image?.resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                        .padding(.trailing, 10)
                    }
                    Text(contact.userName)
                        .font(
                            .system(
                                size: 14,
                                weight: .light,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(Color.black)
                }
                Spacer()
                HStack {
                    Text("Amount")
                        .foregroundStyle(Color.gray)
                        .font(.system(size: 14))
                    Spacer()
                    Text(
                        Double(amount) ?? 0,
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
                        .font(.system(size: 14))
                    Spacer()
                    Text(
                        (Double(amount) ?? 0) * 0.01,
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
                        .font(.system(size: 14))
                    Spacer()
                    Text(
                        ((Double(amount) ?? 0) * 0.01) + (Double(amount) ?? 0),
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
                    .font(.system(size: 14))
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(note ?? "")
                    .font(
                        .system(
                            size: 14,
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
                Spacer()
                VStack(spacing: 10) {
                    if loading {
                        ProgressView()
                    } else {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 60,
                            bottomTrailingRadius: 60,
                            topTrailingRadius: 0
                        )
                        .fill(Color(.systemBackground))
                        .frame(width: 60, height: 50)
                        .overlay {
                            Image(systemName: "paperplane.fill")
                                .font(.title2)
                                .padding(14)
                                .background(
                                    Color(
                                        red: 202 / 255,
                                        green: 220 / 255,
                                        blue: 174 / 255
                                    )
                                )
                                .clipShape(.circle)
                                .shadow(radius: 2)
                        }
                        Text("Tap to send")
                            .font(
                                .system(
                                    size: 14,
                                    weight: .ultraLight,
                                    design: .rounded
                                )
                            )
                    }
                }
                .onTapGesture {
                    Task {
                        loading.toggle()
                        let payload: P2PTransactionPayload = .init(
                            senderUserId: wallet.userId,
                            senderWalletId: wallet.id,
                            receiverUserId: contact.userId,
                            receiverWalletId: contact.walletId,
                            amount: Double(amount) ?? 0,
                            type: "P2P",
                            note: note ?? ""
                        )
                        await handleMakeP2PTransaction(payload: payload)
                        loading.toggle()
                    }
                }
                Spacer()
                Spacer()
            }
            .padding()
            if showError {
                ToastView(
                    message: errorMessage!,
                    position: .bottom,
                    duration: 3.0,
                    isShowing: $showError
                )
            }
        }
    }

    func handleMakeP2PTransaction(payload: P2PTransactionPayload) async {
        do {
            let data: TransactionModel = try await model.makeP2PTransaction(
                payload: payload
            )
            print(data)

            navManager.dashboardPath.append(
                DashboardDestination.paymentSuccess(transaction: data)
            )
        } catch let apiError as TransactionError {
            errorMessage =
                apiError.errorDescription ?? "An unexpected error occurred"
            showError = true
        } catch {
            errorMessage = "An unexpected error occurred"
            showError = true
        }
    }
}

#Preview {
    @Previewable @State var wallet: WalletModel = WalletModel(
        id: "",
        userId: "",
        userName: "Michael Brew",
        userImage: "",
        code: "1234ASDF",
        balance: 100,
        currency: "GH₵",
        status: "active",
        contacts: [],
        createdAt: "",
        updatedAt: ""
    )
    PaymentSummaryView(
        wallet: wallet,
        contact: ContactModel(
            id: "696911c212e3f3136ab193da",
            walletId: "6964d2307114840935ecfff7",
            code: "CpHuMaD2Hg3M",
            userId: "6964d0a65cbca9dddea2a6aa",
            userName: "Prince Amankwah",
            userImage: nil,
            status: nil
        ),
        amount: "100.00",
        note: "For services rendered"
    )
    .environment(NavigationManager())
}
