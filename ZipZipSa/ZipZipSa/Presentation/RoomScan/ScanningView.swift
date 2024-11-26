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
        HStack {
            Button {
                // TODO: 이전 뷰(RoomScanInfoView)로 돌아가기
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.gray)
                    .frame(width: 165, height: 50)
                    .overlay(
                        Text(ZipLiteral.RoomScan.cancle)
                            .foregroundStyle(Color.white)
                    )
            }
            
            Spacer()
                .frame(width: 20)
            
            Button {
                roomController.stopSession()
                doneScanning = true
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.primary)
                    .frame(width: 165, height: 50)
                    .overlay(
                        Text(ZipLiteral.RoomScan.done)
                            .foregroundStyle(Color.white)
                    )
            }
        }
    }
}
