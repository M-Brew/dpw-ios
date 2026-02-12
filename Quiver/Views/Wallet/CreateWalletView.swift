//
//  CreateWalletView.swift
//  Quiver
//
//  Created by Michael Brew on 20/08/2025.
//

import SwiftUI

struct CreateWalletView: View {
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false
    
    @Binding var wallet: WalletModel?
    
    let walletService = WalletService()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .scaleEffect(1.5)
                        .padding(.vertical, 5)
                } else {
                    Image(systemName: "plus.circle.dashed")
                        .font(.largeTitle)
                        .fontWeight(.light)
                    Text("Create Wallet")
                        .font(.system(size: 20))
                        .fontWeight(.light)
                }
            }
            .onTapGesture {
                Task {
                    loading.toggle()
                    await handleCreateWallet()
                    loading.toggle()
                }
            }
            if showError {
                ToastView(message: errorMessage!, position: .top, duration: 3.0, isShowing: $showError)
            }
        }    }
    
    func handleCreateWallet() async {
        do {
            let walletData: WalletModel = try await walletService.createWallet()
            
            wallet = walletData
        } catch let apiError as WalletError {
            errorMessage = apiError.errorDescription ?? "An unexpected error occurred"
            print("error: \(apiError)")
            showError = true
        } catch {
            errorMessage = "An unexpected error occurred"
            showError = true
        }
    }
}

#Preview {
    @Previewable @State var wallet: WalletModel? = nil
    CreateWalletView(wallet: $wallet)
}
