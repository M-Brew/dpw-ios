//
//  MainView.swift
//  Quiver
//
//  Created by Michael Brew on 14/08/2025.
//

import SwiftUI

struct MainView: View {
    @Environment(WalletManager.self) private var walletManager
    
    @State private var navManager = NavigationManager()
//    let walletService = WalletService()

    @State private var selectedTab = "dashboard"
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

//    @State private var wallet: WalletModel?

    var body: some View {
        Group {
            if loading {
                ProgressView()
            } else {
                ZStack(alignment: .bottom) {
                    Group {
                        switch navManager.selectedTab {
                        case .dashboard:
                            NavigationStack(path: $navManager.dashboardPath) {
                                DashboardView()
                            }
                        case .wallet:
                            NavigationStack(path: $navManager.walletPath) {
                                WalletView()
                            }
                        case .transactions:
                            NavigationStack(path: $navManager.transactionsPath) {
                                TransactionsView()
                            }
                        case .settings:
                            NavigationStack(path: $navManager.settingsPath) {
                                SettingsView()
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
//                if wallet == nil {
//                    CreateWalletView(wallet: $wallet)
//                } else {
//                    
//                    ZStack(alignment: .bottom) {
//                        TabView(selection: $selectedTab) {
//                            Tab(
//                                "Dashboard",
//                                systemImage: "house",
//                                value: "dashboard"
//                            ) {
//                                DashboardView(wallet: $wallet)
//                            }
//                            Tab(
//                                "Wallet",
//                                systemImage: "creditcard",
//                                value: "wallet"
//                            ) {
//                                WalletView()
//                            }
//                            Tab(
//                                "Transactions",
//                                systemImage:
//                                    "rectangle.and.arrow.up.right.and.arrow.down.left",
//                                value: "transactions"
//                            ) {
//                                TransactionsView()
//                            }
//                            Tab(
//                                "Settings",
//                                systemImage: "gear",
//                                value: "settings"
//                            ) {
//                                SettingsView()
//                            }
//                        }
//                        .tabViewStyle(
//                            PageTabViewStyle(indexDisplayMode: .never)
//                        )
//                        .overlay(alignment: .bottom) {
//                            BottomTabBar(selectedTab: $selectedTab)
//                                .padding(.horizontal)
//                                .offset(y: -30)
//                                .transition(
//                                    .move(edge: .bottom).combined(
//                                        with: .opacity
//                                    )
//                                )
//
//                        }
//                    }
//                    .ignoresSafeArea()
//                }
            }
        }
        .onAppear {
            Task {
                loading.toggle()
//                await handleGetWallet()
                await walletManager.fetchWallet()
                loading.toggle()
            }
        }
    }

//    func handleGetWallet() async {
//        do {
//            let walletData: WalletModel = try await walletService.getMyWallet()
//
//            wallet = walletData
//            print(walletData)
//        } catch let apiError as WalletError {
//            errorMessage =
//                apiError.errorDescription ?? "An unexpected error occurred"
//            print("error: \(apiError)")
//            showError = true
//        } catch {
//            errorMessage = "An unexpected error occurred"
//            showError = true
//        }
//    }

}

#Preview {
    MainView()
        .environment(WalletManager())
}
