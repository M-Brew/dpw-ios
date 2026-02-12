//
//  SelectRecipientView.swift
//  Quiver
//
//  Created by Michael on 19/01/2026.
//

import SwiftUI

struct SelectRecipientView: View {
    let wallet: WalletModel
    let contacts: [ContactModel] = [
        ContactModel(
            id: "696911c212e3f3136ab193da",
            walletId: "6964d2307114840935ecfff7",
            code: "CpHuMaD2Hg3M",
            userId: "6964d2307114840935ecfff8",
            userName: "Prince Amankwah",
            userImage: nil,
            status: nil
        )
    ]

    @State private var searchText: String = ""
    @State private var selectedContact: ContactModel?

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ZStack {
            ScrollView {
                TextField("Enter Wallet ID or Username", text: $searchText)
                    .frame(height: 36)
                    .padding(.horizontal, 10)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    .font(.system(size: 16))
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .padding(.bottom)
                    .onChange(of: searchText) {
                        //                    Task {
                        //                        loading.toggle()
                        //                        await handleSearchContact(searchText: searchText)
                        //                        loading.toggle()
                        //                    }
                    }
                Text("My Contacts")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(contacts) { contact in
                        MyContactView(
                            contact: contact,
                            selected: contact.code == selectedContact?.code
                        )
                        .onTapGesture {
                            selectedContact = contact
                        }
                    }
                }
            }
            .padding()
            VStack {
                Spacer()
                if let selectedContact {
                    NavigationLink(
                        value: DashboardDestination.enterAmount(
                            wallet: wallet,
                            contact: selectedContact
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
                } else {
                    NavigationLink {} label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 20, design: .rounded))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)
                    .controlSize(.large)
                    .disabled(true)
                }
                //                if let selectedContact {
                //                    NavigationLink(
                //                        value: DashboardDestination.enterAmount(
                //                            wallet: wallet,
                //                            contact: selectedContact
                //                        )
                //                    ) {
                //                        Text("Continue")
                //                            .frame(maxWidth: .infinity)
                //                            .font(
                //                                .system(
                //                                    size: 18,
                //                                    weight: .semibold,
                //                                    design: .rounded
                //                                )
                //                            )
                //                    }
                //                    .padding(.vertical, 7)
                //                    .foregroundColor(.black)
                //                    .background(
                //                        Color(
                //                            red: 202 / 255,
                //                            green: 220 / 255,
                //                            blue: 174 / 255
                //                        )
                //                    )
                //                    .cornerRadius(10)
                //                } else {
                //                    Text("Continue")
                //                        .frame(maxWidth: .infinity)
                //                        .font(
                //                            .system(
                //                                size: 18,
                //                                weight: .semibold,
                //                                design: .rounded
                //                            )
                //                        )
                //                        .padding(.vertical, 7)
                //                        .foregroundColor(.gray)
                //                        .background(
                //                            Color(
                //                                red: 202 / 255,
                //                                green: 220 / 255,
                //                                blue: 174 / 255
                //                            )
                //                        )
                //                        .cornerRadius(10)
                //
                //                }

            }
            .padding()
        }
    }
}

struct MyContactView: View {
    let contact: ContactModel
    let selected: Bool

    var body: some View {
        VStack {
            if contact.userImage == nil {
                InitialsAvatar(
                    name: contact.userName,
                    size: 50,
                    font: .title2
                )
            } else {
                AsyncImage(
                    url: URL(
                        string: contact.userImage
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
            Text(contact.userName.split(separator: " ")[0])
                .font(
                    .system(
                        size: 14,
                        weight: .regular,
                        design: .rounded
                    )
                )
                .foregroundStyle(selected ? Color.black : Color.gray)
            Text(contact.userName.split(separator: " ")[1])
                .font(
                    .system(
                        size: 14,
                        weight: .regular,
                        design: .rounded
                    )
                )
                .foregroundStyle(selected ? Color.black : Color.gray)
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

    SelectRecipientView(wallet: wallet)
}
