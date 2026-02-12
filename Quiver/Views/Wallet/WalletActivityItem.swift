//
//  WalletActivityItem.swift
//  Quiver
//
//  Created by Michael Brew on 05/09/2025.
//

import SwiftUI

struct WalletActivityItem: View {
    let amount: Double
    let type: String
    let source: String
    let sourceName: String
    let status: String

    var body: some View {
        HStack {
            Image(
                systemName: source == "bank"
                    ? "building.columns.fill" : "iphone.gen2.circle"
            )
            .font(.system(size: 25))
            .frame(width: 50, height: 50)
            .clipShape(.circle)
            Spacer()
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    if type == "deposit" {
                        Image(
                            systemName: "arrow.down.left"
                        )
                        .font(.system(size: 13))
                    }
                    Text(
                        amount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    )
                    .font(.title3)
                    if type == "withdrawal" {
                        Image(
                            systemName: type == "deposit"
                                ? "arrow.down.left" : "arrow.up.right"
                        )
                        .font(.system(size: 13))
                    }
                }
                Text(
                    type == "deposit"
                        ? "Deposit via \(source) account (\(sourceName))"
                        : "Withdrawal to \(source) account (\(sourceName))"
                )
                .font(.subheadline)
                .fontWeight(.ultraLight)
            }
            Spacer()
            Spacer()
            Spacer()
            Text(status == "success" ? "Success" : "Failed")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundStyle(status == "success" ? .black : .white)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(
                    Capsule().fill(
                        status == "success"
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
    }
}

#Preview {
    WalletActivityItem(
        amount: 100.00,
        type: "deposit",
        source: "bank",
        sourceName: "Ecobank",
        status: "success"
    )
}
