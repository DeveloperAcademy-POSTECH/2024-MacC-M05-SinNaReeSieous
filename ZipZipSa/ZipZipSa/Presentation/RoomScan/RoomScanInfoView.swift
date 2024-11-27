//
//  RoomScanInfoView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/27/24.
//

import SwiftUI

struct RoomScanInfoView: View {
    @Binding var isSessionStarted: Bool
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            cameraView
            VStack {
                Spacer()
                characterImage
                infoTitle
                infoDescription
                Spacer()
                bottomButtons
            }
        }
        .alert(ZipLiteral.Alert.skipAlertTitle, isPresented: $showAlert) {
            Button(ZipLiteral.Alert.cancel, role: .cancel) { }
            
            Button(ZipLiteral.RoomScanInfo.skip, role: .destructive) {
                // TODO: 모델 이미지가 없는 상태로 결과지 시트 띄우기
            }
        } message: {
            Text(ZipLiteral.Alert.skipAlertMessage)
                .multilineTextAlignment(.center)
        }
    }
}

private extension RoomScanInfoView {
    // MARK: - View
    
    var cameraView: some View {
        CameraViewRepresentable()
            .overlay {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
            }
            .blur(radius: 6)
            .ignoresSafeArea()
    }
    
    var characterImage: some View {
        Image(.charRoomScanInfo)
            .resizable()
            .scaledToFit()
            .frame(width: 95, height: 86)
            .padding(.bottom, 48)
    }
    
    var infoTitle: some View {
        Text(ZipLiteral.RoomScanInfo.title)
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .title1)
            .padding(.bottom, 36)
    }
    
    var infoDescription: some View {
        Text(ZipLiteral.RoomScanInfo.description)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
    }
    
    var bottomButtons: some View {
        VStack {
            Button {
                withAnimation(.easeInOut(duration: 1)) {
                    isSessionStarted = true
                }
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Button.primaryBlue)
                    .frame(height: 53)
                    .overlay(
                        Text(ZipLiteral.RoomScanInfo.start)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .bodyBold)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 22)
            
            Button {
                showAlert = true
            } label: {
                Text(ZipLiteral.RoomScanInfo.skip)
                    .foregroundStyle(Color.Text.onColorSecondary)
                    .applyZZSFont(zzsFontSet: .bodyBold)
            }
            .padding(.bottom, 35)
        }
    }
}
