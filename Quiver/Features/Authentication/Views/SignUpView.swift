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
    @State private var showError: Bool = false
    
    @AppStorage("userId") private var userId = ""
    @AppStorage("name") private var name = ""
    @AppStorage("email") private var userEmail = ""
    @AppStorage("emailVerified") private var emailVerified = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @State private var model = AuthViewModel()

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
                        if errors?["firstName"] != nil {
                            Text((errors?["firstName"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 5)
                    VStack(alignment: .leading) {
                        Text("Last Name")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        TextField("Last Name", text: $lastName)
                            .frame(height: 48)
                            .padding(.horizontal, 10)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                        if errors?["lastName"] != nil {
                            Text((errors?["lastName"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 5)
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
                        if errors?["email"] != nil {
                            Text((errors?["email"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 5)
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
                        if errors?["phoneNumber"] != nil {
                            Text((errors?["phoneNumber"])!)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 5)
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
                    .padding(.bottom, 10)
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
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity)
                                .scaleEffect(1.5)
                                .tint(.white)
                                .padding(.vertical, 5)
                        } else {
                            Text("Register")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 24))
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .background(.black)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(10)
                    .disabled(loading)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            if showError {
                ToastView(message: errorMessage!, position: .bottom, duration: 3.0, isShowing: $showError)
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
        } else {
            let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
            if !emailPredicate.evaluate(with: email) {
                errors["email"] = "Invalid email address"
            }
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
            let authUser = try await model.signUp(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password)
            
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
    SignUpView()
}
