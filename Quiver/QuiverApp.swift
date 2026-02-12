//
//  QuiverApp.swift
//  Quiver
//
//  Created by Michael Brew on 11/08/2025.
//

import SwiftUI

@main
struct QuiverApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("emailVerified") private var emailVerified = false
    
    @State private var walletManager = WalletManager()
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn == true {
                if emailVerified == true {
                    MainView()
                        .environment(walletManager)
                        .dismissKeyboardOnTap()
                } else {
                    OTPView()
                        .dismissKeyboardOnTap()
                }
            } else {
                ContentView()
                    .dismissKeyboardOnTap()
            }
        }
    }
}
