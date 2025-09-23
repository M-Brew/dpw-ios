//
//  OTPView.swift
//  Quiver
//
//  Created by Michael Brew on 02/09/2025.
//

import SwiftUI

struct OTPView: View {
    let passcodeLength = 5
    @State private var passcode: [String]
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""

    @State private var resendLoading = false
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false
    @State private var successMessage: String?
    @State private var showSuccess: Bool = false
    
    @AppStorage("emailVerified") private var emailVerified = false

    @State private var model = AuthViewModel()

    init() {
        self.passcode = Array(repeating: "", count: passcodeLength)
    }

    var body: some View {
        ZStack {
            Image("bg-3")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Check your email")
                    .font(.system(size: 30, weight: .medium, design: .serif))
                    .padding(.bottom, 4)
                Text(
                    "Enter the unique code we sent to your email address below:"
                )
                .font(.system(size: 18, weight: .light, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
                HStack {
                    ForEach(0..<passcodeLength, id: \.self) { index in
                        TextField(
                            "",
                            text: $passcode[index],
                            onEditingChanged: { editing in
                                if editing {
                                    oldValue = passcode[index]
                                }
                            }
                        )
                        .keyboardType(.numberPad)
                        .frame(width: 54, height: 54)
                        .font(.system(size: 20))
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .multilineTextAlignment(.center)
                        .tag(index)
                        .focused($fieldFocus, equals: index)
                        .onChange(of: passcode[index]) {
                            if passcode[index].count > 1 {
                                let currentValue = Array(passcode[index])
                                if currentValue[0] == Character(oldValue) {
                                    passcode[index] = String(
                                        passcode[index].suffix(1)
                                    )
                                } else {
                                    passcode[index] = String(
                                        passcode[index].prefix(1)
                                    )
                                }
                            }
                            if !passcode[index].isEmpty {
                                if index == passcodeLength - 1 {
                                    fieldFocus = nil
                                } else {
                                    fieldFocus = (fieldFocus ?? 0) + 1
                                }
                            } else {
                                fieldFocus = (fieldFocus ?? 0) - 1
                            }
                        }
                    }
                }
                HStack {
                    Text("Didn't recieve it?")
                    Button {
                        Task {
                            resendLoading.toggle()
                            await handleResend()
                            resendLoading.toggle()
                        }
                    } label: {
                        if resendLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1)
                                .tint(.white)
                                .padding(.vertical, 5)
                        } else {
                            Text("Resend")
                                .fontWeight(.medium)
                        }
                    }
                }
                .font(.system(size: 18, weight: .light, design: .rounded))
                .padding(.vertical, 16)
                Button {
                    Task {
                        loading.toggle()
                        await handleSubmit(passcode: passcode.joined())
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
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 24, design: .rounded))
                    }
                }
                .foregroundColor(.white)
                .background(.black)
                .buttonStyle(.borderedProminent)
                .cornerRadius(10)
                .padding(.vertical, 16)
                .disabled(loading)
            }
            .padding()
            if showError {
                ToastView(
                    message: errorMessage!,
                    position: .bottom,
                    duration: 3.0,
                    isShowing: $showError
                )
            }
            if showSuccess {
                ToastView(
                    message: "Code sent successfully",
                    position: .bottom,
                    duration: 3.0,
                    isShowing: $showSuccess
                )
            }
        }
    }

    func handleResend() async {
        do {
            let successful = try await model.emailVerificationRequest()

            if successful {
                showSuccess = true
                successMessage = "Code sent successfully"
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

    func handleSubmit(passcode: String) async {
        do {
            let successful = try await model.verifyEmail(code: passcode)

            if successful {
                showSuccess = true
                print("Email verified successfully")
                successMessage = "Email verified successfully"
                emailVerified = true
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
    OTPView()
}
