//
//  WalletView.swift
//  Quiver
//
//  Created by Michael Brew on 05/09/2025.
//

import SwiftUI

struct WalletView: View {
    @AppStorage("name") private var name = ""

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        AsyncImage(
                            url: URL(
                                string:
                                    "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?q=80&w=1064&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                            )
                        ) { image in
                            image
                                .image?.resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                        .padding(.trailing, 10)
                        VStack(alignment: .leading) {
                            Text(name == "" ? "Jane Doe" : name)
                                .font(.title2)
                            Text("Ox12Dm2Xi34kl42")
                                .font(.subheadline)
                                .fontWeight(.ultraLight)
                        }
                        Spacer()
                        Button(action: {
                            print("Notifications")
                        }) {
                            Label("Notifictions", systemImage: "gear")
                                .labelStyle(.iconOnly)
                        }
                        .font(.title2)
                        .foregroundColor(.black)
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Current Balance")
                                .font(.subheadline)
                                .fontWeight(.light)
                            Spacer()
                            Text("Active")
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
                            100,
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
                        WalletActivityItem(amount: 100, type: "deposit", source: "bank", sourceName: "Ecobank", status: "success")
                            .padding(.bottom)
                        WalletActivityItem(amount: 100, type: "withdrawal", source: "mobile money", sourceName: "MTN", status: "success")
                            .padding(.bottom)
                        WalletActivityItem(amount: 55, type: "withdrawal", source: "mobile money", sourceName: "Telecel", status: "failed")
                            .padding(.bottom)
                        WalletActivityItem(amount: 125, type: "withdrawal", source: "mobile money", sourceName: "AT", status: "failed")
                            .padding(.bottom)
                        WalletActivityItem(amount: 250, type: "deposit", source: "bank", sourceName: "Stanbic", status: "success")
                            .padding(.bottom)
                    }
                    .padding()
                    .padding(.top, 20)
                }
            }
        }
    }
}

#Preview {
    WalletView()
}
