//
//  DismissKeyboard.swift
//  Quiver
//
//  Created by Michael on 28/01/2026.
//

import SwiftUI

extension UIApplication {
    func dismissKeyboard() {
        self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.endEditing(true) }
    }
}

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.dismissKeyboard()
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardOnTap())
    }
}
