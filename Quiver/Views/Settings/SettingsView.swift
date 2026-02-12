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
    @AppStorage("profilePicture") private var profilePicture = ""

    @State private var model = AuthViewModel()

    @State private var isShowingSignOut = false
    @State private var loading: Bool = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                if profilePicture.isEmpty {
                    Image("placeholder")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(.circle)
                } else {
                    AsyncImage(
                        url: URL(
                            string: profilePicture.isEmpty
                                ? "placeholder" : profilePicture
                        )
                    ) { image in
                        image
                            .image?.resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(.circle)
                    .padding(.trailing, 10)
                }
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
