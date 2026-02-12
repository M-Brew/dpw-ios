//
//  CreateInvoiceView.swift
//  Quiver
//
//  Created by Michael on 27/01/2026.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct QRCodeInvoicePayload: Codable {
    let contact: ContactModel
    let amount: Double
    let note: String
}

struct CreateInvoiceView: View {
    let wallet: WalletModel

    @State private var amount: String = "0.00"
    @State private var note: String = ""
    @State private var loading: Bool = false
    @State private var invoiceDetails: QRCodeInvoicePayload? = nil
    @State private var showingQRCode: Bool = false

    let now = Date()

    var body: some View {
        VStack(spacing: 10) {
            Text("Invoice")
                .font(.largeTitle)
            Text(now.formatted(date: .long, time: .omitted))
                .font(.system(size: 14, weight: .ultraLight, design: .rounded))
                .padding(.bottom, 40)
            VStack(alignment: .leading) {
                Text("AMOUNT:")
                    .font(.system(size: 12, weight: .light))
                HStack {
                    Text("GH₵")
                        .font(.title)
                        .foregroundColor(.secondary)
                    TextField(
                        "",
                        text: $amount,
                    )
                    .font(
                        .system(
                            size: 42,
                            weight: .regular,
                            design: .rounded
                        )
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3)
            .padding(.bottom)
            VStack(alignment: .leading) {
                Text("NOTE:")
                    .font(.system(size: 12, weight: .light))
                TextField("Note", text: $note, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3)
            Spacer()
            Button {
                let contact: ContactModel = ContactModel(
                    id: wallet.id,
                    walletId: wallet.id,
                    code: wallet.code,
                    userId: wallet.userId,
                    userName: wallet.userName,
                    userImage: wallet.userImage,
                    status: wallet.status
                )
                invoiceDetails = QRCodeInvoicePayload(
                    contact: contact,
                    amount: Double(amount) ?? 0,
                    note: note
                )
                showingQRCode = true
            } label: {
                if loading == true {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .scaleEffect(0.7)
                        .tint(.white)
                        .padding(.vertical, -7)
                } else {
                    Text("Generate Invoice QR Code")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20, design: .rounded))
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(loading || Double(amount) ?? 0 < 1 || note.isEmpty)
        }
        .padding()
        .sheet(isPresented: $showingQRCode) {
            InvoiceQRCodeView(invoiceDetails: $invoiceDetails, amount: $amount, note: $note)
        }
    }
}

struct InvoiceQRCodeView: View {
    @Binding var invoiceDetails: QRCodeInvoicePayload?
    @Binding var amount: String
    @Binding var note: String
    
    @Environment(\.dismiss) var dismiss
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .padding()
            }
            Spacer()
            if let invoiceDetails {
                if let qrImage = generateJSONQR(from: invoiceDetails) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    Text("Error generating QR Code")
                }
            } else {
                Text("Error generating QR Code")
            }
            Spacer()
            Button {
                amount = "0.00"
                note = ""
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 20, design: .rounded))
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }

    func generateJSONQR(from object: QRCodeInvoicePayload) -> UIImage? {
        guard let jsonData = try? JSONEncoder().encode(object),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else { return nil }

        filter.message = Data(jsonString.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(
                outputImage,
                from: outputImage.extent
            ) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}

#Preview {
//    InvoiceQRCodeView(invoiceDetails: .constant(nil), amount: .constant(""), note: .constant(""))
    @Previewable @State var wallet: WalletModel = WalletModel(
        id: "",
        userId: "",
        userName: "Michael Brew",
        userImage: "",
        code: "1234ASDF",
        balance: 100,
        currency: "GH₵",
        status: "active",
        contacts: [],
        createdAt: "",
        updatedAt: ""
    )

    CreateInvoiceView(wallet: wallet)
}
