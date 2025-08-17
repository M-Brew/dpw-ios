//
//  PasswordField.swift
//  Quiver
//
//  Created by Michael Brew on 12/08/2025.
//

import SwiftUI

struct PasswordField: View {
    @State private var hidden = true
    @Binding var password: String

    var body: some View {
        ZStack(alignment: .trailing) {
            if hidden {
                SecureField("Password", text: $password)
                    .frame(height: 48)
                    .padding(.horizontal, 10)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    .font(.system(size: 20))
            } else {
                TextField("Password", text: $password)
                    .frame(height: 48)
                    .padding(.horizontal, 10)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    .font(.system(size: 20))
            }
            Button(
                action: {
                    hidden = !hidden
                },
                label: {
                    Image(systemName: !hidden ? "eye.slash" : "eye")
                        .foregroundColor(.black)
                        .padding()
                }
            )
            .animation(.easeInOut(duration: 0.3), value: hidden)
        }
    }
}

#Preview {
    @Previewable @State var password = ""

    PasswordField(password: $password)
}
