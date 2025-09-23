//
//  DashboardView.swift
//  Quiver
//
//  Created by Michael Brew on 12/08/2025.
//

import SwiftUI

struct DashboardView: View {
    @AppStorage("name") private var name = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 254 / 255, green: 232 / 255, blue: 217 / 255)
                .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            AsyncImage(
                                url: URL(
                                    string:
                                        "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?q=80&w=1064&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                                )
                            ) { image in
                                image
                                    .image?.resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(.circle)
                            .padding(.trailing, 10)
                            VStack(alignment: .leading) {
                                Text("Hello \(name == "" ? "" : name.split(separator: " ")[0])")
                                    .font(.title)
                                Text("Welcome")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            Button(action: {
                                print("Notifications")
                            }) {
                                Label("Notifictions", systemImage: "bell")
                                    .labelStyle(.iconOnly)
                            }
                            .font(.title)
                            .foregroundColor(.black)
                        }
                        .padding()
                        VStack(alignment: .leading) {
                            Text("Current Balance")
                                .font(.subheadline)
                                .fontWeight(.light)
                            Text(100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.largeTitle)
                                .padding(.vertical)
                            HStack {
                                Button(action: {
                                    print("Deposit")
                                }) {
                                    Label("DEPOSIT", systemImage: "arrow.down.left")
                                }
                                .font(.subheadline)
                                .buttonStyle(.bordered)
                                .foregroundColor(.white)
                                .background(.black)
                                .buttonStyle(.borderedProminent)
                                .cornerRadius(10)
                                Button(action: {
                                    print("Withdraw")
                                }) {
                                    Label("WITHDRAW", systemImage: "arrow.up.right")
                                }
                                .font(.subheadline)
                                .buttonStyle(.bordered)
                                .foregroundColor(.black)
                                .buttonStyle(.borderedProminent)
                                .cornerRadius(10)
                                Spacer()
                                Button(action: {
                                    print("Wallet")
                                }) {
                                    Label("Wallet", systemImage: "creditcard.fill")
                                        .labelStyle(.iconOnly)
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 3)
                        .padding(.vertical, 15)
                        .padding(.horizontal)
                        Rectangle()
                            .frame(height: 0.3)
                            .padding(.horizontal)
                        HStack {
                            VStack {
                                Image(systemName: "paperplane.fill")
                                    .padding()
                                    .background(
                                        Color(
                                            red: 202 / 255,
                                            green: 220 / 255,
                                            blue: 174 / 255
                                        )
                                    )
                                    .clipShape(.circle)
                                    .padding(.bottom, 5)
                                Text("Send")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "qrcode.viewfinder")
                                    .padding()
                                    .background(
                                        Color(
                                            red: 237 / 255,
                                            green: 160 / 255,
                                            blue: 90 / 255
                                        )
                                    )
                                    .clipShape(.circle)
                                    .padding(.bottom, 5)
                                Text("Pay")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "doc.text.viewfinder")
                                    .padding()
                                    .background(
                                        Color(
                                            red: 225 / 255,
                                            green: 233 / 255,
                                            blue: 201 / 255
                                        )
                                    )
                                    .clipShape(.circle)
                                    .padding(.bottom, 5)
                                Text("Invoice")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "chart.bar.fill")
                                    .padding()
                                    .background(.white)
                                    .clipShape(.circle)
                                    .padding(.bottom, 5)
                                Text("Chart")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                        }
                        .padding()
                        .padding(.horizontal)
                        Rectangle()
                            .frame(height: 0.3)
                            .padding([.horizontal, .bottom])
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Transactions")
                                    .font(.title2)
                                Spacer()
                                Text("See All")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            .padding(.bottom)
                            TransactionItem()
                                .padding(.bottom)
                            TransactionItem()
                                .padding(.bottom)
                            TransactionItem()
                                .padding(.bottom)
                            TransactionItem()
                                .padding(.bottom)
                            TransactionItem()
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 20)
                        .padding(.horizontal)
                        .background(.white)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30)))
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
