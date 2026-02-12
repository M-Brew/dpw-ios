//
//  WalletView.swift
//  Quiver
//
//  Created by Michael Brew on 05/09/2025.
//

import SwiftUI

enum WalletDestination: Hashable {
    case contacts
}

struct WalletView: View {
    @Environment(WalletManager.self) private var walletManager
    
    @AppStorage("name") private var name = ""
    let walletService = WalletService()

    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

//    @State private var wallet: WalletModel?

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Spacer()
                    HStack(alignment: .top) {
                        if walletManager.wallet?.userImage == nil {
                            InitialsAvatar(
                                name: walletManager.wallet?.userName ?? "J D",
                                size: 50,
                                font: .title2
                            )
                        } else {
                            AsyncImage(
                                url: URL(
                                    string: walletManager.wallet?.userImage
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
                        VStack(alignment: .leading) {
                            Text(walletManager.wallet?.userName ?? "Jane Doe")
                                .font(.title2)
                            Text(walletManager.wallet?.code ?? "ABCx1TjYoZq")
                                .font(.subheadline)
                                .fontWeight(.ultraLight)
                        }
                        Spacer()
                        NavigationLink(
                            value: WalletDestination.contacts
//                            destination: ContactsView(
//                                wallet: bindingWallet
//                            )
                        ) {
                            Label(
                                "Contacts",
                                systemImage: "person.crop.circle"
                            )
                            .labelStyle(.iconOnly)
                            .font(.title2)
                            .foregroundColor(.black)
                        }
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Current Balance")
                                .font(.subheadline)
                                .fontWeight(.light)
                            Spacer()
                            Text(walletManager.wallet?.status.capitalized ?? "Active")
                                .font(.caption)
                                .fontWeight(.light)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule().fill(
                                        Color(
                                            red: 237 / 255,
                                            green: 160 / 255,
                                            blue: 90 / 255
                                        )
                                    )
                                )
                        }
                        .padding(.vertical)
                        Text(
                            walletManager.wallet?.balance ?? 0,
                            format: .currency(
                                code: Locale.current.currency?.identifier
                                    ?? "USD"
                            )
                        )
                        .font(.largeTitle)
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 3)
                    .padding(.vertical, 15)
                    .padding(.horizontal)
                    HStack {
                        Button(action: {
                            print("Deposit")
                        }) {
                            Label("DEPOSIT", systemImage: "arrow.down.left")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                        }
                        .font(.subheadline)
                        .buttonStyle(.bordered)
                        .foregroundColor(.white)
                        .background(.black)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(10)
                        Button(action: {
                            print("Withdraw")
                        }) {
                            Label("WITHDRAW", systemImage: "arrow.up.right")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                        }
                        .font(.subheadline)
                        .buttonStyle(.bordered)
                        .foregroundColor(.black)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Activity")
                                .font(.title2)
                            Spacer()
                            Text("See All")
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
                        .padding(.bottom)
                        WalletActivityItem(
                            amount: 100,
                            type: "deposit",
                            source: "bank",
                            sourceName: "Ecobank",
                            status: "success"
                        )
                        .padding(.bottom)
                        WalletActivityItem(
                            amount: 100,
                            type: "withdrawal",
                            source: "mobile money",
                            sourceName: "MTN",
                            status: "success"
                        )
                        .padding(.bottom)
                        WalletActivityItem(
                            amount: 55,
                            type: "withdrawal",
                            source: "mobile money",
                            sourceName: "Telecel",
                            status: "failed"
                        )
                        .padding(.bottom)
                        WalletActivityItem(
                            amount: 125,
                            type: "withdrawal",
                            source: "mobile money",
                            sourceName: "AT",
                            status: "failed"
                        )
                        .padding(.bottom)
                        WalletActivityItem(
                            amount: 250,
                            type: "deposit",
                            source: "bank",
                            sourceName: "Stanbic",
                            status: "success"
                        )
                        .padding(.bottom)
                    }
                    .padding()
                    .padding(.top, 20)
                    Spacer()
                }
            }
        }
        .navigationDestination(for: WalletDestination.self) {
            destination in
            switch destination {
            case .contacts:
                ContactsView()
            }
        }
//        .onAppear {
//            Task {
//                loading.toggle()
//                await handleGetWallet()
//                loading.toggle()
//            }
//        }
    }

//    func handleGetWallet() async {
//        do {
//            let walletData: WalletModel = try await walletService.getMyWallet()
//
//            wallet = walletData
//            print(walletData)
//        } catch let apiError as WalletError {
//            errorMessage =
//                apiError.errorDescription ?? "An unexpected error occurred"
//            print("error: \(apiError)")
//            showError = true
//        } catch {
//            errorMessage = "An unexpected error occurred"
//            showError = true
//        }
//    }
}

#Preview {
    WalletView()
        .environment(WalletManager())
}
