//
//  WelcomeView.swift
//  Quiver
//
//  Created by Michael Brew on 11/08/2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showSignUpView = false
    @State private var showSignInView = false

    var body: some View {
        ZStack {
            Image("bg-4")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                Text("Quiver")
                    .font(.system(size: 64, weight: .semibold, design: .serif))
                    .padding(.bottom, 3)
                Text("Lorem ipsum dolor sit amet elit")
                    .font(.system(size: 20, weight: .light, design: .rounded))
                Text("Consectetur adipiscing")
                    .font(.system(size: 20, weight: .light, design: .rounded))
                HStack(spacing: 10) {
                    Button(action: {
                        showSignUpView = true
                    }) {
                        Text("Get Started")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Button(action: {
                        showSignInView = true
                    }) {
                        Text("Sign In")
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(
                        Color(
                            red: 237 / 255,
                            green: 160 / 255,
                            blue: 90 / 255
                        )
                    )
                }
                .padding([.top, .bottom])
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationDestination(isPresented: $showSignUpView) {
            SignUpView()
        }
        .navigationDestination(isPresented: $showSignInView) {
            SignInView()
        }
    }
}

#Preview {
    WelcomeView()
}
