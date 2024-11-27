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
            CameraView
            VStack {
                Spacer()
                CharacterImage
                InfoTitle
                InfoDescription
                Spacer()
                StartScanButton
                SkipScanButton
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
    
    var CameraView: some View {
        CameraViewRepresentable()
            .blur(radius: 6, opaque: true)
            .overlay {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
            }
            .ignoresSafeArea()
    }
    
    var CharacterImage: some View {
        Image(.charRoomScanInfo)
            .resizable()
            .scaledToFit()
            .frame(width: 95, height: 86)
            .padding(.bottom, 48)
    }
    
    var InfoTitle: some View {
        Text(ZipLiteral.RoomScanInfo.title)
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .title1)
            .padding(.bottom, 36)
    }
    
    var InfoDescription: some View {
        Text(ZipLiteral.RoomScanInfo.description)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
    }
    
    var StartScanButton: some View {
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
    }
    
    var SkipScanButton: some View {
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
