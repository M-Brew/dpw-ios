//
//  TransactionItem.swift
//  Quiver
//
//  Created by Michael Brew on 12/08/2025.
//

import SwiftUI

struct TransactionItem: View {
    let transactionId: String
    let userRole: String
    let name: String
    let imageUrl: String
    let date: String
    let amount: Double
    let status: String

    var body: some View {
        HStack {
            if imageUrl == "" {
                InitialsAvatar(
                    name: name,
                    size: 50,
                    font: .title2
                )
            } else {
                AsyncImage(
                    url: URL(
                        string: imageUrl
                    )
                ) { image in
                    image
                        .image?.resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 50, height: 50)
                .clipShape(.circle)
            }
            Spacer()
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Text(name)
                        .font(.title3)
                    Image(
                        systemName: userRole == "SENDER"
                            ? "arrow.up.right" : "arrow.down.left"
                    )
                    .font(.system(size: 13))
                }
                Text(dateAndTime(isoDateString: date).date)
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
            }
            Spacer()
            Spacer()
            Spacer()
            Text(
                amount,
                format: .currency(
                    code: Locale.current.currency?.identifier
                        ?? "USD"
                )
            )
            .font(.headline)
        }
    }
}

#Preview {
    VStack {
        TransactionItem(
            transactionId: "696513de7a3fce3ade687b61",
            userRole: "SENDER",
            name: "Elvis Thompson",
            imageUrl: "",
            date: "2026-01-12T15:31:42.201Z",
            amount: 20,
            status: "SUCCESS",
        )
        TransactionItem(
            transactionId: "696513de7a3fce3ade687b61",
            userRole: "RECEIVER",
            name: "Christable Afrifa",
            imageUrl: "",
            date: "2026-01-15T12:00:00.000Z",
            amount: 130,
            status: "SUCCESS",
        )
    }
}
