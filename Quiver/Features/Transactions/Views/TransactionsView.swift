//
//  TransactionsView.swift
//  Quiver
//
//  Created by Michael Brew on 10/09/2025.
//

import SwiftUI
import Charts

struct SalesData: Identifiable {
    let id = UUID()
    let month: String
    let sales: Int
}

let salesData = [
    SalesData(month: "Jan", sales: 200),
    SalesData(month: "Feb", sales: 150),
    SalesData(month: "Mar", sales: 180)
]

struct TransactionsView: View {
    var body: some View {
        Chart {
            ForEach(salesData) { data in
                BarMark(x: .value("month", data.month), y: .value("sales", data.sales))
            }
        }
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    TransactionsView()
}
