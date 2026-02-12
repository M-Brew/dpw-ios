//
//  CustomTabBar.swift
//  Quiver
//
//  Created by Michael on 04/02/2026.
//

import SwiftUI

enum NavigationTab {
    case dashboard, wallet, transactions, settings
}

struct CustomTabBar: View {
    @Bindable var navManager: NavigationManager

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                TabItem(
                    tab: .dashboard,
                    icon: "house",
                    label: "Dashboard",
                    navManager: navManager
                )
                TabItem(
                    tab: .wallet,
                    icon: "creditcard",
                    label: "Wallet",
                    navManager: navManager
                )
                TabItem(
                    tab: .transactions,
                    icon: "rectangle.and.arrow.up.right.and.arrow.down.left",
                    label: "Transactions",
                    navManager: navManager
                )
                TabItem(
                    tab: .settings,
                    icon: "gear",
                    label: "Settings",
                    navManager: navManager
                )
            }
            .padding(.vertical)
            .background(.ultraThinMaterial)
        }
    }
}

struct TabItem: View {
    let tab: NavigationTab
    let icon: String
    let label: String
    @Bindable var navManager: NavigationManager

    var body: some View {
        Button {
            if navManager.selectedTab == tab {
                navManager.popToRoot()
            } else {
                navManager.selectedTab = tab
            }
        } label: {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(navManager.selectedTab == tab ? .black : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CustomTabBar(navManager: NavigationManager())
}
