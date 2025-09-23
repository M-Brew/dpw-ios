//
//  SigInView.swift
//  Quiver
//
//  Created by Michael Brew on 12/08/2025.
//

import SwiftUI
import JWTDecode

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var errors: [String: String]?
    @State private var showError: Bool = false

    @AppStorage("userId") private var userId = ""
    @AppStorage("name") private var name = ""
    @AppStorage("email") private var userEmail = ""
    @AppStorage("emailVerified") private var emailVerified = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @State private var model = AuthViewModel()

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
            if showError {
                ToastView(message: errorMessage!, position: .bottom, duration: 3.0, isShowing: $showError)
            }
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
            let authUser = try await model.signIn(email: email, password: password)
            
            userId = authUser.userId
            name = authUser.name
            userEmail = authUser.email
            emailVerified = authUser.emailVerified
            
            isLoggedIn = true
        } catch let apiError as AuthError {
            errorMessage = apiError.errorDescription ?? "An unexpected error occurred"
            print("error: \(apiError)")
            showError = true
        } catch {
            errorMessage = "An unexpected error occurred"
            showError = true
        }
    }
}

#Preview {
    SignInView()
}
