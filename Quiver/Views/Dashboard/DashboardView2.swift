//
//  DashboardView2.swift
//  Quiver
//
//  Created by Michael on 04/02/2026.
//

import SwiftUI

//enum DashboardDestination: Hashable {
//    case send(wallet: WalletModel)
//    case pay(wallet: WalletModel)
//    case invoice(wallet: WalletModel)
//    case enterAmount(wallet: WalletModel, contact: ContactModel)
//    case paymentSummary(
//        wallet: WalletModel,
//        contact: ContactModel,
//        amount: String,
//        note: String
//    )
//    case paymentSuccess(transaction: TransactionModel)
//}

struct DashboardView2: View {
    @Environment(NavigationManager.self) private var navManager

    @AppStorage("name") private var name = ""
    @AppStorage("profilePicture") private var profilePicture = ""

    @Binding var wallet: WalletModel?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    if profilePicture.isEmpty {
                        InitialsAvatar(
                            name: name.isEmpty ? "J D" : name,
                            size: 50,
                            font: .title2
                        )
                    } else {
                        AsyncImage(
                            url: URL(
                                string: profilePicture.isEmpty
                                    ? "placeholder" : profilePicture
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
                    VStack(alignment: .leading) {
                        Text(
                            "Hello \(name == "" ? "" : name.split(separator: " ")[0])"
                        )
                        .font(.title)
                        Text("Welcome")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    Spacer()
                    Button(action: {
                        print("Notifications")
                    }) {
                        Label("Notifictions", systemImage: "bell")
                            .labelStyle(.iconOnly)
                    }
                    .font(.title)
                    .foregroundColor(.black)
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("Current Balance")
                        .font(.subheadline)
                        .fontWeight(.light)
                    Text(
                        wallet?.balance ?? 0,
                        format: .currency(
                            code: Locale.current.currency?.identifier
                                ?? "USD"
                        )
                    )
                    .font(.largeTitle)
                    .padding(.vertical)
                    HStack {
                        Button(action: {
                            print("Deposit")
                        }) {
                            Label(
                                "DEPOSIT",
                                systemImage: "arrow.down.left"
                            )
                        }
                        .font(.subheadline)
                        .buttonStyle(.bordered)
                        .foregroundColor(.white)
                        .background(.black)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(10)
                        Button(action: {
                            print("Withdraw")
                            print(profilePicture)
                        }) {
                            Label(
                                "WITHDRAW",
                                systemImage: "arrow.up.right"
                            )
                        }
                        .font(.subheadline)
                        .buttonStyle(.bordered)
                        .foregroundColor(.black)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(10)
                        Spacer()
                        Button(action: {
                            print("Wallet")
                        }) {
                            Label(
                                "Wallet",
                                systemImage: "creditcard.fill"
                            )
                            .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
                .padding(.vertical, 15)
                .padding(.horizontal)
                Rectangle()
                    .frame(height: 0.3)
                    .padding(.horizontal)
                HStack {
                    VStack {
                        Image(systemName: "paperplane.fill")
                            .padding()
                            .background(
                                Color(
                                    red: 202 / 255,
                                    green: 220 / 255,
                                    blue: 174 / 255
                                )
                            )
                            .clipShape(.circle)
                            .shadow(radius: 1)
                            .padding(.bottom, 5)
                        Text("Send")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    .onTapGesture {
                        if let wallet {
                            navManager.dashboardPath.append(
                                DashboardDestination.send(wallet: wallet)
                            )
                        }
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "qrcode.viewfinder")
                            .padding()
                            .background(
                                Color(
                                    red: 237 / 255,
                                    green: 160 / 255,
                                    blue: 90 / 255
                                )
                            )
                            .clipShape(.circle)
                            .shadow(radius: 1)
                            .padding(.bottom, 5)
                        Text("Pay")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    .onTapGesture {
                        if let wallet {
                            navManager.dashboardPath.append(
                                DashboardDestination.pay(wallet: wallet)
                            )
                        }
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "doc.text.viewfinder")
                            .padding()
                            .background(
                                Color(
                                    red: 225 / 255,
                                    green: 233 / 255,
                                    blue: 201 / 255
                                )
                            )
                            .clipShape(.circle)
                            .shadow(radius: 1)
                            .padding(.bottom, 5)
                        Text("Invoice")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    .onTapGesture {
                        if let wallet {
                            navManager.dashboardPath.append(
                                DashboardDestination.invoice(wallet: wallet)
                            )
                        }
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "chart.bar.fill")
                            .padding()
                            .background(.white)
                            .clipShape(.circle)
                            .shadow(radius: 1)
                            .padding(.bottom, 5)
                        Text("Analytics")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                }
                .padding()
                .padding(.horizontal)
                Rectangle()
                    .frame(height: 0.3)
                    .padding([.horizontal, .bottom])
                VStack(alignment: .leading) {
                    HStack {
                        Text("Transactions")
                            .font(.title2)
                        Spacer()
                        Text("See All")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    .padding(.bottom)
                    TransactionItem(
                        transactionId: "696513de7a3fce3ade687b61",
                        userRole: "SENDER",
                        name: "Elvis Thompson",
                        imageUrl: "",
                        date: "2026-01-12T15:31:42.201Z",
                        amount: 20,
                        status: "SUCCESS",
                    )
                    .padding(.bottom)
                    TransactionItem(
                        transactionId: "696513de7a3fce3ade687b61",
                        userRole: "SENDER",
                        name: "Elvis Thompson",
                        imageUrl: "",
                        date: "2026-01-12T15:31:42.201Z",
                        amount: 20,
                        status: "SUCCESS",
                    )
                    .padding(.bottom)
                    TransactionItem(
                        transactionId: "696513de7a3fce3ade687b61",
                        userRole: "SENDER",
                        name: "Elvis Thompson",
                        imageUrl: "",
                        date: "2026-01-12T15:31:42.201Z",
                        amount: 20,
                        status: "SUCCESS",
                    )
                    .padding(.bottom)
                    TransactionItem(
                        transactionId: "696513de7a3fce3ade687b61",
                        userRole: "SENDER",
                        name: "Elvis Thompson",
                        imageUrl: "",
                        date: "2026-01-12T15:31:42.201Z",
                        amount: 20,
                        status: "SUCCESS",
                    )
                    .padding(.bottom)
                    TransactionItem(
                        transactionId: "696513de7a3fce3ade687b61",
                        userRole: "SENDER",
                        name: "Elvis Thompson",
                        imageUrl: "",
                        date: "2026-01-12T15:31:42.201Z",
                        amount: 20,
                        status: "SUCCESS",
                    )
                }
                .padding(.top, 50)
                .padding(.bottom, 20)
                .padding(.horizontal)
                .background(.white)
                .clipShape(
                    UnevenRoundedRectangle(
                        cornerRadii: RectangleCornerRadii(
                            topLeading: 30,
                            topTrailing: 30
                        )
                    )
                )
                Spacer()
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationDestination(for: DashboardDestination.self) { destination in
            switch destination {
            case .send(let wallet):
                SelectRecipientView(wallet: wallet)
            case .pay(let wallet):
                ScanInvoiceView(wallet: wallet)
            case .invoice(let wallet):
                CreateInvoiceView(wallet: wallet)
            case .enterAmount(let wallet, let contact):
                EnterAmountView(wallet: wallet, contact: contact)
            case .paymentSummary(let wallet, let contact, let amount, let note):
                PaymentSummaryView(
                    wallet: wallet,
                    contact: contact,
                    amount: amount,
                    note: note
                )
            case .paymentSuccess(let transaction):
                TransactionSuccessfulView(transaction: transaction)
            }
        }
    }
}

#Preview {
    @Previewable @State var wallet: WalletModel? = WalletModel(
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

    DashboardView2(wallet: $wallet)
        .environment(NavigationManager())
}
