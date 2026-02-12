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
                    .font(.system(size: 20))
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3))
                    )
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            } else {
                TextField("Password", text: $password)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3))
                    )
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
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
