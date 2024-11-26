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
    let roomController = RoomPlanManager.shared
    
    var body: some View {
        VStack {
            Spacer()
            scanningButton
        }
    }
}

private extension ScanningView {
    // MARK: - View
    
    var scanningButton: some View {
        HStack(spacing: 8) {
            Button {
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Button.secondaryBlue)
                    .frame(height: 53)
                    .overlay(
                        Text(ZipLiteral.RoomScan.cancle)
                            .foregroundStyle(Color.Text.secondary)
                            // .applyZZSFont(zzsFontSet: .bodyBold)
                    )
            }
            
            Button {
                roomController.stopSession()
                doneScanning = true
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Button.primaryBlue)
                    .frame(height: 53)
                    .overlay(
                        Text(ZipLiteral.RoomScan.done)
                            .foregroundStyle(Color.Text.primary)
                            // .applyZZSFont(zzsFontSet: .bodyBold)
                    )
            }
        }
        .padding(.horizontal, 16)
    }
}
