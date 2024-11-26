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
                UnsupportedTitle
                UnsupportedDescription
                Spacer()
                bottomButton
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
        Image(.charUnsupportedDevice)
            .resizable()
            .scaledToFit()
            .frame(width: 95, height: 86)
            .padding(.bottom, 20)
    }
    
    var UnsupportedTitle: some View {
        Group {
            Text(ZipLiteral.UnsupportedDevice.title1)
            Text(ZipLiteral.UnsupportedDevice.title2)
                .padding(.bottom, 27)
        }
        .foregroundStyle(Color.Text.onColorPrimary)
        .font(.title.bold())
        // .applyZZSFont(zzsFontSet: .title1)
    }
    
    var UnsupportedDescription: some View {
        VStack {
            Group {
                Text(ZipLiteral.UnsupportedDevice.description1)
                Text(ZipLiteral.UnsupportedDevice.description2)
                    .padding(.bottom)
            }
            .foregroundStyle(Color.Text.onColorPrimary)
            .font(.body.bold())
            // .applyZZSFont(zzsFontSet: .bodyRegular)
            
            Text(ZipLiteral.UnsupportedDevice.description3)
                .foregroundStyle(Color.Text.onColorPrimary)
                .font(.body.bold())
                // .applyZZSFont(zzsFontSet: .bodyRegular)
        }
    }
    
    var bottomButton: some View {
        VStack {
            Button {
                // TODO: 모델 이미지가 없는 상태로 결과지 시트 띄우기
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Button.primaryBlue)
                    .frame(height: 53)
                    .overlay(
                        Text(ZipLiteral.UnsupportedDevice.showResult)
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
