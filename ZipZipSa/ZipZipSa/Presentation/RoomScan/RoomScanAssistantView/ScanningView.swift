//
//  ScanningView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/26/24.
//

import SwiftUI

struct ScanningView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var doneScanning: Bool
    @State var showAlert: Bool = false
    let roomManager: RoomPlanManager
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 8) {
                QuitScanButton
                DoneScanButton
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .alert(ZipLiteral.Alert.quitAlertTitle, isPresented: $showAlert) {
            Button(ZipLiteral.Alert.cancel, role: .cancel) { }
            
            Button(ZipLiteral.Alert.quit, role: .destructive) {
                dismiss()
            }
        } message: {
            Text(ZipLiteral.Alert.quitAlertMessage)
                .multilineTextAlignment(.center)
        }
    }
}

private extension ScanningView {
    // MARK: - View
    
    var QuitScanButton: some View {
        Button {
            showAlert = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.Button.secondaryBlue)
                .frame(height: 53)
                .overlay(
                    Text(ZipLiteral.RoomScan.cancle)
                        .foregroundStyle(Color.Text.secondary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                )
        }
        
    }
    
    var DoneScanButton: some View {
        Button {
            roomManager.stopSession()
            doneScanning = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.Button.primaryBlue)
                .frame(height: 53)
                .overlay(
                    Text(ZipLiteral.RoomScan.done)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                )
        }
    }
}
