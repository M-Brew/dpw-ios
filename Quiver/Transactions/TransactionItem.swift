//
//  TransactionItem.swift
//  Quiver
//
//  Created by Michael Brew on 12/08/2025.
//

import SwiftUI

struct TransactionItem: View {
    var body: some View {
        HStack {
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
            Spacer()
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Text("Lady Macbeth")
                        .font(.title3)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 13))
                }
                Text("17th July, 1756")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
            }
            Spacer()
            Spacer()
            Spacer()
            Text("-$100.00")
                .font(.headline)
        }
    }
}

#Preview {
    TransactionItem()
}
