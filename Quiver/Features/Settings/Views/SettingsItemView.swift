//
//  SettingsItem.swift
//  Quiver
//
//  Created by Michael Brew on 09/09/2025.
//

import SwiftUI

struct SettingsItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String?
}

struct SettingsItemView: View {
    let name: String
    let icon: String?
    
    var body: some View {
        HStack {
            Image(systemName: icon ?? "person")
                .font(.title3)
                .padding(.trailing)
            Text(name)
                .font(.title3)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding(.vertical)
    }
}

#Preview {
    List {
        SettingsItemView(name: "Profile", icon: "person")
        SettingsItemView(name: "Help", icon: "questionmark.circle")
        SettingsItemView(name: "Privacy Policy", icon: "lock.shield")
        SettingsItemView(name: "Security", icon: "lock")
        SettingsItemView(name: "Sign Out", icon: "rectangle.portrait.and.arrow.forward")
    }
}
