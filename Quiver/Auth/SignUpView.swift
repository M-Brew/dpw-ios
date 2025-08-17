//
//  SignUpView.swift
//  Quiver
//
//  Created by Michael Brew on 12/08/2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var errors: [String: String]?
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    let authService = AuthService()
    let keychainManager = KeychainManager()
    
    var body: some View {
        ZStack {
            Image("bg-2")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Register")
                        .font(.system(size: 48, weight: .medium, design: .serif))
                    Text("Lorem ipsum dolor sit amet elit")
                        .font(.system(size: 18, weight: .light, design: .rounded))
                    Rectangle()
                        .frame(height: 0.1)
                        .padding([.top, .bottom])
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("First Name")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        TextField("First Name", text: $firstName)
                            .frame(height: 48)
                            .padding(.horizontal, 10)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                            .padding(.bottom, 10)
                        if errors?["firstName"] != nil {
                            Text((errors?["firstName"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 10)
                    VStack(alignment: .leading) {
                        Text("Last Name")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        TextField("Last Name", text: $lastName)
                            .frame(height: 48)
                            .padding(.horizontal, 10)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                            .padding(.bottom, 10)
                        if errors?["lastName"] != nil {
                            Text((errors?["lastName"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 10)
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        TextField("Email", text: $email)
                            .frame(height: 48)
                            .padding(.horizontal, 10)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                            .textInputAutocapitalization(.never)
                            .padding(.bottom, 10)
                        if errors?["email"] != nil {
                            Text((errors?["email"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 10)
                    VStack(alignment: .leading) {
                        Text("Phone Number")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.decimalPad)
                            .frame(height: 48)
                            .padding(.horizontal, 10)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                            .padding(.bottom, 10)
                        if errors?["phoneNumber"] != nil {
                            Text((errors?["phoneNumber"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 10)
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.system(size: 20, weight: .light, design: .rounded))
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
                        let errors = signUpValidation(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            phoneNumber: phoneNumber,
                            password: password
                        )
                        if !errors.isEmpty {
                            self.errors = errors
                            print(errors)
                            return
                        }
                        Task {
                            loading.toggle()
                            await handleSignUp(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password)
                            loading.toggle()
                        }
                    } label: {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 24))
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .background(.black)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(10)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
    }
    
    private func signUpValidation(firstName: String, lastName: String, email: String, phoneNumber: String, password: String) -> [String:
        String]
    {
        var errors = [String: String]()
        
        if firstName.isEmpty {
            errors["firstName"] = "First name is required"
        }
        
        if lastName.isEmpty {
            errors["lastName"] = "Last name is required"
        }

        if email.isEmpty {
            errors["email"] = "Email is required"
        }
        
        if phoneNumber.isEmpty {
            errors["phoneNumber"] = "Phone number is required"
        } else {
            let cleaned = phoneNumber.filter { ("0"..."9").contains($0) }
            if cleaned.count != 10 {
                errors["phoneNumber"] = "Phone number must be 10 digits"
            }
        }

        if password.isEmpty {
            errors["password"] = "Password is required"
        }

        return errors
    }
    
    func handleSignUp(firstName: String, lastName: String, email: String, phoneNumber: String, password: String) async {
        do {
            let signUpPayload = SignUpPayload(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password)
            let authData: AuthData = try await authService.signUp(
                payload: signUpPayload
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
    SignUpView()
}
