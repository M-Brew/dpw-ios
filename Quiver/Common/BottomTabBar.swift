//
//  BottomTabBar.swift
//  Quiver
//
//  Created by Michael Brew on 13/08/2025.
//

import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: String
    @State private var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 20,
                bottomLeadingRadius: 20,
                bottomTrailingRadius: 20,
                topTrailingRadius: 20
            )
            .fill(.ultraThickMaterial)
            .frame(height: 60)
            .shadow(radius: 1)
            HStack {
                Button(action: {
                    selectedTab = "dashboard"
                }) {
                    Image(systemName: "house")
                        .font(.title)
                        .foregroundStyle(selectedTab == "dashboard" ? .accent: .secondary)
                }
                Spacer()
                Button(action: {
                    selectedTab = "wallet"
                }) {
                    Image(systemName: "creditcard")
                        .font(.title)
                        .foregroundStyle(selectedTab == "wallet" ? .accent: .secondary)
                }
                Spacer()
//                if selectedTab == "dashboard" {
//                    UnevenRoundedRectangle(
//                        topLeadingRadius: 0,
//                        bottomLeadingRadius: 60,
//                        bottomTrailingRadius: 60,
//                        topTrailingRadius: 0
//                    )
//                    .fill(Color(.systemBackground))
//                    .frame(width: 60, height: 50)
//                    .padding(.bottom, 45)
//                    .overlay {
//                        Image(systemName: "paperplane.fill")
//                            .font(.title2)
//                            .padding(14)
//                            .background(
//                                Color(
//                                    red: 202 / 255,
//                                    green: 220 / 255,
//                                    blue: 174 / 255
//                                )
//                            )
//                            .clipShape(.circle)
//                            .padding(.bottom, 5)
//                            .offset(y: -25)
//                            .shadow(radius: 1)
//                    }
//                    .onTapGesture {
//                        isPresented = true
//                    }
//                }
//                Spacer()
                Button(action: {
                    selectedTab = "transactions"
                }) {
                    Image(
                        systemName:
                            "rectangle.and.arrow.up.right.and.arrow.down.left"
                    )
                    .font(.title)
                    .foregroundStyle(selectedTab == "transactions" ? .accent: .secondary)
                }
                Spacer()
                Button(action: {
                    selectedTab = "settings"
                }) {
                    Image(systemName: "gear")
                        .font(.title)
                        .foregroundStyle(selectedTab == "settings" ? .accent: .secondary)
                }
            }
            .padding()
//            .navigationDestination(isPresented: $isPresented) {
//                SelectRecipientView()
//            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        BottomTabBar(selectedTab: .constant("dashboard"))
            .padding()
        BottomTabBar(selectedTab: .constant("wallet"))
            .padding()
    }
}
