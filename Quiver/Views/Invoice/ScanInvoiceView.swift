//
//  ScanInvoiceView.swift
//  Quiver
//
//  Created by Michael on 27/01/2026.
//

import SwiftUI
import VisionKit

struct ScanInvoiceView: View {
    let wallet: WalletModel
    
    @State private var decodedPayload: QRCodeInvoicePayload? = nil
    @State private var showScan: Bool = false

    var body: some View {
        VStack {
            if let decodedPayload {
                PaymentSummaryView(
                    wallet: wallet,
                    contact: decodedPayload.contact,
                    amount: String(decodedPayload.amount),
                    note: decodedPayload.note
                )
            } else {
                Button {
                    showScan = true
                } label: {
                    Text("Tap to scan")
                }
            }
        }
        .sheet(isPresented: $showScan) {
//            ScanInvoiceContainer(decodedPayload: $decodedPayload)
            ZStack {
                ScanInvoice(decodedPayload: $decodedPayload)
                VStack {
                    Spacer()
                    VStack {
                        Text("Place the QR code within frame")
                            .padding()
                        Button {
                            showScan = false
                        } label: {
                            Text("Cancel")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.secondary)
                        .controlSize(.large)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 3)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct ScannerOverlay: Shape {
    let cutoutSize: CGSize

    func path(in rect: CGRect) -> Path {
        var path = Path()
        // 1. Fill the whole screen
        path.addRect(rect)
        
        // 2. Define the cutout area
        let cutoutRect = CGRect(
            x: (rect.width - cutoutSize.width) / 2,
            y: (rect.height - cutoutSize.height) / 2,
            width: cutoutSize.width,
            height: cutoutSize.height
        )
        
        // 3. Add the cutout as a rounded rect
        path.addRoundedRect(in: cutoutRect, cornerSize: CGSize(width: 20, height: 20))
        
        return path
    }
}

struct ScanInvoice: UIViewControllerRepresentable {
    @Binding var decodedPayload: QRCodeInvoicePayload?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.qr])],
            qualityLevel: .balanced,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(
        _ uiViewController: DataScannerViewController,
        context: Context
    ) {
        try? uiViewController.startScanning()
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: ScanInvoice

        // Track if we've already found a valid code to prevent duplicate processing
        private var isProcessing = false

        init(_ parent: ScanInvoice) {
            self.parent = parent
        }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didAdd addedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {
            // Stop if we are already in the process of dismissing or handling a hit
            guard !isProcessing else { return }

            for item in addedItems {
                if case .barcode(let barcode) = item,
                    let jsonString = barcode.payloadStringValue,
                    let jsonData = jsonString.data(using: .utf8)
                {

                    let decoder = JSONDecoder()

                    // Attempt to decode
                    if let payload = try? decoder.decode(
                        QRCodeInvoicePayload.self,
                        from: jsonData
                    ) {

                        // Trigger haptic feedback so the user knows it worked
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)

                        // Lock processing and update UI
                        isProcessing = true
                        print(payload)

                        DispatchQueue.main.async {
                            self.parent.decodedPayload = payload
                            self.parent.dismiss()
                        }

                        // Break loop once the first valid invoice is found
                        break
                    }
                }
            }
        }
    }

    //    class Coordinator: NSObject, DataScannerViewControllerDelegate {
    //        var parent: ScanInvoice
    //        private var hasCaptured = false
    //
    //        init(_ parent: ScanInvoice) {
    //            self.parent = parent
    //        }
    //
    //        func dataScanner(
    //            _ dataScanner: DataScannerViewController,
    //            didTapOn item: RecognizedItem
    //        ) {
    //            if case .barcode(let barcode) = item,
    //                let jsonString = barcode.payloadStringValue,
    //                let jsonData = jsonString.data(using: .utf8)
    //            {
    //
    //                // Decode the JSON back into the struct
    //                let decoder = JSONDecoder()
    //                if let payload = try? decoder.decode(
    //                    QRCodeInvoicePayload.self,
    //                    from: jsonData
    //                ) {
    //                    print(payload)
    //                    parent.decodedPayload = payload
    //                    parent.dismiss()
    //                }
    //            }
    //        }
    //    }
}

struct ScanInvoiceContainer: View {
    @Binding var decodedPayload: QRCodeInvoicePayload?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // The Scanner
            ScanInvoice(decodedPayload: $decodedPayload)
                .ignoresSafeArea()
            
            // The Darkened Background with Cutout
            ScannerOverlay(cutoutSize: CGSize(width: 250, height: 250))
                .fill(Color.black.opacity(0.5), style: FillStyle(eoFill: true))
                .ignoresSafeArea()
            
            // The Visual Frame
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 250, height: 250)
            
            VStack {
                Text("Align QR code within the frame")
                    .foregroundColor(.white)
                    .padding(.top, 50)
                Spacer()
            }
        }
    }
}

#Preview {
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
    
    ScanInvoiceView(wallet: wallet)
}
