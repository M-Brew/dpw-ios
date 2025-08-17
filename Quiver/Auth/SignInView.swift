//
//  SigInView.swift
//  Quiver
//
//  Created by Michael Brew on 12/08/2025.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var errors: [String: String]?

    @AppStorage("isLoggedIn") private var isLoggedIn = false

    let authService = AuthService()
    let keychainManager = KeychainManager()

    var body: some View {
        ZStack {
            Image("bg-5")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Sign In")
                    .font(.system(size: 48, weight: .medium, design: .serif))
                Text("Lorem ipsum dolor sit amet elit")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                Rectangle()
                    .frame(height: 0.1)
                    .padding([.top, .bottom])
                Spacer()
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(
                            .system(size: 20, weight: .light, design: .rounded)
                        )
                    TextField("Email", text: $email)
                        .frame(height: 48)
                        .padding(.horizontal, 10)
                        .background(.regularMaterial)
                        .cornerRadius(10)
                        .font(.system(size: 20))
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    if errors?["email"] != nil {
                        Text((errors?["email"])!)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.bottom, 15)
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(
                            .system(size: 20, weight: .light, design: .rounded)
                        )
                    PasswordField(password: $password)
                    if errors?["password"] != nil {
                        Text((errors?["password"])!)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.bottom, 20)
                Button {
                    errors = [:]
                    let errors = signInValidation(
                        email: email,
                        password: password
                    )
                    if !errors.isEmpty {
                        self.errors = errors
                        print(errors)
                        return
                    }
                    Task {
                        loading.toggle()
                        await handleSignIn(email: email, password: password)
                        loading.toggle()
                    }
                } label: {
                    if loading == true {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                            .scaleEffect(1.5)
                            .tint(.white)
                            .padding(.vertical, 5)
                    } else {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 24, design: .rounded))
                    }
                }
                .buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(.black)
                .buttonStyle(.borderedProminent)
                .cornerRadius(10)
                .disabled(loading)
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }

    private func signInValidation(email: String, password: String) -> [String:
        String]
    {
        var errors = [String: String]()

        if email.isEmpty {
            errors["email"] = "Email is required"
        }

        if password.isEmpty {
            errors["password"] = "Password is required"
        }

        return errors
    }

    func handleSignIn(email: String, password: String) async {
        do {
            let signInPayload = SignInPayload(email: email, password: password)
            let authData: AuthData = try await authService.signIn(
                payload: signInPayload
            )

            let accessTokenStatus = keychainManager.saveJWT(
                jwt: authData.accessToken,
                service: "com.Quiver.aTService"
            )
            if accessTokenStatus == errSecSuccess {
                print("Access token saved successfully.")
            } else {
                print("Error saving access token: \(accessTokenStatus)")
            }

            let refreshTokenStatus = keychainManager.saveJWT(
                jwt: authData.refreshToken,
                service: "com.Quiver.rTService"
            )
            if refreshTokenStatus == errSecSuccess {
                print("Refresh token saved successfully.")
            } else {
                print("Error saving refresh token: \(refreshTokenStatus)")
            }

            isLoggedIn = true
        } catch let apiError as AuthError {
            errorMessage = apiError.errorDescription
            print(apiError.errorDescription!)
        } catch {
            errorMessage = "An unexpected error occurred"
        }
    }
}

#Preview {
    SignInView()
}
