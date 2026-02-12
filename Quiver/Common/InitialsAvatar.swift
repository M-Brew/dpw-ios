//
//  InitialsAvatar.swift
//  Quiver
//
//  Created by Michael on 07/01/2026.
//

import SwiftUI

struct InitialsAvatar: View {
    let name: String
    let size: CGFloat?
    let font: Font?

    var initials: String {
        let names = name.split(separator: " ")
        return names[0].prefix(1).uppercased() + names[1].prefix(1).uppercased()
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    Color(
                        red: 237 / 255,
                        green: 160 / 255,
                        blue: 90 / 255
                    )
                )
                .frame(width: size ?? 50, height: size ?? 50)
            Text(initials)
                .font(font)
                .foregroundStyle(Color.primary)
        }
    }
}

#Preview {
    InitialsAvatar(name: "Adriana Lima", size: 50, font: .title2)
}
