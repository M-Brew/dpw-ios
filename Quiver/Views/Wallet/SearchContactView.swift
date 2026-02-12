//
//  SearchContactView.swift
//  Quiver
//
//  Created by Michael on 07/01/2026.
//

import SwiftUI

struct SearchContactView: View {
    @Environment(WalletManager.self) private var walletManager
    @Environment(\.dismiss) var dismiss

//    @Binding var wallet: WalletModel

    let walletService = WalletService()

    @State private var searchText: String = ""
    @State private var contacts: [ContactModel] = []

    @State private var showAddContact: Bool = false
    @State private var selectedContact: ContactModel? = nil

    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            TextField("", text: $searchText)
                .frame(height: 36)
                .padding(.horizontal, 10)
                .background(.regularMaterial)
                .cornerRadius(10)
                .font(.system(size: 16))
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .onChange(of: searchText) {
                    Task {
                        loading.toggle()
                        await handleSearchContact(searchText: searchText)
                        loading.toggle()
                    }
                }
            ScrollView {
                VStack {
                    ForEach(contacts) { contact in
                        ContactItemView(
                            contact: contact,
                            variant: "add",
                            action: {
                                selectedContact = contact
                                showAddContact.toggle()
                            }
                        )
                    }
                }
            }
        }
        .padding()
        .padding(.top)
        .alert("Add Contact", isPresented: $showAddContact) {
            Button("Add", role: .destructive) {
                if let selectedContact {
                    Task {
                        loading.toggle()
                        await handleAddContact(
                            walletId: walletManager.wallet?.id ?? "",
                            contactCode: selectedContact.code
                        )
                        loading.toggle()
                    }
                }
                showAddContact = false
                selectedContact = nil
                dismiss()
            }
            .disabled(loading)
            Button("Cancel", role: .cancel) {
                showAddContact = false
                selectedContact = nil
            }
        } message: {
            Text(
                "Press 'Add' button to add \(selectedContact?.userName ?? "contact") to your contact list"
            )
        }
    }

    func handleSearchContact(searchText: String) async {
        do {
            let data: [ContactModel] = try await walletService.searchContact(
                searchText: searchText
            )

            contacts = searchText == "" ? [] : data
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

    func handleAddContact(walletId: String, contactCode: String) async {
        do {
            let data: WalletModel = try await walletService.addContact(
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
    SearchContactView(
//        wallet: .constant(
//            WalletModel(
//                id: "6940517381f898ace79d49d6",
//                userId: "693a0c1733d453f864291c53",
//                userName: "Michael Brew",
//                userImage: Optional(
//                    "https://joints-bucket.s3.eu-north-1.amazonaws.com/1c585bf3d4d4a60bb8b44f77e4ab65afd06cb6dacc772b8c022ac478e373f916.png"
//                ),
//                code: "9bP8~ol+@^SH",
//                balance: 0.0,
//                currency: "GHS",
//                status: "active",
//                contacts: [
//                    ContactModel(
//                        id: "6941f1684253d48d91c9dc71",
//                        walletId: "69405c25b9d9c01cfeff9fdf",
//                        code: "WRrv!PDk^R9i",
//                        userId: "69405c25b9d9c01cfeff9fdg",
//                        userName: "Adriana Ditsa",
//                        userImage: nil,
//                        status: "active"
//                    )
//                ],
//                createdAt: "2025-12-15T18:20:35.964Z",
//                updatedAt: "2025-12-16T23:55:20.694Z"
//            )
//        )
    )
    .environment(WalletManager())
}
