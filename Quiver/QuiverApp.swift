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
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn == true {
                if emailVerified == true {
                    MainView()
                } else {
                    OTPView()
                }
            } else {
                ContentView()
            }
        }
    }
}
