//
//  PhoneNumberView.swift
//  Quiver
//
//  Created by Michael Brew on 15/08/2025.
//

import SwiftUI

struct PhoneNumberField: View {
    @State private var rawPhoneNumber: String = ""

    var body: some View {
        TextField(
            "Phone Number",
            text: Binding(
                get: {
                    // Apply formatting for display
                    return formatPhoneNumber(rawPhoneNumber)
                },
                set: { newValue in
                    // Remove non-digit characters for internal storage
                    rawPhoneNumber = newValue.filter { $0.isNumber }
                }
            )
        )
        .keyboardType(.numberPad)
        .frame(height: 48)
        .padding(.horizontal, 10)
        .background(.regularMaterial)
        .cornerRadius(10)
        .font(.system(size: 20))
        .padding(.bottom, 10)
    }

    func formatPhoneNumber(_ number: String) -> String {
        // Implement your desired formatting logic here
        // Example: (XXX) XXX-XXXX
        var formatted = ""
        let cleaned = number.filter { $0.isNumber }

        if cleaned.count > 0 {
            formatted += "(" + String(cleaned.prefix(3))
        }
        if cleaned.count > 3 {
            formatted +=
                ") "
                + String(
                    cleaned[
                        cleaned.index(
                            cleaned.startIndex,
                            offsetBy: 3
                        )..<min(
                            cleaned.endIndex,
                            cleaned.index(cleaned.startIndex, offsetBy: 6)
                        )
                    ]
                )
        }
        if cleaned.count > 6 {
            formatted += "-" + String(cleaned.suffix(cleaned.count - 6))
        }
        return formatted
    }
}

#Preview {
    PhoneNumberField()
}
