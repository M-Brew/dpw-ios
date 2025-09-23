//
//  SettingsView.swift
//  Quiver
//
//  Created by Michael Brew on 09/09/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("name") private var name = ""

    @State private var model = AuthViewModel()

    @State private var isShowingSignOut = false
    @State private var loading: Bool = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            VStack {
                AsyncImage(
                    url: URL(
                        string:
                            "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?q=80&w=1064&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                    )
                ) { image in
                    image
                        .image?.resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 150, height: 150)
                .clipShape(.circle)
                .padding(.trailing, 10)
                Text(name == "" ? "Jane Doe" : name)
                    .font(.title2)
                Text("Ox12Dm2Xi34kl42")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.bottom)
                List {
                    SettingsItemView(name: "Profile", icon: "person")
                    SettingsItemView(name: "Help", icon: "questionmark.circle")
                    SettingsItemView(
                        name: "Privacy Policy",
                        icon: "lock.shield"
                    )
                    SettingsItemView(name: "Security", icon: "lock")
                    SettingsItemView(
                        name: "Sign Out",
                        icon: "rectangle.portrait.and.arrow.forward"
                    )
                    .onTapGesture {
                        isShowingSignOut = true
                    }
                }
            }
        }
        .alert("Sign Out", isPresented: $isShowingSignOut) {
            Button("Sign Out", role: .destructive) {
                Task {
                    loading.toggle()
                    await handleSignOut()
                    loading.toggle()
                }
                isShowingSignOut = false
            }
            .disabled(loading)
            Button("Cancel", role: .cancel) {
                isShowingSignOut = false
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .overlay(
            Group {
                if showError {
                    ToastView(
                        message: errorMessage!,
                        position: .bottom,
                        duration: 10.0,
                        isShowing: $showError
                    )
                }
            }
        )
    }

    func handleSignOut() async {
        do {
            let signedOut = try await model.signOut()

            if signedOut {
                isLoggedIn = false
            }
        } catch let apiError as AuthError {
            errorMessage =
                apiError.errorDescription ?? "An unexpected error occurred"
            print("error: \(apiError)")
            showError = true
        } catch {
            errorMessage = "An unexpected error occurred"
            showError = true
        }
    }
}

#Preview {
    SettingsView()
}
