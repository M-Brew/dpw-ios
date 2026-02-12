//
//  EnterAmountView.swift
//  Quiver
//
//  Created by Michael on 19/01/2026.
//

import SwiftUI

struct EnterAmountView: View {
    let wallet: WalletModel
    let contact: ContactModel

    @State private var amount: String = "0.00"
    @State private var note: String = ""
    @FocusState private var isTextFieldFocused: Bool

    @Environment(\.dismiss) var dismiss

    var formattedAmount: String {
        return amount.isEmpty ? "0.00" : amount
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("SEND TO:")
                    .font(.system(size: 12, weight: .light))
                HStack {
                    ContactItemView(
                        contact: contact
                    )
                    Text("Change")
                        .font(.system(size: 16, weight: .bold))
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3)
            VStack(alignment: .leading) {
                Text("AMOUNT:")
                    .font(.system(size: 12, weight: .light))
                HStack {
                    Text("GH₵")
                        .font(.title)
                        .foregroundColor(.secondary)
                    TextField(
                        "",
                        text: $amount,
                    )
                    .font(
                        .system(
                            size: 42,
                            weight: .regular,
                            design: .rounded
                        )
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($isTextFieldFocused)
                    .fixedSize()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3)
            VStack(alignment: .leading) {
                Text("NOTE:")
                    .font(.system(size: 12, weight: .light))
                TextField("Note", text: $note, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3)
            Spacer()
            VStack {
                Spacer()
                NavigationLink(
                    value: DashboardDestination.paymentSummary(
                        wallet: wallet,
                        contact: contact,
                        amount: amount,
                        note: note
                    )
                ) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20, design: .rounded))
                }
                .buttonStyle(.borderedProminent)
                .tint(
                    Color(
                        red: 202 / 255,
                        green: 220 / 255,
                        blue: 174 / 255
                    )
                )
                .controlSize(.large)
                .disabled(Double(formattedAmount) ?? 0.0 < 1)
            }
            .padding()
        }
        .padding()
        .onAppear {
            isTextFieldFocused = true
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
    EnterAmountView(
        wallet: wallet,
        contact: ContactModel(
            id: "6941f1684253d48d91c9dc72",
            walletId: "69405c25b9d9c01cfeff9fdf",
            code: "WRrv!PDk^R9i",
            userId: "69405c25b9d9c01cfeff9fdg",
            userName: "Adriana Ditsa",
            userImage: nil,
            status: "active"
        )
    )
}
