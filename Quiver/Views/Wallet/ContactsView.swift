//
//  ContactsView.swift
//  Quiver
//
//  Created by Michael on 06/01/2026.
//

import SwiftUI

struct ContactsView: View {
    @Environment(WalletManager.self) private var walletManager
//    @Binding var wallet: WalletModel

    let walletService = WalletService()

    @State private var showSearchContacts: Bool = false
    @State private var showRemoveContact: Bool = false
    @State private var selectedContact: ContactModel? = nil

    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            if let contacts = walletManager.wallet?.contacts {
                if contacts.isEmpty {
                    VStack(spacing: 30) {
                        Text(
                            "You have no contacts. Click on the search button to find and add accounts."
                        )
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .fontWeight(.ultraLight)
                        Button(action: {
                            showSearchContacts.toggle()
                        }) {
                            Label(
                                "SEARCH",
                                systemImage: "text.page.badge.magnifyingglass"
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                        }
                        .font(.subheadline)
                        .buttonStyle(.bordered)
                        .foregroundColor(.white)
                        .background(.black)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(contacts) { contact in
                            ContactItemView(
                                contact: contact,
                                variant: "remove",
                                action: {
                                    selectedContact = contact
                                    showRemoveContact.toggle()
                                }
                            )
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(Text("Contacts"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSearchContacts.toggle()
                } label: {
                    Label(
                        "Add Contact",
                        systemImage: "plus"
                    )
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showSearchContacts) {
            SearchContactView()
        }
        .alert("Remove Contact", isPresented: $showRemoveContact) {
            Button("Remove Contact", role: .destructive) {
                if let selectedContact {
                    Task {
                        loading.toggle()
                        await handleRemoveContact(
                            walletId: walletManager.wallet?.id ?? "",
                            contactCode: selectedContact.code
                        )
                        loading.toggle()
                    }
                }
                showRemoveContact = false
                selectedContact = nil
            }
            .disabled(loading)
            Button("Cancel", role: .cancel) {
                showRemoveContact = false
                selectedContact = nil
            }
        } message: {
            Text(
                "Are you sure you want to remove \(selectedContact?.userName ?? "contact")?"
            )
        }
    }

    func handleRemoveContact(walletId: String, contactCode: String) async {
        do {
            let data: WalletModel = try await walletService.removeContact(
                payload: AddContactPayload(
                    walletId: walletId,
                    contactCode: contactCode
                )
            )

            walletManager.wallet = data
        } catch let apiError as WalletError {
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
    NavigationStack {
        ContactsView(
//            wallet: .constant(
//                WalletModel(
//                    id: "6940517381f898ace79d49d6",
//                    userId: "693a0c1733d453f864291c53",
//                    userName: "Michael Brew",
//                    userImage: Optional(
//                        "https://joints-bucket.s3.eu-north-1.amazonaws.com/1c585bf3d4d4a60bb8b44f77e4ab65afd06cb6dacc772b8c022ac478e373f916.png"
//                    ),
//                    code: "9bP8~ol+@^SH",
//                    balance: 0.0,
//                    currency: "GHS",
//                    status: "active",
//                    contacts: [
//                        ContactModel(
//                            id: "6941f1684253d48d91c9dc71",
//                            walletId: "69405c25b9d9c01cfeff9fdf",
//                            code: "WRrv!PDk^R9i",
//                            userId: "69405c25b9d9c01cfeff9fdg",
//                            userName: "Adriana Ditsa",
//                            userImage: nil,
//                            status: "active"
//                        ),
//                        ContactModel(
//                            id: "6941f1684253d48d91c9dc72",
//                            walletId: "69405c25b9d9c01cfeff9fdf",
//                            code: "WRrv!PDk^R9i",
//                            userId: "69405c25b9d9c01cfeff9fdg",
//                            userName: "Adriana Ditsa",
//                            userImage: nil,
//                            status: "active"
//                        ),
//                        ContactModel(
//                            id: "6941f1684253d48d91c9dc73",
//                            walletId: "69405c25b9d9c01cfeff9fdf",
//                            code: "WRrv!PDk^R9i",
//                            userId: "69405c25b9d9c01cfeff9fdg",
//                            userName: "Adriana Ditsa",
//                            userImage: nil,
//                            status: "active"
//                        ),
//                        ContactModel(
//                            id: "6941f1684253d48d91c9dc74",
//                            walletId: "69405c25b9d9c01cfeff9fdf",
//                            code: "WRrv!PDk^R9i",
//                            userId: "69405c25b9d9c01cfeff9fdg",
//                            userName: "Adriana Ditsa",
//                            userImage: nil,
//                            status: "active"
//                        ),
//                        ContactModel(
//                            id: "6941f1684253d48d91c9dc75",
//                            walletId: "69405c25b9d9c01cfeff9fdf",
//                            code: "WRrv!PDk^R9i",
//                            userId: "69405c25b9d9c01cfeff9fdg",
//                            userName: "Adriana Ditsa",
//                            userImage: nil,
//                            status: "active"
//                        ),
//                    ],
//                    createdAt: "2025-12-15T18:20:35.964Z",
//                    updatedAt: "2025-12-16T23:55:20.694Z"
//                )
//            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .environment(WalletManager())
    }
}
