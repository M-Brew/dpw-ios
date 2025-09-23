//
//  ToastView.swift
//  Quiver
//
//  Created by Michael Brew on 18/08/2025.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var position: ToastPosition = .bottom
    var duration: Double = 2.0
    
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            VStack {
                if position == .top {
                    ToastContent
                        .transition(.move(edge: .top))
                        .padding(.top, 70)
                }
                Spacer()
                if position == .bottom {
                    ToastContent
                        .transition(.move(edge: .bottom))
                        .padding(.bottom, 50)

                }
            }
            .ignoresSafeArea(.all)
            .onAppear {
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        isShowing = false
                    }
                }
            }
        }
    }
    
    private var ToastContent: some View {
        HStack {
            Text(message)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
        }
        .padding()
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    enum ToastPosition {
        case top
        case bottom
    }
}

#Preview {
    ToastView(message: "Invalid email or password", isShowing: .constant(true))
}
