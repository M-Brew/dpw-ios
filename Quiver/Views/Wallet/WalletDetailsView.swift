//
//  WalletDetailsView.swift
//  Quiver
//
//  Created by Michael Brew on 21/08/2025.
//

import SwiftUI

struct WalletDetailsView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Quiver")
                    .font(.system(size: 44, weight: .semibold, design: .serif))
                VStack(alignment: .leading) {
                    Text("Current Balance")
                        .font(.subheadline)
                        .fontWeight(.light)
                    Text(100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.largeTitle)
                        .padding(.vertical)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
                .padding(.vertical, 15)
                HStack {
                    Button(action: {
                        print("Deposit")
                    }) {
                        Label("DEPOSIT", systemImage: "arrow.down.left")
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                    }
                    .font(.subheadline)
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .background(.black)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        print("Withdraw")
                    }) {
                        Label("WITHDRAW", systemImage: "arrow.up.right")
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                    }
                    .font(.subheadline)
                    .buttonStyle(.bordered)
                    .foregroundColor(.black)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    WalletDetailsView()
}
