//
//  DashboardRoot.swift
//  Quiver
//
//  Created by Michael on 30/01/2026.
//

import SwiftUI

struct MainContainerView: View {
    @State private var navManager = NavigationManager()
    @State private var wallet: WalletModel? = WalletModel(
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

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch navManager.selectedTab {
                case .dashboard:
                    NavigationStack(path: $navManager.dashboardPath) {
                        DashboardView2(wallet: $wallet)
                    }
                case .wallet:
                    NavigationStack(path: $navManager.walletPath) {
                        SearchRootView()
                    }
                case .transactions:
                    NavigationStack(path: $navManager.transactionsPath) {
                        NotificationRootView()
                    }
                case .settings:
                    NavigationStack(path: $navManager.settingsPath) {
                        ProfileRootView()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            if navManager.shouldShowTabBar {
                CustomTabBar(navManager: navManager)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .environment(navManager)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct SearchRootView: View {
    var body: some View {
        Text("Search")
    }
}

struct NotificationRootView: View {
    var body: some View {
        Text("Notifications")
    }
}

struct ProfileRootView: View {
    var body: some View {
        Text("Profile")
    }
}

#Preview {
    MainContainerView()
}
