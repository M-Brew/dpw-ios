//
//  ContactItemView.swift
//  Quiver
//
//  Created by Michael on 07/01/2026.
//

import SwiftUI

struct ContactItemView: View {
    let contact: ContactModel
    let variant: String?
    let action: (() -> Void)?
    
    init(contact: ContactModel, variant: String? = nil, action: (() -> Void)? = nil) {
        self.contact = contact
        self.variant = variant
        self.action = action
    }

    var body: some View {
        HStack {
            if contact.userImage == nil {
                InitialsAvatar(name: contact.userName, size: 40, font: .title3)
                    .padding(.trailing)
            } else {
                AsyncImage(
                    url: URL(
                        string: contact.userImage
                            ?? "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?q=80&w=1064&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                    )
                ) { image in
                    image
                        .image?.resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 50, height: 50)
                .clipShape(.circle)
                .padding(.trailing)
            }
            VStack(alignment: .leading) {
                Text(contact.userName)
                    .font(.title3)
                Text(contact.code)
                    .font(.caption)
                    .fontWeight(.ultraLight)
            }
            Spacer()
            if variant != nil {
                Image(systemName: variant == "add" ? "plus" : "minus")
                    .onTapGesture {
                        Task {
                            action?()
                        }
                    }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    VStack {
        ContactItemView(
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
        ContactItemView(
            contact: ContactModel(
                id: "6941f1684253d48d91c9dc72",
                walletId: "69405c25b9d9c01cfeff9fdf",
                code: "WRrv!PDk^R9i",
                userId: "69405c25b9d9c01cfeff9fdg",
                userName: "Adriana Ditsa",
                userImage: nil,
                status: "active"
            ),
            variant: "add"
        )
        ContactItemView(
            contact: ContactModel(
                id: "6941f1684253d48d91c9dc72",
                walletId: "69405c25b9d9c01cfeff9fdf",
                code: "WRrv!PDk^R9i",
                userId: "69405c25b9d9c01cfeff9fdg",
                userName: "Adriana Ditsa",
                userImage: nil,
                status: "active"
            ),
            variant: "remove"
        )
    }
}
