//
//  MainView.swift
//  Quiver
//
//  Created by Michael Brew on 14/08/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = "home"
    @State private var errorMessage: String?
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    let authService = AuthService()
    let keychainManager = KeychainManager()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: "home") {
                DashboardView()
            }
            Tab("Wallet", systemImage: "creditcard", value: "wallet") {
                Image(systemName: "creditcard")
                    .font(.largeTitle)
            }
            Tab("Transactions", systemImage: "rectangle.and.arrow.up.right.and.arrow.down.left", value: "transactions") {
                Image(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left")
                    .font(.largeTitle)
            }
            Tab("Settings", systemImage: "gear", value: "settings") {
                Button {
                    Task {
                        do {
                            if let refreshToken = keychainManager.retrieveJWT(service: "com.Quiver.rTService") {
                                print("Retrieved JWT: \(refreshToken)")
                                
                                let signOutPayload = SignOutPayload(token: refreshToken)
                                let signOutSuccessful = try await authService.signOut(payload: signOutPayload)
                                if signOutSuccessful == true {
                                    let r = keychainManager.deleteJWT(service: "com.Quiver.rTService")
                                    
                                    let a = keychainManager.deleteJWT(service: "com.Quiver.aTService")
                                    if r == errSecSuccess && a == errSecSuccess {
                                        print("sign out successful")
                                        
                                    isLoggedIn = false
                                    } else {
                                        print("tokens not deleted")
                                    }
                                }
                            } else {
                                print("Refresh token not found or error retrieving.")
                            }
                        } catch let apiError as AuthError {
                            errorMessage = apiError.errorDescription
                            print(apiError.errorDescription!)
                        } catch {
                            errorMessage = "An unexpected error occurred"
                        }
                    }
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 24))
                }
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            BottomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .offset(y: 30)
        }
    }
}

#Preview {
    MainView()
}
