//
//  UnsupportedDeviceView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/27/24.
//

import SwiftUI

struct UnsupportedDeviceView: View {
    var body: some View {
        ZStack {
            cameraView
            VStack {
                Spacer()
                characterImage
                InfoTitle
                InfoDescription
                Spacer()
                bottomButtons
            }
        }
    }
}

private extension UnsupportedDeviceView {
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
    
    var InfoTitle: some View {
        Text(ZipLiteral.RoomScanInfo.title)
            .foregroundStyle(Color.Text.onColorPrimary)
            .font(.title.bold())
            .padding(.bottom, 36)
        // .applyZZSFont(zzsFontSet: .title1)
    }
    
    var InfoDescription: some View {
        VStack {
            Group {
                Text(ZipLiteral.RoomScanInfo.description1)
                Text(ZipLiteral.RoomScanInfo.description2)
                    .padding(.bottom)
            }
            .foregroundStyle(Color.Text.onColorPrimary)
            .font(.body.bold())
            // .applyZZSFont(zzsFontSet: .bodyRegular)
            
            Group {
                Text(ZipLiteral.RoomScanInfo.description3)
                Text(ZipLiteral.RoomScanInfo.description4)
            }
            .foregroundStyle(Color.Text.onColorPrimary)
            .font(.body.bold())
            // .applyZZSFont(zzsFontSet: .bodyRegular)
        }
    }
    
    var bottomButtons: some View {
        VStack {
            Button {
                // TODO: 모델 이미지가 없는 상태로 결과지 시트 띄우기
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Button.primaryBlue)
                    .frame(height: 53)
                    .overlay(
                        Text(ZipLiteral.RoomScanInfo.start)
                            .foregroundStyle(Color.Text.primary)
                            // .applyZZSFont(zzsFontSet: .bodyBold)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 35)
        }
    }
}

#Preview {
    UnsupportedDeviceView()
}
