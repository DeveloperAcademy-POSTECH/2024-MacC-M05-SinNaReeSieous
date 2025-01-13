//
//  RoomScanInfoView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/27/24.
//

import SwiftUI

struct RoomScanInfoView: View {
    @State var showAlert: Bool = false
    @State var showResultCard: Bool = false
    @Binding var model: UIImage?
    @Binding var homeData: HomeData
    @Binding var showHomeHuntSheet: Bool
    
    var body: some View {
        ZStack {
            CameraView
            VStack(spacing: 0) {
                Spacer()
                CharacterImage
                InfoTitle
                InfoDescription
                ExempleRoomModel
                Spacer()
                StartScanButton
                SkipScanButton
            }
        }
        .alert(ZipLiteral.Alert.skipAlertTitle, isPresented: $showAlert) {
            Button(ZipLiteral.Alert.cancel, role: .cancel) { }
                .tint(.blue)
            
            Button(ZipLiteral.RoomScanInfo.skip, role: .destructive) {
                showResultCard = true
            }
        } message: {
            Text(ZipLiteral.Alert.skipAlertMessage)
                .multilineTextAlignment(.center)
        }
        .fullScreenCover(isPresented: $showResultCard) {
            ResultCardView(model: $model, homeData: $homeData, showHomeHuntSheet: $showHomeHuntSheet)
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
            .padding(.bottom, 24)
    }
    
    var ExempleRoomModel: some View {
        Image(.exRoomScanInfo)
            .resizable()
            .scaledToFit()
            .frame(height: 93)
    }
    
    var StartScanButton: some View {
        NavigationLink(destination: RoomScanView(model: $model, homeData: $homeData, showHomeHuntSheet: $showHomeHuntSheet)) {
            withAnimation(.easeOut(duration: 1)) {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Button.primaryBlue)
                    .frame(height: 53)
                    .overlay(
                        Text(ZipLiteral.RoomScanInfo.start)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .bodyBold)
                    )
            }
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
