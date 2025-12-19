//
//  SignInViewModel.swift
//  Quiver
//
//  Created by Michael Brew on 29/08/2025.
//

import Foundation
import JWTDecode

class AuthViewModel {
    let authService = AuthService()
    let keychainManager = KeychainManager()

    func signIn(email: String, password: String) async throws -> AuthUser {
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

        let tokenPayload = try decode(jwt: authData.accessToken)
        let user: AuthUser = AuthUser(
            userId: tokenPayload["id"].string ?? "",
            name: tokenPayload["name"].string ?? "",
            email: tokenPayload["email"].string ?? "",
            emailVerified: tokenPayload["emailVerified"].boolean ?? false,
            profilePicture: tokenPayload["profilePicture"].string ?? "",
            role: tokenPayload["role"].string ?? "",
        )

        return user
    }

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        password: String
    ) async throws -> AuthUser {
        let signUpPayload = SignUpPayload(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            password: password
        )
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
        
        let tokenPayload = try decode(jwt: authData.accessToken)
        let user: AuthUser = AuthUser(
            userId: tokenPayload["id"].string ?? "",
            name: tokenPayload["name"].string ?? "",
            email: tokenPayload["email"].string ?? "",
            emailVerified: tokenPayload["emailVerified"].boolean ?? false,
            profilePicture: tokenPayload["profilePicture"].string ?? "",
            role: tokenPayload["role"].string ?? "",
        )

        return user
    }
    
    func emailVerificationRequest() async throws -> Bool {
        let successful: Bool = try await authService.emailVerificationRequest()
        
        if successful == true {
            return true
        }

        return false
    }
    
    func verifyEmail(code: String) async throws -> Bool {
        let verifyEmailPayload: VerifyEmailPayload = VerifyEmailPayload(code: code)
        let successful: Bool = try await authService.verifyEmail(payload: verifyEmailPayload)
        
        if successful == true {
            return true
        }

        return false
    }
    
    func signOut() async throws -> Bool {
        if let refreshToken = keychainManager.retrieveJWT(service: "com.Quiver.rTService") {
            let signOutPayload = SignOutPayload(token: refreshToken)
            let signOutSuccessful = try await authService.signOut(payload: signOutPayload)
            if signOutSuccessful {
                let r = keychainManager.deleteJWT(service: "com.Quiver.rTService")
                let a = keychainManager.deleteJWT(service: "com.Quiver.aTService")
                if r == errSecSuccess && a == errSecSuccess {
                    print("Sign out successful")
                    return true
                } else {
                    print("Tokens not deleted")
                    return false
                }
            }
        } else {
            print("Refresh token not found or error retrieving.")
            return false
        }
        
        return false
    }
    
    //                Button {
    //                    Task {
    //                        do {
    //                            if let refreshToken = keychainManager.retrieveJWT(service: "com.Quiver.rTService") {
    //                                print("Retrieved JWT: \(refreshToken)")
    //
    //                                let signOutPayload = SignOutPayload(token: refreshToken)
    //                                let signOutSuccessful = try await authService.signOut(payload: signOutPayload)
    //                                if signOutSuccessful == true {
    //                                    let r = keychainManager.deleteJWT(service: "com.Quiver.rTService")
    //
    //                                    let a = keychainManager.deleteJWT(service: "com.Quiver.aTService")
    //                                    if r == errSecSuccess && a == errSecSuccess {
    //                                        print("sign out successful")
    //
    //                                    isLoggedIn = false
    //                                    } else {
    //                                        print("tokens not deleted")
    //                                    }
    //                                }
    //                            } else {
    //                                print("Refresh token not found or error retrieving.")
    //                            }
    //                        } catch let apiError as AuthError {
    //                            errorMessage = apiError.errorDescription
    //                            print(apiError.errorDescription!)
    //                        } catch {
    //                            errorMessage = "An unexpected error occurred"
    //                        }
    //                    }
    //                } label: {
    //                    Text("Sign Out")
    //                        .frame(maxWidth: .infinity)
    //                        .font(.system(size: 24))
    //                }
}
